pageextension 58102 "Resource List Ext" extends "Resource List"
{
    layout
    {
        addafter(Name)
        {
            field("Engineer Role"; Rec."Engineer Role")
            {
                Caption = 'Engineer Role';
                ApplicationArea = all;
            }
        }
    }
}
