codeunit 58105 "Sales Order With No Purchase"
{
    trigger OnRun()
    begin
        SalesLineWithoutReservation();
    end;

    /// <summary>
    /// Event on after the quantity validated form sales line
    /// </summary>
    /// <param name="Rec"></param>
    /// <param name="xRec"></param>
    /// <param name="CurrFieldNo"></param>
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateQuantity(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        Rec.CalcFields("Item Type");
        if (Rec.Quantity <> xRec.Quantity) and (Rec."Item Type" = "Item Type"::Inventory) then begin
            Rec.CalcFields("Reserved Quantity");
            Rec."Reservation Shortage" := Rec."Outstanding Quantity" - Rec."Reserved Quantity";
        end;

        if Rec."Item Type" = "Item Type"::"Non-Inventory" then begin
            Rec."Reservation Shortage" := 0;
        end;
    end;

    /// <summary>
    /// Event on Reservation entry deleted
    /// </summary>
    /// <param name="Rec"></param>
    /// <param name="RunTrigger"></param>
    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnDeleteReservationEntry(var Rec: Record "Reservation Entry"; RunTrigger: Boolean)
    begin
        InsertReservationShortage(Rec);
    end;

    /// <summary>
    /// Event on modification in reservation entry table
    /// </summary>
    /// <param name="Rec"></param>
    /// <param name="xRec"></param>
    /// <param name="RunTrigger"></param>
    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnAfterModifyEvent', '', false, false)]
    procedure OnModifyReservationEntry(var Rec: Record "Reservation Entry"; var xRec: Record "Reservation Entry"; RunTrigger: Boolean)
    begin
        InsertReservationShortage(Rec);
    end;

    /// <summary>
    /// Event on insertion in reservation entry table
    /// </summary>
    /// <param name="Rec"></param>
    /// <param name="RunTrigger"></param>
    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnAfterInsertEvent', '', false, false)]
    procedure OnInsertReservationEntry(var Rec: Record "Reservation Entry"; RunTrigger: Boolean)
    begin
        InsertReservationShortage(Rec);
    end;

    /// <summary>
    /// Procedure to calculate and insert reservation shortage value
    /// </summary>
    /// <param name="recReservationEntry"></param>
    procedure InsertReservationShortage(recReservationEntry: Record "Reservation Entry")
    var
        RecSalesLine: Record "Sales Line";
    begin
        RecSalesLine.Reset();

        RecSalesLine.SetRange("Document No.", recReservationEntry."Source ID");
        RecSalesLine.SetRange("Line No.", recReservationEntry."Source Ref. No.");
        if RecSalesLine.FindFirst() then begin
            RecSalesLine.CalcFields("Reserved Quantity");
            RecSalesLine."Reservation Shortage" := RecSalesLine."Outstanding Quantity" - RecSalesLine."Reserved Quantity";
            RecSalesLine.Modify(true);
        end;
    end;

    /// <summary>
    /// Procedure to check any sales line having Reserved Quantity less than Outstanding Quantity
    /// </summary>
    procedure SalesLineWithoutReservation()
    var
        RecSalesLine: Record "Sales Line";
        RecReservationShortageLine: Record ReservationShortageLine;
        RecItem: Record Item;
    begin
        RecSalesLine.Reset();
        RecSalesLine.CalcFields("Item Type");

        RecSalesLine.SetRange("Document Type", "Sales Document Type"::Order);
        RecSalesLine.SetRange(Type, "Sales Line Type"::Item);
        RecSalesLine.SetRange("Item Type", "Item Type"::Inventory);

        if RecSalesLine.FindSet() then begin
            repeat
                RecSalesLine.CalcFields("Reserved Quantity");
                if RecSalesLine."Reserved Quantity" < RecSalesLine."Outstanding Quantity" then begin
                    InsertIntoTableReservationShortageLine(RecSalesLine);
                end;
            until RecSalesLine.Next() = 0;

            if not RecReservationShortageLine.IsEmpty then begin
                if not SendEmailAlert() then begin
                    Message('%1', GetLastErrorText());
                end;
            end;

            RecReservationShortageLine.DeleteAll();
        end;
    end;

    /// <summary>
    /// Procedure to insert sales lines having reservation shortage
    /// </summary>
    /// <param name="RecSalesLine"></param>
    procedure InsertIntoTableReservationShortageLine(RecSalesLine: Record "Sales Line")
    var
        RecReservationShortageLine: Record ReservationShortageLine;
        RecCustomer: Record Customer;
        RecSalesHeader: Record "Sales Header";
        CustomerName, CustomerRef, BranchName, UserName : Text;
        DocumentDate: Date;
        RecDimensionValue: Record "Dimension Value";
    begin
        Clear(CustomerName);
        Clear(CustomerRef);
        Clear(DocumentDate);
        Clear(UserName);
        Clear(BranchName);

        RecDimensionValue.Reset();
        RecCustomer.Reset();
        RecSalesHeader.Reset();

        RecCustomer.SetRange("No.", RecSalesLine."Sell-to Customer No.");
        if RecCustomer.FindFirst() then begin
            CustomerName := RecCustomer.Name;
        end;

        RecSalesHeader.SetRange("No.", RecSalesLine."Document No.");
        if RecSalesHeader.FindFirst() then begin

            DocumentDate := RecSalesHeader."Document Date";
            CustomerRef := RecSalesHeader."Your Reference";
            UserName := GetUserName(RecSalesHeader.SystemCreatedBy);

            RecDimensionValue.SetRange(Code, RecSalesHeader."Shortcut Dimension 1 Code");
            if RecDimensionValue.FindFirst() then begin
                BranchName := RecDimensionValue.Name;
            end;
        end;

        RecSalesLine.CalcFields("Reserved Quantity");
        RecReservationShortageLine.Init();
        RecReservationShortageLine."Sales Order No." := RecSalesLine."Document No.";
        RecReservationShortageLine."Item No." := RecSalesLine."No.";
        RecReservationShortageLine.Description := RecSalesLine.Description;
        RecReservationShortageLine."Outstanding Quantity" := RecSalesLine."Outstanding Quantity";
        RecReservationShortageLine."Reserved Quantity" := RecSalesLine."Reserved Quantity";
        RecReservationShortageLine."Reservation Shortage" := RecSalesLine."Reservation Shortage";
        RecReservationShortageLine."Unit Price" := RecSalesLine."Unit Price";
        RecReservationShortageLine."Qty. to Ship" := RecSalesLine."Qty. to Ship";
        RecReservationShortageLine."Purchasing Code" := RecSalesLine."Purchasing Code";
        RecReservationShortageLine.Quantity := RecSalesLine.Quantity;
        RecReservationShortageLine."Customer No" := RecSalesLine."Sell-to Customer No.";
        RecReservationShortageLine."Customer Name" := CustomerName;
        RecReservationShortageLine.Branch := BranchName;
        RecReservationShortageLine.Date := DocumentDate;
        RecReservationShortageLine."Customer Reference" := CustomerRef;
        RecReservationShortageLine."Raised By" := UserName;
        RecReservationShortageLine.Insert(true);
    end;

    procedure GetUserName(originalText: Text) User: Text
    var
        RecUser: Record User;
    begin
        RecUser.SetRange("User Security ID", originalText);
        if RecUser.FindFirst() then begin
            User := RecUser."User Name";
        end;
    end;

    /// <summary>
    /// Procedure to send mail
    /// </summary>
    [TryFunction]
    procedure SendEmailAlert()
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        EmailBody: text;
        RecReportDefination: Record "Report Definitions";
        RecReportRecipient: Record "Report Recipient";
        ToRecipients, CCRecipients, BCCRecipients : List of [Text];
        Subject: Text;
        AttachmentTempBlob: Codeunit "Temp Blob";
        AttachmentInstream: InStream;
        AttachmentOustream: OutStream;
        ToName: Text;
        RecEmailRecipients: Record "Email Recipients";
    begin
        Clear(EmailBody);

        RecReportDefination.SetFilter("Object Type to Run", 'Codeunit');
        RecReportDefination.SetRange("Object ID to Run", 58105);
        if RecReportDefination.FindSet() then begin

            RecReportRecipient.SetRange("Report Id", RecReportDefination."Object ID to Run");
            recReportRecipient.SetFilter("Object Type to Run", 'Codeunit');
            if RecReportRecipient.FindSet() then begin
                repeat
                    if RecReportRecipient."Send To" = true then
                        ToRecipients.Add(RecReportRecipient."Email Address");
                    if RecReportRecipient."Send CC" = true then
                        CCRecipients.Add(RecReportRecipient."Email Address");
                    if RecReportRecipient."Send BCC" = true then
                        BCCRecipients.Add(RecReportRecipient."Email Address");
                until RecReportRecipient.Next() = 0;

                RecEmailRecipients.SetRange("Email Address", RecReportRecipient."Email Address");
                if RecEmailRecipients.FindFirst() then begin
                    ToName := RecEmailRecipients.Username;
                end;
            end;

            Subject := RecReportDefination.Subject;
            EmailBody := StrSubstNo('Hi %1,', ToName) + '<br><br>Please find the attached report of sales lines whereby the reservation does not meet the requirement of the outstanding quantity.<br><br>Thanks & Regards,<br>GVAV';

            EmailMessage.Create(ToRecipients, Subject, EmailBody, true, CCRecipients, BCCRecipients);

            AttachmentTempBlob.CreateOutStream(AttachmentOustream);
            Report.SaveAs(Report::SalesLineWithoutReservation, '', ReportFormat::Excel, AttachmentOustream);

            AttachmentTempBlob.CreateInStream(AttachmentInstream);
            EmailMessage.AddAttachment('Sales lines without reservation.xlsx', 'EXCEL', AttachmentInstream);

            Email.Send(EmailMessage);
        end;
    end;
}