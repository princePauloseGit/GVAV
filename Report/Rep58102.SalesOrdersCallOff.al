report 58102 "Sales Orders Call Off"
{
    ApplicationArea = All;
    Caption = 'Sales Orders Call Off';
    UsageCategory = Administration;
    ExcelLayout = 'Excel Layouts\Sales Orders Call Off.xlsx';
    DefaultLayout = Excel;
    dataset
    {
        dataitem(SalesOrderCallOff; "Sales Order Call Off")
        {
            column(Order_No; "Order No.")
            {
            }
            column(Customer_Code; "Customer Code")
            {
            }
            column(Customer_Name; "Customer Name")
            {
            }
            column(Item_Code; "Item Code")
            {
            }
            column(Item_Description; "Item Description")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(Purchase_Order_No; "Purchase Order No.")
            {
            }
            column(Supplier_Code; "Supplier Code")
            {
            }
            column(Supplier_Name; Supplier)
            {
            }
            column(Call_Off_Date; "Call Off Date")
            {
            }
        }
    }
}