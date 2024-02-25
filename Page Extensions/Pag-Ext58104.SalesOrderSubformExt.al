pageextension 58104 "Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        addafter("Shipment Date")
        {
            field("Call Off Date"; Rec."Call Off Date")
            {
                ApplicationArea = All;
                Caption = 'Call Off Date';
            }
            field("Call Off"; Rec."Call Off")
            {
                ApplicationArea = All;
                Caption = 'Call Off';
            }
        }
    }
}
