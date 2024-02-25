page 58103 "Project Record Card"
{
    ApplicationArea = All;
    Caption = 'Project Record Card';
    PageType = Card;
    SourceTable = "Project Records";
    DataCaptionExpression = Rec."Project No." + ' ∙ ' + Rec."Job Description";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    Editable = false;
                }
                field("Area"; Rec."Area")
                {
                    ToolTip = 'Specifies the value of the Area field.';
                }
                field(Branch; Rec.Branch)
                {
                    ToolTip = 'Specifies the value of the Branch field.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field(Date; Rec.Date)
                {
                    ToolTip = 'Specifies the value of the Date field.';
                }
            }
            group(Project)
            {
                field("Project Manager"; Rec."Project Manager")
                {
                    ToolTip = 'Specifies the value of the Project Manager field.';
                }
                field("Project No."; Rec."Project No.")
                {
                    ToolTip = 'Specifies the value of the Project No. field.';
                }
                field("Job Description"; Rec."Job Description")
                {
                    ToolTip = 'Specifies the value of the Job Description field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Service Value"; Rec."Service Value")
                {
                    ToolTip = 'Specifies the value of the Value field.';
                }
                field("Number of Rooms"; Rec."Number of Rooms")
                {
                    ToolTip = 'Specifies the value of the Number of Rooms  field.';
                }
            }
            group("Quantity Days")
            {
                Grid("")
                {
                    group("Budget Days")
                    {
                        field("Quantity Engineering Days"; Rec."Quantity Engineering Days")
                        {
                            ToolTip = 'Specifies the value of the Quantity Engineering Days field.';
                        }
                        field("Quantity PM Days"; Rec."Quantity PM Days")
                        {
                            ToolTip = 'Specifies the value of the Quantity PM Days field.';
                        }
                        field("Quantity Rack Build Days"; Rec."Quantity Rack Build Days")
                        {
                            ToolTip = 'Specifies the value of the Quantity Rack Build Days  field.';
                        }
                        field("Quantity CSP Days"; Rec."Quantity CSP Days")
                        {
                            ToolTip = 'Specifies the value of the Quantity CSP Days  field.';
                        }
                    }
                    group("Rate")
                    {
                        field("Engineer Rate"; Rec."Engineer Rate")
                        {
                            ToolTip = 'Specifies the value of the Engineering Rate field.';
                        }
                        field("PM Rate"; Rec."PM Rate")
                        {
                            ToolTip = 'Specifies the value of the PM Rate field.';
                        }
                        field("Rack Build Rate"; Rec."Rack Build Rate")
                        {
                            ToolTip = 'Specifies the value of the Rack Build Rate field.';
                        }
                        field("CSP Rate"; Rec."CSP Rate")
                        {
                            ToolTip = 'Specifies the value of the CSP Rate field.';
                        }
                    }
                    group("Booked Days")
                    {
                        field("Qty Engineering Days Booked"; Rec."Qty. Engineering Days Booked")
                        {
                            ToolTip = 'Specifies the value of the Quantity Engineering Days Booked field.';
                            Editable = false;
                        }
                        field("Qty PM Days Booked"; Rec."Qty. PM Days Booked")
                        {
                            ToolTip = 'Specifies the value of the Quantity PM Days Booked field.';
                            Editable = false;
                        }
                        field("Qty Rack Build Days Booked"; Rec."Qty. Rack Build Days Booked")
                        {
                            ToolTip = 'Specifies the value of the Quantity Rack Build Days Booked field.';
                            Editable = false;
                        }
                        field("Qty. CSP Days Booked"; Rec."Qty. CSP Days Booked")
                        {
                            ToolTip = 'Specifies the value of the Quantity CSP Days Booked field.';
                            Editable = false;
                        }
                    }
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        calSum();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        calSum();
    end;

    procedure calSum()
    var
        engRate, PMRate, RBRate, CSPRate, sum : Integer;
    begin
        Clear(sum);
        Clear(engRate);
        Clear(PMRate);
        Clear(RBRate);
        Clear(CSPRate);

        engRate := Rec."Quantity Engineering Days" * Rec."Engineer Rate";
        PMRate := Rec."Quantity PM Days" * rec."PM Rate";
        RBRate := rec."Quantity Rack Build Days" * Rec."Rack Build Rate";
        CSPRate := Rec."Quantity CSP Days" * Rec."CSP Rate";

        sum := engRate + PMRate + RBRate + CSPRate;
        Rec."Service Value" := sum;
        Rec.Modify(true);
    end;
}