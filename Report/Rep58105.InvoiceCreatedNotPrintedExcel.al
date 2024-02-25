report 58105 InvoiceCreatedNotPrintedExcel
{
    ApplicationArea = All;
    Caption = 'Invoice Created Not Printed';
    UsageCategory = Administration;
    ExcelLayout = 'Excel Layouts\Invoice Created Not Printed.xlsx';
    DefaultLayout = Excel;
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            column(No; "No.")
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(DueDate; "Due Date")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(AmountIncludingVAT; "Amount Including VAT")
            {
            }
            column(RemainingAmount; "Remaining Amount")
            {
            }
            trigger OnPreDataItem()
            var
                CreatedDate: DateTime;
            begin
                Clear(CreatedDate);

                CreatedDate := CreateDateTime(Today, 0T);
                SetRange(SystemCreatedAt, CreatedDate, CurrentDateTime);
                SetRange("No. Printed", 0);
            end;
        }
    }
}