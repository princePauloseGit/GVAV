page 58105 "Engineer Bookings List"
{
    ApplicationArea = All;
    Caption = 'Engineer Bookings';
    PageType = List;
    SourceTable = "Engineer Bookings";
    UsageCategory = Lists;
    CardPageId = "Engineer Bookings Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Engineer"; Rec.Engineer)
                {
                    Caption = 'Engineer';
                    ToolTip = 'Specifies the value of the Engineer Name field.';
                }
                field("Project No."; Rec."Project No.")
                {
                    ToolTip = 'Specifies the value of the Project No. field.';
                }
                field("Project Description"; Rec."Project Description")
                {
                    ToolTip = 'Specifies the value of the Project Description field.';
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
                }
                field("Invite Sent"; Rec."Invite Sent")
                {
                    ToolTip = 'Specifies the value of the Invite Sent field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ScheduleAppointment)
            {
                Image = "1099Form";
                ApplicationArea = All;
                Caption = 'Schedule Appointment';
                trigger OnAction()
                var
                    CuEngineerAppointments: Codeunit "Engineer Appointments";
                begin
                    if (Rec.Date >= Today) and (format(Rec.StartTime) <> '') and (Rec."Invite Sent" = false) then begin
                        CuEngineerAppointments.CreateAndSend(Rec);
                    end;

                    if Rec."Invite Sent" = true then begin
                        Message('The appointment is already scheduled for this record.');
                    end;

                    if (Rec.Date < Today) then begin
                        Error('The appointment date should be greater than the current date.');
                    end;

                    if Rec."Hours Worked" <= 0 then begin
                        Error('Hours Worked should be greater than 0');
                    end;
                end;
            }
        }
    }
}