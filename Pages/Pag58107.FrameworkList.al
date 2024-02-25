page 58107 "Framework List"
{
    ApplicationArea = All;
    Caption = 'Frameworks';
    PageType = List;
    SourceTable = Framework;
    UsageCategory = Lists;
    Permissions = tabledata Framework = R;
    // Editable = false;
    CardPageId = "Framework Card";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Framework Code"; Rec."Framework Code")
                {
                    ToolTip = 'Specifies the value of the Framework Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Rebate Percentage"; Rec."Rebate Percentage")
                {
                    ToolTip = 'Specifies the value of the Rebate Percentage field.';
                }
                field(Threshold; Rec.Threshold)
                {
                    ToolTip = 'Specifies the value of the Threshold field.';
                    trigger OnValidate()
                    begin
                        if Rec.Threshold = true then begin
                            EditThreshold := true;
                        end
                        else begin
                            EditThreshold := false;
                        end;
                    end;
                }
                field("Threshold Range Minimum"; Rec."Threshold Range Minimum")
                {
                    ToolTip = 'Specifies the value of the Threshold Range Minimum field.';
                    Editable = EditThreshold;
                }
                field("Threshold Range Maximum"; Rec."Threshold Range Maximum")
                {
                    ToolTip = 'Specifies the value of the Threshold Range Maximum field.';
                    Editable = EditThreshold;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
            }
        }
    }
    var
        EditThreshold: Boolean;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Threshold = false then begin
            EditThreshold := false;
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Threshold = true then begin
            EditThreshold := true;
        end
        else begin
            EditThreshold := false;
        end;
    end;
}