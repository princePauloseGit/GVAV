pageextension 58113 "Warehouse Shipment Ext" extends "Warehouse Shipment"
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
