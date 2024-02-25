table 58104 ReservationShortageLine
{
    Caption = 'ReservationShortageLine';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            AutoIncrement = true;
        }
        field(2; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(4; Description; Text[100])
        {
            Caption = 'Drop Shipment';
        }
        field(5; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(6; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
        }
        field(7; "Reserved Quantity"; Decimal)
        {
            Caption = 'Reserved Quantity';
        }
        field(8; "Reservation Shortage"; Decimal)
        {
            Caption = 'Reservation Shortage';
        }
        field(9; "Qty. to Ship"; Decimal)
        {
            Caption = 'Qty. to Ship';
        }
        field(10; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(11; "Purchasing Code"; Code[20])
        {
            Caption = 'Purchasing Code';
        }
        field(12; "Customer No"; Code[20])
        {
            Caption = 'Customer No';
        }
        field(13; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(14; Branch; Text[100])
        {
            Caption = 'Branch';
        }
        field(15; Date; Date)
        {
            Caption = 'Date';
        }
        field(16; "Customer Reference"; Text[50])
        {
            Caption = 'Customer Reference';
        }
        field(17; "Raised By"; Text[2048])
        {
            Caption = 'Raised By';
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
