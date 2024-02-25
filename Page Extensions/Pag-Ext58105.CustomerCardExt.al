pageextension 58105 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addafter("Credit Limit (LCY)")
        {
            field("Customer Framework"; Rec."Customer Framework")
            {
                ApplicationArea = All;
                Caption = 'Customer Framework';
            }
            field("Direct Rebate"; Rec."Direct Rebate")
            {
                ApplicationArea = All;
                Caption = 'Direct Rebate';
            }
            field("Exclude from Automatic Email"; Rec."Exclude from Automatic Email")
            {
                ApplicationArea = All;
                Caption = 'Exclude from Automatic Email';
            }
        }
    }
}
