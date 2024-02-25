codeunit 58102 "Project Days Over Budget"
{
    /// <summary>
    /// Procedure to Send Email 
    /// </summary>
    /// <param name="RecProject"></param>
    procedure SendEmailAlert(RecProject: Record "Project Records")
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        InS: InStream;
        EmailBody: text;
        Outstrebody: OutStream;
        DocRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        RecReportDefination: Record "Report Definitions";
        RecReportRecipient: Record "Report Recipient";
        ToRecipients, CCRecipients, BCCRecipients : List of [Text];
        Subject: Text;
        ReportProjectDaysAlert: Report "Project Days Over Budget Alert";
        CuCommonHelper: Codeunit CommonHelper;
    begin
        Clear(EmailBody);
        Clear(InS);

        if RecProject."Project No." <> '' then begin

            RecReportDefination.SetFilter("Object Type to Run", 'Codeunit');
            RecReportDefination.SetRange("Object ID to Run", 58102);
            if RecReportDefination.FindSet() then begin

                RecReportRecipient.SetRange("Report Id", RecReportDefination."Object ID to Run");
                RecReportRecipient.SetFilter("Object Type to Run", 'Codeunit');
                if RecReportRecipient.FindSet() then
                    repeat
                        if RecReportRecipient."Send To" = true then
                            ToRecipients.Add(RecReportRecipient."Email Address");
                        if RecReportRecipient."Send CC" = true then
                            CCRecipients.Add(RecReportRecipient."Email Address");
                        if RecReportRecipient."Send BCC" = true then
                            BCCRecipients.Add(RecReportRecipient."Email Address");
                    until RecReportRecipient.Next() = 0;

                Subject := RecReportDefination.Subject;
                Clear(TempBlob);
                TempBlob.CreateOutStream(Outstrebody);

                ReportProjectDaysAlert.setParameter(recProject);
                ReportProjectDaysAlert.SaveAs('', ReportFormat::Html, Outstrebody, DocRef);
                Tempblob.CreateInStream(InS);
                InS.ReadText(EmailBody);
                EmailMessage.Create(ToRecipients, Subject, EmailBody, true, CCRecipients, BCCRecipients);
                Email.Send(EmailMessage);
            end;
        end;
    end;

    /// <summary>
    /// Event on close of Engineer Booking page
    /// </summary>
    /// <param name="Rec"></param>
    [EventSubscriber(ObjectType::Page, Page::"Engineer Bookings Card", 'OnClosePageEvent', '', false, false)]
    local procedure OnCloseEngineerBooking(var Rec: Record "Engineer Bookings")
    var
        RecEngBook: Record "Engineer Bookings";
        RecProjectRecord: Record "Project Records";
        QtyEngBook, QtyPMBook, QtyRackBook : Integer;
    begin
        Clear(QtyEngBook);
        Clear(QtyPMBook);
        Clear(QtyRackBook);

        RecEngBook.SetRange("Work Type", Rec."Work Type");
        RecEngBook.SetRange("Project No.", Rec."Project No.");
        if RecEngBook.FindSet() then begin
            if Rec."Work Type" = Rec."Work Type"::Engineering then
                QtyEngBook := RecEngBook.Count;

            if Rec."Work Type" = Rec."Work Type"::"Project Management" then
                QtyPMBook := RecEngBook.Count;

            if Rec."Work Type" = Rec."Work Type"::"Rack Build" then
                QtyRackBook := RecEngBook.Count;
        end;

        RecProjectRecord.SetRange("Project No.", Rec."Project No.");
        RecProjectRecord.SetRange(IsMailSend, false);
        if RecProjectRecord.FindSet() then begin

            RecProjectRecord.CalcFields("Qty. Engineering Days Booked");
            RecProjectRecord.CalcFields("Qty. PM Days Booked");
            RecProjectRecord.CalcFields("Qty. Rack Build Days Booked");

            if QtyEngBook = RecProjectRecord."Qty. Engineering Days Booked" then begin
                if (QtyEngBook > RecProjectRecord."Quantity Engineering Days") then begin
                    SendEmailAlert(RecProjectRecord);
                    RecProjectRecord.IsMailSend := true;
                    RecProjectRecord.Modify(true);
                end;
            end;
            if QtyPMBook = RecProjectRecord."Qty. PM Days Booked" then begin
                if (QtyPMBook > RecProjectRecord."Quantity PM Days") then begin
                    SendEmailAlert(RecProjectRecord);
                    RecProjectRecord.IsMailSend := true;
                    RecProjectRecord.Modify(true);
                end;
            end;
            if QtyRackBook = RecProjectRecord."Qty. Rack Build Days Booked" then begin
                if (QtyRackBook > RecProjectRecord."Quantity Rack Build Days") then begin
                    SendEmailAlert(RecProjectRecord);
                    RecProjectRecord.IsMailSend := true;
                    RecProjectRecord.Modify(true);
                end;
            end;
        end;
    end;

    /// <summary>
    /// Event on close of Project Record page
    /// </summary>
    /// <param name="Rec"></param>
    [EventSubscriber(ObjectType::Page, Page::"Project Record Card", 'OnClosePageEvent', '', false, false)]
    local procedure OnCloseProjectRecord(var Rec: Record "Project Records")
    var
    begin

        Rec.CalcFields("Qty. Engineering Days Booked");
        Rec.CalcFields("Qty. PM Days Booked");
        Rec.CalcFields("Qty. Rack Build Days Booked");

        if (Rec."Qty. Engineering Days Booked" > Rec."Quantity Engineering Days") and (Rec.IsMailSend = false) then begin
            SendEmailAlert(Rec);
            Rec.IsMailSend := true;
            Rec.Modify(true);
        end;

        if (Rec."Qty. PM Days Booked" > Rec."Quantity PM Days") and (Rec.IsMailSend = false) then begin
            SendEmailAlert(Rec);
            Rec.IsMailSend := true;
            Rec.Modify(true);
        end;

        if (Rec."Qty. Rack Build Days Booked" > Rec."Quantity Rack Build Days") and (Rec.IsMailSend = false) then begin
            SendEmailAlert(Rec);
            Rec.IsMailSend := true;
            Rec.Modify(true);
        end;
    end;

    /// <summary>
    /// Event on modification in Project Record table
    /// </summary>
    /// <param name="Rec"></param>
    /// <param name="xRec"></param>
    /// <param name="RunTrigger"></param>
    [EventSubscriber(ObjectType::Table, Database::"Project Records", 'OnAfterModifyEvent', '', false, false)]
    local procedure ProjectRecordModification(var Rec: Record "Project Records"; var xRec: Record "Project Records"; RunTrigger: Boolean)
    var
    begin
        Rec.CalcFields("Qty. Engineering Days Booked");
        Rec.CalcFields("Qty. PM Days Booked");
        Rec.CalcFields("Qty. Rack Build Days Booked");

        if Rec."Quantity Engineering Days" <> xRec."Quantity Engineering Days" then begin
            if Rec."Qty. Engineering Days Booked" > Rec."Quantity Engineering Days" then begin
                Rec.IsMailSend := false;
                Rec.Modify(true);
            end;
        end;

        if Rec."Quantity PM Days" <> xRec."Quantity PM Days" then begin
            if Rec."Qty. PM Days Booked" > Rec."Quantity PM Days" then begin
                Rec.IsMailSend := false;
                Rec.Modify(true);
            end;
        end;

        if Rec."Quantity Rack Build Days" <> xRec."Quantity Rack Build Days" then begin
            if Rec."Qty. Rack Build Days Booked" > Rec."Quantity Rack Build Days" then begin
                Rec.IsMailSend := false;
                Rec.Modify(true);
            end;
        end;
    end;

    /// <summary>
    /// Event on modification in Engineer Booking table
    /// </summary>
    /// <param name="Rec"></param>
    /// <param name="xRec"></param>
    /// <param name="RunTrigger"></param>
    [EventSubscriber(ObjectType::Table, Database::"Engineer Bookings", 'OnAfterModifyEvent', '', false, false)]
    local procedure EngineerBookingModification(var Rec: Record "Engineer Bookings"; var xRec: Record "Engineer Bookings"; RunTrigger: Boolean)
    begin
        if (Rec."Work Type" <> xRec."Work Type") or (Rec."Project No." <> xRec."Project No.") then begin
            OnEngineerBookingChange(Rec);
        end;
    end;

    /// <summary>
    /// Event on insertion in Engineer Booking table
    /// </summary>
    /// <param name="Rec"></param>
    /// <param name="RunTrigger"></param>
    [EventSubscriber(ObjectType::Table, Database::"Engineer Bookings", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertEngineerBooking(var Rec: Record "Engineer Bookings"; RunTrigger: Boolean)
    begin
        OnEngineerBookingChange(Rec);
    end;

    /// <summary>
    /// Procedure called when insertion or modification done in Engineer Booking table
    /// </summary>
    /// <param name="Rec"></param>
    procedure OnEngineerBookingChange(var Rec: Record "Engineer Bookings")
    var
        RecEngBook: Record "Engineer Bookings";
        RecProjectRecord: Record "Project Records";
        QtyEngBook: Integer;
    begin
        RecProjectRecord.SetRange("Project No.", Rec."Project No.");
        if RecProjectRecord.FindFirst() then begin

            RecProjectRecord.CalcFields("Qty. Engineering Days Booked");
            RecProjectRecord.CalcFields("Qty. PM Days Booked");
            RecProjectRecord.CalcFields("Qty. Rack Build Days Booked");

            if (Rec."Work Type" = Rec."Work Type"::Engineering) then begin
                if RecProjectRecord."Qty. Engineering Days Booked" > RecProjectRecord."Quantity Engineering Days" then begin
                    RecProjectRecord.IsMailSend := false;
                    RecProjectRecord.Modify(true);
                end;
            end;

            if (Rec."Work Type" = Rec."Work Type"::"Project Management") then begin
                if RecProjectRecord."Qty. PM Days Booked" > RecProjectRecord."Quantity PM Days" then begin
                    RecProjectRecord.IsMailSend := false;
                    RecProjectRecord.Modify(true);
                end;
            end;

            if (Rec."Work Type" = Rec."Work Type"::"Rack Build") then begin
                if RecProjectRecord."Qty. Rack Build Days Booked" > RecProjectRecord."Quantity Rack Build Days" then begin
                    RecProjectRecord.IsMailSend := false;
                    RecProjectRecord.Modify(true);
                end;
            end;
        end;
    end;
}