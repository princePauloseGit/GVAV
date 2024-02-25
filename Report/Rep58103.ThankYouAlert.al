report 58103 ThankYouAlert
{
    ApplicationArea = All;
    Caption = 'Thank You Alert';
    UsageCategory = Administration;
    DefaultLayout = Word;
    WordLayout = 'Word Layouts\Thank You Alert.docx';
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            column(No; "No.")
            {
            }
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(No_; "No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Unit_Price; "Unit Price")
                {
                }
            }
            trigger OnPreDataItem()
            begin
                SalesHeader.SetFilter("No.", SONo);
            end;
        }
    }

    trigger OnPreReport()
    begin
        SalesHeader.SetFilter("No.", SONo);
    end;

    procedure SetParameter(RecSalesHeader: Record "Sales Header")
    begin
        SONo := RecSalesHeader."No.";
    end;

    var
        SONo: Code[20];
}
