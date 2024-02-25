pageextension 58115 "Sales Quote Subform Ext" extends "Sales Quote Subform"
{
    layout
    {
        addafter("No.")
        {
            field("New Item No."; Rec."New Item No.")
            {
                ApplicationArea = All;
                Caption = 'New Item No.';
            }
        }
    }
}