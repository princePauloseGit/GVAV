report 58107 SalesInvoiceWordEmail
{
    ApplicationArea = All;
    UsageCategory = Administration;
    DefaultLayout = Word;
    WordLayout = 'Word Layouts\Sales Invoice Word Email.docx';
    Caption = 'SalesInvoiceWordEmail';
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            column(Amount; Amount)
            {
            }
            column(No; "No.")
            {
            }
            column(OrderNo; "Order No.")
            {
            }
            column(OrderDate; "Order Date")
            {
            }
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            column(SelltoEMail; "Sell-to E-Mail")
            {
            }

            trigger OnPreDataItem()
            begin
                SalesInvoiceHeader.SetFilter("No.", SONo);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        SalesInvoiceHeader.SetFilter("No.", SONo);
    end;

    procedure setParameter(recSalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        SONo := recSalesInvoiceHeader."No.";
    end;

    var
        SONo: Code[20];
}
