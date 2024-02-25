table 58103 "Engineer Bookings"
{
    Caption = 'Engineer Bookings';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            AutoIncrement = true;
        }
        field(2; Engineer; Text[100])
        {
            Caption = 'Engineer';
            ValidateTableRelation = false;
            TableRelation = Resource.Name;
            trigger OnValidate()
            var
                RecResource: Record Resource;
            begin
                RecResource.Reset();

                RecResource.SetRange(Name, Rec.Engineer);
                if RecResource.FindFirst() then begin
                    if RecResource.GET(RecResource."No.") then begin
                        Rec."Work Type" := RecResource."Engineer Role";
                        Rec."Engineer Code" := RecResource."No.";
                    end
                end
                else
                    Error('The entered value for engineer is not present in resource records.');
            end;
        }
        field(3; StartTime; Time)
        {
            Caption = 'Start Time';
            InitValue = 090000T;
        }
        field(4; "Project No."; Code[20])
        {
            Caption = 'Project No.';
            trigger OnLookup()
            var
                RecProjectRecord: Record "Project Records";
            begin
                if Page.RunModal(Page::"Project Record List", RecProjectRecord) = Action::LookupOK then begin
                    Rec."Project No." := RecProjectRecord."Project No.";
                    Rec."Project Description" := RecProjectRecord."Job Description";
                end;
            end;
            trigger OnValidate()
            var
                RecProjectRecord: Record "Project Records";
            begin
                if not RecProjectRecord.Get(Rec."Project No.") then
                    Error('The entered value for project no. is not present in project records.');
            end;
        }
        field(5; "Project Description"; Text[250])
        {
            Caption = 'Project Name';
            Editable = false;
        }
        field(6; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(7; "Work Type"; Option)
        {
            Caption = 'Work Type';
            OptionMembers = "","Engineering","Rack Build","Project Management","CSP";
        }
        field(8; "Hours Worked"; Decimal)
        {
            Caption = 'Hours Worked';
        }
        field(9; Notes; Text[2048])
        {
            Caption = 'Notes';
        }
        field(10; "Invite Sent"; Boolean)
        {
            Caption = 'Invite Sent';
            Editable = false;
            InitValue = false;
        }
        field(11; "Engineer Code"; Code[20])
        {
            Caption = 'Engineer Code';
        }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }
}