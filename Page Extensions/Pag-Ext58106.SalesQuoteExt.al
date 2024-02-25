pageextension 58106 "Sales Quote Ext" extends "Sales Quote"
{
    layout
    {
        addlast(General)
        {
            field("Customer Framework"; Rec."Customer Framework")
            {
                ApplicationArea = All;
                Caption = 'Customer Framework';
                Editable = IsEditable;
            }
            field("Direct Rebate"; Rec."Direct Rebate")
            {
                ApplicationArea = All;
                Caption = 'Direct Rebate';
                Editable = IsEditable;
            }
            field("Customer Framework Percentage"; Rec."Customer Framework Percentage")
            {
                ApplicationArea = All;
                Caption = 'Customer Framework Percentage';
                Editable = IsEditable;
            }
            field("Direct Rebate Percentage"; Rec."Direct Rebate Percentage")
            {
                ApplicationArea = All;
                Caption = 'Direct Rebate Percentage';
                Editable = IsEditable;
            }
            field("Order Received"; Rec."Order Received")
            {
                ApplicationArea = All;
                Caption = 'Order Received';
            }
            field("Date Order Received"; Rec."Date Order Received")
            {
                ApplicationArea = All;
                Caption = 'Date Order Received';
            }
        }
    }
    var
        IsEditable: Boolean;

    trigger OnOpenPage()
    var
        Cu_CustomerFramework: Codeunit "Customer Framework Options";
    begin
        IsEditable := Cu_CustomerFramework.EditPermission();
    end;
}