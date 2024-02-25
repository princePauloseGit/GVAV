page 58102 "Project Record List"
{
    ApplicationArea = All;
    Caption = 'Project Record List';
    PageType = List;
    SourceTable = "Project Records";
    UsageCategory = Lists;
    CardPageId = "Project Record Card";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Branch; Rec.Branch)
                {
                    ToolTip = 'Specifies the value of the Branch field.';
                }
                field("Project No."; Rec."Project No.")
                {
                    ToolTip = 'Specifies the value of the Project No. field.';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date  field.';
                }
                field("Project Manager"; Rec."Project Manager")
                {
                    ToolTip = 'Specifies the value of the Project Manager field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Job Description"; Rec."Job Description")
                {
                    ToolTip = 'Specifies the value of the Job Description field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }
}
