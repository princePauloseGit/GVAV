table 58107 SalesOrderDayBook
{
    Caption = 'SalesOrderDayBook';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Guid)
        {
            Caption = 'Id';
        }
        field(2; No; Code[50])
        {
            Caption = 'No';
        }
        field(3; "Document Type"; Text[50])
        {
            Caption = 'Document Type';
        }
        field(4; "Order Received"; Boolean)
        {
            Caption = 'Order Received';
        }
        field(5; "Date Order Received"; Date)
        {
            Caption = 'Date Order Received';
        }
        field(6; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(7; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
    }
    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }
}