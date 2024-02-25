pageextension 58100 "Sales Order Ext" extends "Sales Order"
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
    actions
    {
        addfirst(processing)
        {
            action("Add and Omit")
            {
                Caption = 'Add and Omit';
                ApplicationArea = All;
                Image = History;

                trigger OnAction();
                var
                    RecSalesOrderDetails: Record "Sales Order Details";
                    CuAddorOmit: Codeunit "Add or Omit";
                begin
                    CuAddorOmit.AddOrOmitSalesOrder(Rec."No.");
                    RecSalesOrderDetails.Reset();
                    RecSalesOrderDetails.SetRange("Document No.", Rec."No.");
                    if RecSalesOrderDetails.FindFirst() then begin
                        Page.Run(Page::"Sales Order Details", RecSalesOrderDetails);
                    end;
                end;
            }
            action("Send Order Confirmation Email")
            {
                Caption = 'Send Order Confirmation Email';
                ApplicationArea = All;
                Image = Email;

                trigger OnAction();
                var
                    cuSalesOrderConfirmation: Codeunit SalesOrderConfirmation;
                begin
                    cuSalesOrderConfirmation.SendSalesOrderWithEmailMessage(Rec);
                end;
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