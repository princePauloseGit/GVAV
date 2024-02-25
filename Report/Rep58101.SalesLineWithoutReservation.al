report 58101 SalesLineWithoutReservation
{
    ApplicationArea = All;
    Caption = 'SalesLineWithoutReservation';
    UsageCategory = Administration;
    ExcelLayout = 'Excel Layouts\Sales Lines Without Reservation.xlsx';
    DefaultLayout = Excel;

    dataset
    {
        dataitem(ReservationShortageLine; ReservationShortageLine)
        {
            column(Sales_Order_No; "Sales Order No.")
            {
            }
            column(Customer_No; "Customer No")
            {
            }
            column(Customer_Name; "Customer Name")
            {
            }
            column(Branch; Branch)
            {
            }
            column(Date; Date)
            {
            }
            column(Customer_Reference; "Customer Reference")
            {
            }
            column(Item_No; "Item No.")
            {
            }
            column(Item_Description; Description)
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(Qty_to_Ship; "Qty. to Ship")
            {
            }
            column(Outstanding_Quantity; "Outstanding Quantity")
            {
            }
            column(Reserved_Quantity; "Reserved Quantity")
            {
            }
            column(Reservation_Shortage; "Reservation Shortage")
            {
            }
            column(Purchasing_Code; "Purchasing Code")
            {
            }
            column(Unit_Price; "Unit Price")
            {
            }
            column(Raised_By; "Raised By")
            {
            }
            trigger OnPreDataItem()
            begin
                ReservationShortageLine.SetCurrentKey(Branch, "Customer No");
                ReservationShortageLine.SetAscending(Branch, true);
                ReservationShortageLine.SetAscending("Customer No", true);
            end;
        }
    }
}