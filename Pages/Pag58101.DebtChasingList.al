page 58101 "Debt Chasing List"
{
    ApplicationArea = All;
    Caption = 'Debt Chasing List';
    PageType = List;
    QueryCategory = 'Debt Chasing List';
    SourceTable = "Debt Chasing";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                    DrillDownPageId = "Posted Sales Invoice";
                    trigger OnDrillDown()
                    var
                        RecSalesInvoiceHeader: Record "Sales Invoice Header";
                        PagePostedSalesInvoice: Page "Posted Sales Invoice";
                    begin
                        RecSalesInvoiceHeader.Get(Rec."Invoice No.");
                        PagePostedSalesInvoice.SetRecord(RecSalesInvoiceHeader);
                        PagePostedSalesInvoice.Run();
                    end;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field(Branch; Rec.Branch)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch field.';
                }
                field("Sales Area"; Rec."Sales Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Area field.';
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoce Date field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Amount field.';
                }
                field("Amount outstanding"; Rec."Amount outstanding")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount outstanding field.';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notes field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        CuDebtChasing: Codeunit "Debt Chasing";
    begin
        CuDebtChasing.CheckOverdueSaleInvoices();
    end;
}