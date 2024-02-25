report 58104 "InvoiceCreatedNotPrintedWord"
{
    ApplicationArea = All;
    Caption = 'Invoice Created Not Printed';
    UsageCategory = Administration;
    DefaultLayout = Word;
    WordLayout = 'Word Layouts\Invoice Created Not Printed.docx';
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
            column(DocumentDate; Format("Document Date", 0))
            {
            }
            column(PostingDate; Format("Posting Date", 0))
            {
            }
            column(DueDate; Format("Due Date", 0))
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