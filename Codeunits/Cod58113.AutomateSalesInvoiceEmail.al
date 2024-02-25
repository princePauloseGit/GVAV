codeunit 58113 AutomateSalesInvoiceEmail
{
    //GVAV-030 - AUTOMATED SALES INVOICE EMAIL 
    var
        error: ErrorInfo;
        cuCommonHelper: Codeunit CommonHelper;
        Severity: Enum EnhIntegrationLogSeverity;

    trigger OnRun()
    begin
        if not sendAutomatedSalesInvoiceEmail() then begin
            cuCommonHelper.InsertIntegrationLog('Failed to Run codeunit 58113', Severity::Error);
        end;
    end;

    [ErrorBehavior(ErrorBehavior::Collect)]
    [TryFunction]
    procedure sendAutomatedSalesInvoiceEmail()
    var
        EmailMessage: Codeunit "Email Message";
        EmailSubjectBody: Codeunit SendEmailGenericTemplate;
        Email: Codeunit Email;
        EmailScenrio: Enum "Email Scenario";
        Selection, DefaultSelection : Integer;
        ReportSalesInvoiceWordEmail: Report SalesInvoiceWordEmail;
        EmailBody, Subject : Text;
        InS: InStream;
        Outstrebody: OutStream;
        DocRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        RecReportDefination: Record "Report Definitions";
        RecReportRecipient: Record "Report Recipient";
        ToRecipients: Text;
        CuSendEmailGenericTemplate: Codeunit SendEmailGenericTemplate;
        Reportselections: Record "Report Selections";
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        recCustomer: Record Customer;
        CustomerEmail: Text;
        recSalesRec: Record "Sales & Receivables Setup";
        recCustomReportSelection: Record "Custom Report Selection";
        customReportID: Integer;
        error: ErrorInfo;
        MailSent: Boolean;
    begin
        recSalesInvoiceHeader.Reset();
        recSalesInvoiceHeader.SetFilter("No. Printed", '=%1', 0);
        if recSalesInvoiceHeader.FindSet(true) then begin
            repeat
                Clear(EmailBody);
                Clear(InS);
                Clear(CustomerEmail);
                Clear(customReportID);
                Clear(ReportSalesInvoiceWordEmail);

                recCustomer.Reset();
                recCustomer.get(recSalesInvoiceHeader."Sell-to Customer No.");

                // send email only if not enabled
                if not recCustomer."Exclude from Automatic Email" then begin
                    // Assign custom layout ID if any layout exist for the customer 
                    recCustomReportSelection.Reset();
                    recCustomReportSelection.SetRange(Usage, Reportselections.Usage::"S.Invoice");
                    recCustomReportSelection.SetRange("Source No.", recSalesInvoiceHeader."Sell-to Customer No.");
                    if recCustomReportSelection.FindSet(true) then begin
                        repeat
                            Clear(customReportID);
                            Clear(ToRecipients);

                            customReportID := recCustomReportSelection."Report ID";
                            ToRecipients := recCustomReportSelection."Send To Email";

                            if ToRecipients = '' then begin
                                ToRecipients := recCustomer."E-Mail";
                            end;

                            if ToRecipients <> '' then begin
                                Subject := 'Sales Invoice: %1' + recSalesInvoiceHeader."No.";

                                Clear(TempBlob);
                                // Create Email Body from Report  
                                TempBlob.CreateOutStream(Outstrebody);
                                ReportSalesInvoiceWordEmail.setParameter(recSalesInvoiceHeader);
                                ReportSalesInvoiceWordEmail.SaveAs('', ReportFormat::Html, Outstrebody, DocRef);
                                Tempblob.CreateInStream(InS);
                                InS.ReadText(EmailBody);

                                EmailMessage.Create(ToRecipients, Subject, EmailBody, true);

                                if customReportID = 0 then begin
                                    if not AddAttachmentToSalesOrderEmail(EmailMessage, recSalesInvoiceHeader, Reportselections.Usage::"S.Invoice") then begin
                                        cuCommonHelper.InsertIntegrationLog('Email not sent for ' + Format(recSalesInvoiceHeader."No."), Severity::Error);
                                    end;
                                end else begin

                                    if not AddAttachmentToSalesHeaderEmail(EmailMessage, recSalesInvoiceHeader, customReportID) then begin
                                        cuCommonHelper.InsertIntegrationLog('Email not sent for ' + Format(recSalesInvoiceHeader."No."), Severity::Error);
                                    end;
                                end;

                                //check if email is sent or not
                                MailSent := Email.Send(EmailMessage);

                                if not MailSent then begin
                                    cuCommonHelper.InsertIntegrationLog('Email not sent for ' + Format(recSalesInvoiceHeader."No.") + ' for Email ID: ' + ToRecipients, Severity::Error);
                                end;

                            end else begin
                                cuCommonHelper.InsertIntegrationLog('Email not sent for ' + Format(recSalesInvoiceHeader."No.") + ' as empty Recipients', Severity::Error);
                            end;
                        until recCustomReportSelection.Next() = 0;
                    end;
                end
                else begin
                    cuCommonHelper.InsertIntegrationLog('Customer is excluded from Automatic Email ' + recSalesInvoiceHeader."No.", Severity::Information);
                end;
            until recSalesInvoiceHeader.Next() = 0;
        end;
    end;

    [TryFunction]
    procedure AddAttachmentToSalesOrderEmail(var EmailMessage: Codeunit "Email Message"; SalesInvoiceHeader: Record "Sales Invoice Header"; ReportType: Enum "Report Selection Usage")
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        TempBlob: Codeunit "Temp Blob";
        SalesHeaderRecordRef: RecordRef;
        ReportInStream: InStream;
        ReportOutStream: OutStream;
        LayoutCode: Code[20];
        ReportId: Integer;
        AttachmentFileNameLbl: Label 'Sales Invoice %1.pdf', Comment = '%1 Sales Invoice No.';
        cuSendEmailGenericTemplate: Codeunit SendEmailGenericTemplate;
    begin
        TempBlob.CreateOutStream(ReportOutStream);
        SalesHeaderRecordRef := SetSalesRecordRef(SalesInvoiceHeader);
        ReportLayoutSelection := cuSendEmailGenericTemplate.GetSalesOrderReportandLayoutCode(ReportId, LayoutCode, true, ReportType);

        if LayoutCode <> '' then begin
            ReportLayoutSelection.SetTempLayoutSelected(LayoutCode);
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, SalesHeaderRecordRef);
            ReportLayoutSelection.SetTempLayoutSelected('');
        end else
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, SalesHeaderRecordRef);

        TempBlob.CreateInStream(ReportInStream);
        EmailMessage.AddAttachment(StrSubstNo(AttachmentFileNameLbl, SalesInvoiceHeader."No."), '', ReportInStream);
    end;

    procedure SetSalesRecordRef(SalesInvoiceHeader: Record "Sales Invoice Header") ReturnRecordRef: RecordRef
    var
        SalesHeader2: Record "Sales Invoice Header";
    begin
        SalesHeader2.SetRange("No.", SalesInvoiceHeader."No.");
        SalesHeader2.Findfirst();
        ReturnRecordRef.GetTable(SalesHeader2);
    end;

    [TryFunction]
    procedure AddAttachmentToSalesHeaderEmail(var EmailMessage: Codeunit "Email Message"; SalesInvoiceHeader: Record "Sales Invoice Header"; ReportID: Integer)
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        TempBlob: Codeunit "Temp Blob";
        SalesHeaderRecordRef: RecordRef;
        ReportInStream: InStream;
        ReportOutStream: OutStream;
        LayoutCode: Code[20];
        AttachmentFileNameLbl: Label 'Sales Invoice %1.pdf', Comment = '%1 Sales Invoice No.';
        cuSendEmailGenericTemplate: Codeunit SendEmailGenericTemplate;
    begin
        TempBlob.CreateOutStream(ReportOutStream);
        SalesHeaderRecordRef := SetSalesRecordRef(SalesInvoiceHeader);
        ReportLayoutSelection := GetSalesInvoiceReportandLayoutCode(ReportId, LayoutCode, true);

        if LayoutCode <> '' then begin
            ReportLayoutSelection.SetTempLayoutSelected(LayoutCode);
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, SalesHeaderRecordRef);
            ReportLayoutSelection.SetTempLayoutSelected('');
        end else
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, SalesHeaderRecordRef);

        TempBlob.CreateInStream(ReportInStream);
        EmailMessage.AddAttachment(StrSubstNo(AttachmentFileNameLbl, SalesInvoiceHeader."No."), '', ReportInStream);
    end;

    procedure GetSalesInvoiceReportandLayoutCode(var ReportId: Integer; var LayoutCode: Code[20]; IsAttachment: Boolean) ReportLayoutSelection: Record "Report Layout Selection"
    var
        Reportselections: Record "Report Selections";
    begin
        Reportselections.Reset();
        Reportselections.SetRange("Report ID", ReportId);

        if Reportselections.Findfirst() then begin
            LayoutCode := Reportselections."Email Body Layout Code";
            ReportId := Reportselections."Report ID";
            if ReportLayoutSelection.Get(ReportId, CompanyName) then;
        end;
    end;
}