codeunit 58106 "Sales Orders Call Off"
{
    trigger OnRun()
    begin
        FindSalesOrderCallOff();
    end;

    /// <summary>
    /// Procedure to find sales lines having call of date is today + 3 days
    /// </summary>
    procedure FindSalesOrderCallOff()
    var
        PriorDays: Integer;
        RecSalesOrderCallOff: Record "Sales Order Call Off";
        RecSalesLine: Record "Sales Line";
    begin
        RecSalesLine.Reset();
        PriorDays := 10;

        RecSalesLine.SetRange("Call Off Date", Today + PriorDays);
        RecSalesLine.SetRange("Call Off", false);
        if RecSalesLine.FindSet() then begin
            repeat
                InsertIntoSalesOrderCallOff(RecSalesLine);
            until RecSalesLine.Next() = 0;
        end;

        if not RecSalesOrderCallOff.IsEmpty then begin
            if SendEmailAlert() then begin
                if RecSalesOrderCallOff.FindSet() then
                    repeat
                        RecSalesLine.SetRange("Document No.", RecSalesOrderCallOff."Order No.");
                        RecSalesLine.SetRange("Line No.", RecSalesOrderCallOff."Line No.");
                        if RecSalesLine.FindSet() then begin
                            RecSalesLine."Call Off" := true;
                            RecSalesLine.Modify(true);
                        end;
                    until RecSalesOrderCallOff.Next() = 0;
            end
            else begin
                Message('%1', GetLastErrorText());
            end;
        end;

        RecSalesOrderCallOff.DeleteAll();
    end;

    /// <summary>
    /// Procedure to Insert records into SalesOrderCallOff table
    /// </summary>
    /// <param name="RecSalesLine"></param>
    procedure InsertIntoSalesOrderCallOff(RecSalesLine: Record "Sales Line")
    var
        RecSalesOrderCallOff: Record "Sales Order Call Off";
        RecCustomer: Record Customer;
        CustomerName, Supplier : Text;
        RecPurchaseLine: Record "Purchase Line";
        RecVendor: Record Vendor;
        VendorCode: Code[20];
    begin
        Clear(CustomerName);
        Clear(Supplier);
        Clear(VendorCode);

        RecCustomer.SetRange("No.", RecSalesLine."Sell-to Customer No.");
        if RecCustomer.FindFirst() then begin
            CustomerName := RecCustomer.Name;
        end;

        RecPurchaseLine.SetRange("Document No.", RecSalesLine."Purchase Order No.");
        if RecPurchaseLine.FindFirst() then begin
            VendorCode := RecPurchaseLine."Buy-from Vendor No.";
        end;

        RecVendor.SetRange("No.", VendorCode);
        if RecVendor.FindFirst() then begin
            Supplier := RecVendor.Name;
        end;

        RecSalesOrderCallOff.Reset();
        RecSalesOrderCallOff.Init();
        RecSalesOrderCallOff."Order No." := RecSalesLine."Document No.";
        RecSalesOrderCallOff."Customer Code" := RecSalesLine."Sell-to Customer No.";
        RecSalesOrderCallOff."Customer Name" := CustomerName;
        RecSalesOrderCallOff."Item Code" := RecSalesLine."No.";
        RecSalesOrderCallOff."Item Description" := RecSalesLine.Description;
        RecSalesOrderCallOff."Purchase Order No." := RecSalesLine."Purchase Order No.";
        RecSalesOrderCallOff.Quantity := RecSalesLine.Quantity;
        RecSalesOrderCallOff."Line No." := RecSalesLine."Line No.";
        RecSalesOrderCallOff."Call Off Date" := RecSalesLine."Call Off Date";
        RecSalesOrderCallOff."Supplier Code" := VendorCode;
        RecSalesOrderCallOff.Supplier := Supplier;
        RecSalesOrderCallOff.Insert(true);
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
        RecReportDefination.SetRange("Object ID to Run", 58106);
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
            EmailBody := StrSubstNo('Hi %1,', ToName) + '<br><br>Please find the attached report of sales orders call off.<br><br>Thanks & Regards,<br>GVAV';

            EmailMessage.Create(ToRecipients, Subject, EmailBody, true, CCRecipients, BCCRecipients);

            AttachmentTempBlob.CreateOutStream(AttachmentOustream);
            Report.SaveAs(Report::"Sales Orders Call Off", '', ReportFormat::Excel, AttachmentOustream);

            AttachmentTempBlob.CreateInStream(AttachmentInstream);
            EmailMessage.AddAttachment('Sales Orders Call Off.xlsx', 'EXCEL', AttachmentInstream);

            Email.Send(EmailMessage);
        end;
    end;
}