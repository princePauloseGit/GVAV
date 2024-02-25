codeunit 58109 SalesOrderConfirmation
{
    //GVAV-026 THANK YOU FOR YOUR ORDER ALERT
    var
        cuCommonHelper: Codeunit CommonHelper;
        Severity: Enum EnhIntegrationLogSeverity;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var LinesWereModified: Boolean; SkipWhseRequestOperations: Boolean)
    begin
        if (SalesHeader."Document Type" = "Sales Document Type"::Order) and (SalesHeader.isSOConfirmationEmailSent = false) then begin
            SendSalesOrderWithEmailMessage(SalesHeader);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeRunSalesPost', '', false, false)]
    local procedure OnBeforeRunSalesPost(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; var SuppressCommit: Boolean)
    var
        enumSHstatus: Enum Microsoft.Sales.Document."Sales Document Status";
    begin
        if SalesHeader.Status <> enumSHstatus::Released then begin
            Error('Please Release the Document: %1', SalesHeader."No.");
        end;
    end;

    [TryFunction]
    procedure SendSalesOrderWithEmailMessage(SalesHeader: Record "Sales Header")
    var
        EmailMessage: Codeunit "Email Message";
        EmailSubjectBody: Codeunit SendEmailGenericTemplate;
        Email: Codeunit Email;
        EmailScenrio: Enum "Email Scenario";
        Selection, DefaultSelection : Integer;
        ReportThankYouAlert: Report ThankYouAlert;
        EmailBody, Subject : Text;
        InS: InStream;
        Outstrebody: OutStream;
        DocRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        RecReportDefination: Record "Report Definitions";
        RecReportRecipient: Record "Report Recipient";
        ToRecipients, CCRecipients, BCCRecipients : List of [Text];
        CuSendEmailGenericTemplate: Codeunit SendEmailGenericTemplate;
        Reportselections: Record "Report Selections";
        isEmailSent: Boolean;
        SalesOrderNo: Code[50];
    begin
        Clear(EmailBody);
        Clear(InS);
        RecReportDefination.Reset();
        RecReportRecipient.Reset();
        Clear(SalesOrderNo);

        SalesOrderNo := SalesHeader."No.";
        if (SalesHeader."No." <> '') then begin

            Subject := 'Thank you for your Order';

            Clear(TempBlob);
            // Create Email Body from Report  : Thank you Alert Report   
            TempBlob.CreateOutStream(Outstrebody);
            ReportThankYouAlert.setParameter(SalesHeader);
            ReportThankYouAlert.SaveAs('', ReportFormat::Html, Outstrebody, DocRef);
            Tempblob.CreateInStream(InS);
            InS.ReadText(EmailBody);

            EmailMessage.Create(SalesHeader."Sell-to E-Mail", Subject, EmailBody, true);

            // Attach Sales Order Confirmation PDF Report to the email   
            CuSendEmailGenericTemplate.AddAttachmentToSalesOrderEmail(EmailMessage, SalesHeader, Reportselections.Usage::"S.Order");
            isEmailSent := Email.Send(EmailMessage);

            SalesHeader.Reset();
            SalesHeader.SetRange("No.", SalesOrderNo);
            if SalesHeader.FindFirst() then begin
                if isEmailSent = true then begin
                    SalesHeader.isSOConfirmationEmailSent := true;
                    SalesHeader.Modify(true);
                end else begin
                    SalesHeader.isSOConfirmationEmailSent := false;
                    SalesHeader.Modify(true);
                    cuCommonHelper.InsertIntegrationLog('Email not sent for ' + Format(SalesOrderNo), Severity::Error);
                end;
            end;

        end;
    end;
}