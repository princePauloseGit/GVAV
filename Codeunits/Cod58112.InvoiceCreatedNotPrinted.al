codeunit 58112 "Invoice Created Not Printed"
{
    trigger OnRun()
    begin
        SendEmailAlert();
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
        AttachmentTempBlob, TempBlob : Codeunit "Temp Blob";
        AttachmentInstream, Ins : InStream;
        AttachmentOustream, Outstrebody : OutStream;
        ToName: Text;
        RecEmailRecipients: Record "Email Recipients";
        DocRef: RecordRef;
    begin
        Clear(EmailBody);

        RecReportDefination.SetFilter("Object Type to Run", 'Codeunit');
        RecReportDefination.SetRange("Object ID to Run", 58112);
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
            Clear(TempBlob);
            TempBlob.CreateOutStream(Outstrebody);

            Report.SaveAs(Report::InvoiceCreatedNotPrintedWord, '', ReportFormat::Html, Outstrebody, DocRef);
            Tempblob.CreateInStream(InS);
            InS.ReadText(EmailBody);
            EmailMessage.Create(ToRecipients, Subject, EmailBody, true, CCRecipients, BCCRecipients);

            AttachmentTempBlob.CreateOutStream(AttachmentOustream);
            Report.SaveAs(Report::InvoiceCreatedNotPrintedExcel, '', ReportFormat::Excel, AttachmentOustream);

            AttachmentTempBlob.CreateInStream(AttachmentInstream);
            EmailMessage.AddAttachment('Invoice Created Not Printed.xlsx', 'EXCEL', AttachmentInstream);

            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
    end;
}