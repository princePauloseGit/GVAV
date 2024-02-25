codeunit 58110 SendEmailGenericTemplate
{
    procedure GeneratePurchaseOrderEmailSubject(SalesHeader: Record "Sales Header"): Text[250]
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order:
                exit('Order Confirmation ' + SalesHeader."No.");
        end;
    end;

    procedure GeneratePurchaseOrderEmailBody(SalesHeader: Record "Sales Header"): Text
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get();
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order:
                exit('Dear ' + SalesHeader."Sell-to Customer Name" + ',' +
                     'Please find attached the order confirmation for ' + SalesHeader."No." +
                     'We will expect you to process it as soon as possible.' +
                     'Kind regards,' +
                     CompanyInformation.Name + ' ' + CompanyInformation.Address + ' ' + CompanyInformation.City + ' ' +
                     CompanyInformation."Post Code" + ' ' + CompanyInformation."Country/Region Code" + ' ' +
                     CompanyInformation."Phone No." + ' ' + CompanyInformation."E-Mail");
        end;
    end;

    procedure GeneratePurchaseOrderHtmlEmailBody(SalesHeader: Record "Sales Header") EmailBody: Text
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order:
                begin
                    AddEmailHeaderLines(SalesHeader, EmailBody);
                    AddEmailFooterLines(EmailBody);
                end;
        end;
    end;

    procedure GeneratePurchaseOrderDetailedHtmlEmailBody(SalesHeader: Record "Sales Header") EmailBody: Text
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order:
                begin
                    AddEmailHeaderLines(SalesHeader, EmailBody);
                    AddEmailBodyLines(SalesHeader, EmailBody);
                    AddEmailFooterLines(EmailBody);
                end;
        end;
    end;

    local procedure AddEmailHeaderLines(SalesHeader: Record "Sales Header"; var EmailBody: Text)
    begin
        EmailBody := 'Dear <b>' + SalesHeader."Sell-to Customer Name" + '</b>,</br></br>' +
                     'Please find attached the order confirmation for ' + SalesHeader."No." + '</br></br>' +
                     'We will expect you to process it as soon as possible.' + '</br></br></br>';
    end;

    local procedure AddEmailBodyLines(SalesHeader: Record "Sales Header"; var EmailBody: Text)
    var
        SalesLines: Record "Sales Line";
    begin
        SalesLines.SetRange("Document Type", SalesHeader."Document Type");
        SalesLines.SetRange("Document No.", SalesHeader."No.");
        if SalesLines.FindSet() then begin
            EmailBody := EmailBody + '<table border="1">';
            EmailBody := EmailBody + '<tr>';
            EmailBody := EmailBody + '<th>Item No</th>';
            EmailBody := EmailBody + '<th>Description</th>';
            EmailBody := EmailBody + '<th>Quantity</th>';
            EmailBody := EmailBody + '<th>Qty. To Receive</th>';
            EmailBody := EmailBody + '</tr>';
            repeat
                EmailBody := EmailBody + '<tr>';
                EmailBody := EmailBody + '<td>' + SalesLines."No." + '</td>';
                EmailBody := EmailBody + '<td>' + SalesLines.Description + '</td>';
                EmailBody := EmailBody + '<td>' + Format(SalesLines.Quantity) + '</td>';
                EmailBody := EmailBody + '<td>' + Format(SalesLines."Qty. Invoiced (Base)") + '</td>';
                EmailBody := EmailBody + '</tr>';
            until (SalesLines.Next() = 0);
            EmailBody := EmailBody + '</table>';
            EmailBody := EmailBody + '</br></br>';
        end;
    end;

    local procedure AddEmailFooterLines(var EmailBody: Text)
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get();
        EmailBody := EmailBody +
         'Kind regards,' +
         '<b></br>' + CompanyInformation.Name + '</b></br>' + CompanyInformation.Address + '</br>' +
         CompanyInformation.City + '</br>' + CompanyInformation."Post Code" + '</br>' +
         CompanyInformation."Country/Region Code" + '</br>' + CompanyInformation."Phone No." + '</br>' +
         CompanyInformation."E-Mail";
    end;

    procedure SetSalesRecordRef(SalesHeader: Record "Sales Header") ReturnRecordRef: RecordRef
    var
        SalesHeader2: Record "Sales Header";
    begin
        SalesHeader2.SetRange("Document Type", SalesHeader."Document Type");
        SalesHeader2.SetRange("No.", SalesHeader."No.");
        SalesHeader2.Findfirst();
        ReturnRecordRef.GetTable(SalesHeader2);
    end;

    procedure GetSalesOrderReportandLayoutCode(var ReportId: Integer; var LayoutCode: Code[20]; IsAttachment: Boolean; ReportType: Enum "Report Selection Usage") ReportLayoutSelection: Record "Report Layout Selection"
    var
        Reportselections: Record "Report Selections";
    begin
        Reportselections.Reset();
        Reportselections.SetRange(Usage, ReportType);

        if Reportselections.Findfirst() then begin
            LayoutCode := Reportselections."Email Body Layout Code";
            ReportId := Reportselections."Report ID";
            if ReportLayoutSelection.Get(ReportId, CompanyName) then;
        end;
    end;

    procedure AddAttachmentToSalesOrderEmail(var EmailMessage: Codeunit "Email Message"; SalesHeader: Record "Sales Header"; ReportType: Enum "Report Selection Usage")
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        TempBlob: Codeunit "Temp Blob";
        SalesHeaderRecordRef: RecordRef;
        ReportInStream: InStream;
        ReportOutStream: OutStream;
        LayoutCode: Code[20];
        ReportId: Integer;
        AttachmentFileNameLbl: Label 'Sales Order %1.pdf', Comment = '%1 Sales Order No.';
    begin
        TempBlob.CreateOutStream(ReportOutStream);
        SalesHeaderRecordRef := SetSalesRecordRef(SalesHeader);
        ReportLayoutSelection := GetSalesOrderReportandLayoutCode(ReportId, LayoutCode, true, ReportType);

        if LayoutCode <> '' then begin
            ReportLayoutSelection.SetTempLayoutSelected(LayoutCode);
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, SalesHeaderRecordRef);
            ReportLayoutSelection.SetTempLayoutSelected('');
        end else
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, SalesHeaderRecordRef);

        TempBlob.CreateInStream(ReportInStream);
        EmailMessage.AddAttachment(StrSubstNo(AttachmentFileNameLbl, SalesHeader."No."), '', ReportInStream);
    end;
}