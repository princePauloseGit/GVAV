table 58105 "Sales Order Call Off"
{
    Caption = 'Sales Order Call Off';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            AutoIncrement = true;
        }
        field(2; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(4; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(6; Supplier; Code[50])
        {
            Caption = 'Supplier';
        }
        field(7; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
        }
        field(8; "Line No."; Integer)
        {
            Caption = 'Line No';
        }
        field(9; "Call Off Date"; Date)
        {
            Caption = 'Call Off Date';
        }
        field(10; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
        }
        field(11; "Supplier Code"; Code[20])
        {
            Caption = 'Supplier Code';
        }
        field(12; "Supplier Name"; Text[100])
        {
            Caption = 'Supplier Name';
        }
        field(13; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
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
