page 58104 "Email Trigger"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Email Trigger';
    PageType = Card;

    actions
    {
        area(Navigation)
        {
            action("Sales Orders With No Back To Back Purchase")
            {
                Image = "1099Form";
                ApplicationArea = All;
                Caption = 'Sales Orders With No Back To Back Purchase';
                trigger OnAction()
                var
                    CuSalesOrderWithNoPurchase: Codeunit "Sales Order With No Purchase";
                begin
                    CuSalesOrderWithNoPurchase.Run()
                end;
            }
            action("Sales Orders Call Off")
            {
                Image = "1099Form";
                ApplicationArea = All;
                Caption = 'Sales Orders Call Off';
                trigger OnAction()
                var
                    CuSalesOrderWithNoPurchase: Codeunit "Sales Orders Call Off";
                begin
                    CuSalesOrderWithNoPurchase.Run();
                end;
            }
            action("Invoice Created Not Printed")
            {
                Image = "1099Form";
                ApplicationArea = All;
                Caption = 'Invoice Created Not Printed';
                trigger OnAction()
                var
                    CuInvoiceCreatedNotPrinted: Codeunit "Invoice Created Not Printed";
                begin
                    CuInvoiceCreatedNotPrinted.Run();
                end;
            }
            action("Sales Order Daybook Report")
            {
                Caption = 'Sales Order Daybook Report';
                Image = "1099Form";
                ApplicationArea = All;
                trigger OnAction()
                var
                    ReportSODayBook: Report "Sales Order Daybook Report";
                begin
                    ReportSODayBook.Run();
                end;
            }
            action(AutomateSalesInvoiceEmail)
            {
                Caption = 'Automate Sales Invoice Email';
                Image = "1099Form";
                ApplicationArea = All;
                trigger OnAction()
                var
                    cuAutomateSalesInvoiceEmail: Codeunit AutomateSalesInvoiceEmail;
                begin
                    cuAutomateSalesInvoiceEmail.Run();
                end;
            }
        }
    }
}