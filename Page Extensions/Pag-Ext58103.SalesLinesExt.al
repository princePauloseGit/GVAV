pageextension 58103 "Sales Lines Ext" extends "Sales Lines"
{
    layout
    {
        addafter("Reserved Qty. (Base)")
        {
            field("Reservation Shortage"; Rec."Reservation Shortage")
            {
                Caption = 'Reservation Shortage';
                ApplicationArea = all;
            }
            field("Purchasing Code"; Rec."Purchasing Code")
            {
                Caption = 'Purchasing Code';
                ApplicationArea = all;
            }
        }
    }
}