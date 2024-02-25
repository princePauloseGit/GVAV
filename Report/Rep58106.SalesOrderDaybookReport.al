report 58106 "Sales Order Daybook Report"
{
    ApplicationArea = All;
    Caption = 'Sales Order Daybook Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'RDLC\Sales Order Daybook Report.RDL';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            column(DocumentType; "Document Type")
            {
            }
            column(No; "No.")
            {
            }
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            column(OrderDate; "Order Date")
            {
            }
            column(OrderReceived; "Order Received")
            {
            }
            column(DateOrderReceived; "Date Order Received")
            {
            }
            trigger OnPreDataItem()
            begin
                SalesHeader.Reset();

                // SalesHeader.FilterGroup(18);
                SalesHeader.SetRange("Order Date", FromDate, ToDate);

                // SalesHeader.FilterGroup(19);
                // SalesHeader.SetRange("Date Order Received", FromDate, ToDate);

                SalesHeader.FilterGroup(-1);
                SalesHeader.SetRange("Document Type", "Sales Document Type"::Order);
                SalesHeader.SetRange("Order Received", true);

                if SalesHeader.FindSet() then begin
                    repeat
                        SalesHeader.Mark(true);
                    until SalesHeader.Next() = 0;
                end;
                SalesHeader.MarkedOnly(true);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(options)
                {
                    Caption = 'Options';
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    var
        FromDate: Date;
        ToDate: Date;

    trigger OnInitReport()
    begin
        SalesHeader.Reset();
    end;
}