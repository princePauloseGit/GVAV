tableextension 58101 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(58100; "Reservation Shortage"; Decimal)
        {
            Caption = 'Reservation Shortage';
            DataClassification = ToBeClassified;
        }
        field(58101; DirectShipment; Boolean)
        {
            Caption = 'Direct Shipment';
            DataClassification = ToBeClassified;
        }
        field(58102; "Call Off"; Boolean)
        {
            Caption = 'Call Off';
            DataClassification = ToBeClassified;
        }
        field(58103; "Call Off Date"; Date)
        {
            Caption = 'Call Off Date';
            DataClassification = ToBeClassified;
        }
        field(58104; "Item Type"; Enum "Item Type")
        {
            Caption = 'Item Type';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item.Type where("No." = field("No.")));
        }
        field(58105; "New Item No."; Code[20])
        {
            Caption = 'New Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item."No." where("No." = filter(<> 'TEMPORARY'));
        }
    }
}