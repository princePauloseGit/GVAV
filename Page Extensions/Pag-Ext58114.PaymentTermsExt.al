pageextension 58114 "Payment Terms Ext" extends "Payment Terms"
{
    layout
    {
        addlast(Control1)
        {
            field("Special Terms"; Rec."Special Terms")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                begin
                    if Rec."Special Terms" = true then begin
                        IsEditable := true;
                    end
                    else begin
                        IsEditable := false;
                    end;
                end;
            }
            field("From 1st to"; Rec."From 1st to")
            {
                ApplicationArea = All;
                Editable = IsEditable;
            }
            field("Day of Month From"; Rec."Day of Month From")
            {
                ApplicationArea = All;
                Editable = IsEditable;
            }
            field(From; Rec.From)
            {
                ApplicationArea = All;
                Editable = false;
                MaxValue = 31;
            }
            field(To; Rec."To")
            {
                ApplicationArea = All;
                Editable = IsEditable;
            }
            field("Day of month To"; Rec."Day of month To")
            {
                ApplicationArea = All;
                Editable = IsEditable;
            }
            field("Due Date-add additional months"; Rec."Due Date-add additional months")
            {
                ApplicationArea = All;
                Editable = IsEditable;
            }
        }
    }
    var
        IsEditable: Boolean;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec."Special Terms" = false then begin
            IsEditable := false;
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Special Terms" = true then begin
            IsEditable := true;
        end
        else begin
            IsEditable := false;
        end;
    end;
}