codeunit 58104 "Engineer Appointments"
{
    var
        ProdIDTxt: Label '//Microsoft Corporation//Outlook 16.0 MIMEDIR//EN';
        DateTimeFormatTxt: Label '<Year4><Month,2><Day,2>T<Hours24,2><Minutes,2><Seconds,2>', Locked = true;

    /// <summary>
    /// Procedure to send email
    /// </summary>
    /// <param name="RecEngineerBooking"></param>
    procedure CreateAndSend(RecEngineerBooking: Record "Engineer Bookings")
    var
        TempEmailItem: Record "Email Item" temporary;
    begin
        if CreateRequest(TempEmailItem, RecEngineerBooking) then begin
            TempEmailItem.Send(true, Enum::"Email Scenario"::Default);
            RecEngineerBooking."Invite Sent" := true;
            RecEngineerBooking.Modify(true);
        end;
    end;

    /// <summary>
    /// Procedure to create request for email
    /// </summary>
    /// <param name="TempEmailItem"></param>
    /// <param name="RecEngineerBooking"></param>
    /// <returns></returns>
    procedure CreateRequest(var TempEmailItem: Record "Email Item" temporary; RecEngineerBooking: Record "Engineer Bookings"): Boolean
    var
        Email: Text[100];
    begin
        Email := GetResourceEmail(RecEngineerBooking."Engineer Code");

        if Email <> '' then begin
            GenerateEmail(TempEmailItem, Email, RecEngineerBooking);
            exit(true);
        end
        else begin
            Error('Please provide email to schedule appointment');
        end;
    end;

    /// <summary>
    /// Procedure to generate email with .ics attachment
    /// </summary>
    /// <param name="TempEmailItem"></param>
    /// <param name="RecipientEmail"></param>
    /// <param name="RecEngineerBooking"></param>
    local procedure GenerateEmail(var TempEmailItem: Record "Email Item" temporary; RecipientEmail: Text[100]; RecEngineerBooking: Record "Engineer Bookings")
    var
        TempBlob: Codeunit "Temp Blob";
        Stream: OutStream;
        InStream: Instream;
        ICS, Filename : Text;
    begin
        Clear(Filename);
        Clear(ICS);

        ICS := GenerateICS(RecEngineerBooking);
        TempBlob.CreateOutStream(Stream, TextEncoding::UTF8);
        Stream.Write(ICS);
        TempBlob.CreateInStream(InStream);

        TempEmailItem.Initialize();

        if RecEngineerBooking."Project Description" <> '' then begin
            Filename := RecEngineerBooking."Project Description";
            TempEmailItem.Subject := RecEngineerBooking."Project Description";
        end
        else begin
            Filename := RecEngineerBooking."Project No.";
            TempEmailItem.Subject := RecEngineerBooking."Project No.";
        end;

        TempEmailItem.AddAttachment(InStream, StrSubstNo('%1.ics', Filename));
        TempEmailItem."Send to" := RecipientEmail;
    end;

    /// <summary>
    /// Procedure to create ics file
    /// </summary>
    /// <param name="RecEngineerBooking"></param>
    /// <returns></returns>
    local procedure GenerateICS(RecEngineerBooking: Record "Engineer Bookings") ICS: Text
    var
        TextBuilder: TextBuilder;
        Location: Text;
        Summary: Text;
        Status: Text;
        Method: Text;
        Description: Text;
        Organizer: Text;
    begin
        Summary := StrSubstNo('%1 : %2', RecEngineerBooking."Project No.", RecEngineerBooking."Project Description");

        Method := 'REQUEST';
        Status := 'BUSY';
        Organizer := GetOrganizer();

        Description := GetDescription(RecEngineerBooking);

        TextBuilder.AppendLine('BEGIN:VCALENDAR');
        TextBuilder.AppendLine('PRODID:-' + ProdIDTxt);
        TextBuilder.AppendLine('VERSION:2.0');
        TextBuilder.AppendLine('METHOD:' + Method);
        TextBuilder.AppendLine('X-MS-OLK-FORCEINSPECTOROPEN:TRUE');
        TextBuilder.AppendLine('BEGIN:VEVENT');
        TextBuilder.AppendLine('CLASS:PUBLIC');
        TextBuilder.AppendLine('UID:' + DelChr(CreateGuid(), '<>', '{}'));
        TextBuilder.AppendLine('ORGANIZER:MAILTO:' + Organizer);
        TextBuilder.AppendLine('LOCATION:' + GetLocation(RecEngineerBooking."Engineer Code"));
        TextBuilder.AppendLine('DTSTART:' + GetStartDate(RecEngineerBooking));
        TextBuilder.AppendLine('DTEND:' + GetEndDate(RecEngineerBooking));
        TextBuilder.AppendLine('PRIORITY:5');
        TextBuilder.AppendLine('SEQUENCE:0');
        TextBuilder.AppendLine('SUMMARY:' + Summary);
        TextBuilder.AppendLine('TRANSP:OPAQUE');
        TextBuilder.AppendLine('DESCRIPTION:' + Description);
        TextBuilder.AppendLine('X-ALT-DESC;FMTTYPE=' + GetHtmlDescription(Description));
        TextBuilder.AppendLine('X-MICROSOFT-CDO-BUSYSTATUS:BUSY');
        TextBuilder.AppendLine('X-MICROSOFT-CDO-IMPORTANCE:1');
        TextBuilder.AppendLine('X-MICROSOFT-CDO-INTENDEDSTATUS:BUSY');
        TextBuilder.AppendLine('X-MICROSOFT-DISALLOW-COUNTER:TRUE');
        TextBuilder.AppendLine('X-MS-OLK-CONFTYPE:0');
        TextBuilder.AppendLine('STATUS:' + Status);

        TextBuilder.AppendLine('BEGIN:VALARM');
        TextBuilder.AppendLine('TRIGGER:-PT15M');
        TextBuilder.AppendLine('ACTION:DISPLAY');
        TextBuilder.AppendLine('DESCRIPTION:Reminder');
        TextBuilder.AppendLine('END:VALARM');
        TextBuilder.AppendLine('END:VEVENT');
        TextBuilder.AppendLine('END:VCALENDAR');

        ICS := TextBuilder.ToText();
    end;

    /// <summary>
    /// Procedure to generate description for ics file
    /// </summary>
    /// <param name="RecEngineerBooking"></param>
    /// <returns></returns>
    local procedure GetDescription(RecEngineerBooking: Record "Engineer Bookings") AppointmentDescription: Text
    var
        AppointmentFormat: Text;
    begin
        AppointmentFormat := RecEngineerBooking.FieldCaption(Engineer) + ': %1\n';
        AppointmentFormat += RecEngineerBooking.FieldCaption("Work Type") + ': %2\n\n';
        AppointmentFormat += RecEngineerBooking.FieldCaption("Project No.") + ': %3\n';
        AppointmentFormat += RecEngineerBooking.FieldCaption("Project Description") + ': %4\n\n';
        AppointmentFormat += RecEngineerBooking.FieldCaption(Notes) + ': %5\n';
        AppointmentDescription := StrSubstNo(AppointmentFormat,
            RecEngineerBooking.Engineer, RecEngineerBooking."Work Type", RecEngineerBooking."Project No.", RecEngineerBooking."Project Description", RecEngineerBooking.Notes);
    end;

    /// <summary>
    /// Procedure to get organizer email
    /// </summary>
    /// <returns></returns>
    local procedure GetOrganizer(): Text
    var
        ProjectManagerUser: Record User;
        EmailAccount: Record "Email Account";
        EmailScenario: Codeunit "Email Scenario";
    begin
        ProjectManagerUser.SetRange("User Name", UserId());
        ProjectManagerUser.SetFilter("Authentication Email", '<>%1', '');
        if ProjectManagerUser.FindFirst() then
            exit(ProjectManagerUser."Authentication Email");

        EmailScenario.GetEmailAccount(Enum::"Email Scenario"::Default, EmailAccount);
        exit(EmailAccount."Email Address");
    end;

    /// <summary>
    /// Procedure to get start date and time for appointment 
    /// </summary>
    /// <param name="RecEngineerBooking"></param>
    /// <returns></returns>
    local procedure GetStartDate(RecEngineerBooking: Record "Engineer Bookings") StartDateTime: Text
    var
        StartDate: DateTime;
        StartTime: Time;
    begin
        StartDate := CreateDateTime(RecEngineerBooking.Date, RecEngineerBooking.StartTime);
        Evaluate(StartTime, Format(8));
        StartDateTime := Format(StartDate, 0, DateTimeFormatTxt);
    end;

    /// <summary>
    /// Convert the Hours worked into the milliseconds
    /// </summary>
    /// <param name="decimalHours"></param>
    /// <returns></returns>
    procedure ConvertDecimalHoursToMilliseconds(decimalHours: Decimal): BigInteger
    var
        MillisecondsPerHour: BigInteger;
        TotalMilliseconds: BigInteger;
    begin
        MillisecondsPerHour := 60 * 60 * 1000; // 3600000 milliseconds in an hour
        TotalMilliseconds := Round(decimalHours * MillisecondsPerHour);
        exit(TotalMilliseconds);
    end;

    /// <summary>
    /// Procedure to get end date and time for appointment
    /// </summary>
    /// <param name="RecEngineerBooking"></param>
    /// <returns></returns>
    procedure GetEndDate(RecEngineerBooking: Record "Engineer Bookings") EndDateTime: Text
    var
        EndDate: DateTime;
        StartTime: Time;
        Duration: Integer;
    begin

        EndDate := CreateDateTime(RecEngineerBooking.Date, RecEngineerBooking.StartTime);
        Evaluate(StartTime, Format(8));
        Duration := ConvertDecimalHoursToMilliseconds(RecEngineerBooking."Hours Worked");
        EndDateTime := Format((EndDate + Duration), 0, DateTimeFormatTxt);
    end;

    /// <summary>
    /// Procedure to generate Html description for ics file
    /// </summary>
    /// <param name="Description"></param>
    /// <returns></returns>
    local procedure GetHtmlDescription(Description: Text) HtmlAppointDescription: Text
    var
        Regex: Codeunit Regex;
    begin
        HtmlAppointDescription := Regex.Replace(Description, '\\r', '');
        HtmlAppointDescription := Regex.Replace(HtmlAppointDescription, '\\n', '<br>');
        HtmlAppointDescription := 'text/html:<html><body>' + HtmlAppointDescription + '</html></body>';
    end;

    /// <summary>
    /// Procedure to get resource email to send appointment
    /// </summary>
    /// <param name="ResourceNo"></param>
    /// <returns></returns>
    local procedure GetResourceEmail(ResourceNo: Code[20]) Email: Text
    var
        LocalResource: Record Resource;
    begin
        LocalResource.Get(ResourceNo);
        Email := LocalResource.Email;
    end;

    /// <summary>
    /// Procedure to get Location of resource for appointment
    /// </summary>
    /// <param name="ResourceNo"></param>
    /// <returns></returns>
    local procedure GetLocation(ResourceNo: Code[20]) Location: Text
    var
        LocalResource: Record Resource;
    begin
        LocalResource.Get(ResourceNo);
        Location := LocalResource.Address + ' ' + LocalResource.City + ' ' + LocalResource."Country/Region Code";
    end;
}