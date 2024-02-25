pageextension 58116 "Sales&Rec-Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Default Posting Date")
        {
            field("Internal Email"; Rec."Internal Email")
            {
                Caption = 'Internal Email Address';
            }
        }
    }
}
