tableextension 58105 "Sales Shipment Header Ext" extends "Sales Shipment Header"
{
    fields
    {
        field(58100; "Customer Framework"; Code[20])
        {
            Caption = 'Customer Framework';
            DataClassification = ToBeClassified;
        }
        field(58101; "Direct Rebate"; Code[20])
        {
            Caption = 'Direct Rebate';
            DataClassification = ToBeClassified;
        }
        field(58102; "Customer Framework Percentage"; Decimal)
        {
            Caption = 'Customer Framework Percentage';
            DataClassification = ToBeClassified;
        }
        field(58103; "Direct Rebate Percentage"; Decimal)
        {
            Caption = 'Direct Rebate Percentage';
            DataClassification = ToBeClassified;
        }
    }
}