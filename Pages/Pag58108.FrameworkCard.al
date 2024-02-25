page 58108 "Framework Card"
{
    ApplicationArea = All;
    Caption = 'Framework';
    PageType = XmlPort;
    SourceTable = Framework;

    layout
    {
        area(content)
        {
            group(General)
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
                            VisibleThreshold := true;
                        end
                        else begin
                            VisibleThreshold := false;
                        end;
                    end;
                }
                group(ThresholdRange)
                {
                    ShowCaption = false;
                    // Visible = VisibleThreshold;
                    Editable = VisibleThreshold;
                    field("Threshold Range Minimum"; Rec."Threshold Range Minimum")
                    {
                        ToolTip = 'Specifies the value of the Threshold Range Minimum field.';

                    }
                    field("Threshold Range Maximum"; Rec."Threshold Range Maximum")
                    {
                        ToolTip = 'Specifies the value of the Threshold Range Maximum field.';
                    }
                }

                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
            }
        }
    }

    var
        VisibleThreshold: boolean;

    trigger OnOpenPage()
    var
    begin
        if Rec.Threshold then begin
            VisibleThreshold := true;
        end
        else begin
            VisibleThreshold := false;
        end;

    end;
}
