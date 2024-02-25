pageextension 58101 "Resource Card Ext" extends "Resource Card"
{
    layout
    {
        addlast(General)
        {
            field("Project Manager"; Rec."Project Manager")
            {
                ApplicationArea = all;
                Caption = 'Project Manager';
            }
        }
        addafter(Name)
        {
            field("Engineer Role"; Rec."Engineer Role")
            {
                ApplicationArea = all;
                Caption = 'Engineer Role';
            }
            field(Email; Rec.Email)
            {
                ApplicationArea = all;
                Caption = 'Email';
            }
        }
    }
}
