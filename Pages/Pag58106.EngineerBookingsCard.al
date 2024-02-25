page 58106 "Engineer Bookings Card"
{
    ApplicationArea = All;
    Caption = 'Engineer Booking';
    PageType = XmlPort;
    SourceTable = "Engineer Bookings";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Project No."; Rec."Project No.")
                {
                    ToolTip = 'Specifies the value of the Project No. field.';
                }
                field("Project Description"; Rec."Project Description")
                {
                    ToolTip = 'Specifies the value of the Project Description field.';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(StartTime; Rec.StartTime)
                {
                    ToolTip = 'Specifies the value of the Role field.';
                    ShowMandatory = true;
                }
                field(Engineer; Rec.Engineer)
                {
                    ToolTip = 'Specifies the value of the Engineer field.';
                }
                field("Work Type"; Rec."Work Type")
                {
                    ToolTip = 'Specifies the value of the Work Type field.';
                }
                field("Hours Worked"; Rec."Hours Worked")
                {
                    ToolTip = 'Specifies the value of the Hours Worked field.';
                }
                field(Notes; Rec.Notes)
                {
                    ToolTip = 'Specifies the value of the Notes field.';
                    MultiLine = true;
                }
                field("Invite Sent"; Rec."Invite Sent")
                {
                    ToolTip = 'Specifies the value of the Invite Sent field.';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if (Rec."Project No." = '') then begin
            Error('Project No. must have a value in Engineer Bookings');
            exit(false);
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Format(Rec.StartTime) = '' then begin
            Error('Start Time must have a value in Engineer Bookings');
            exit(false);
        end;
    end;
}