table 58102 "Project Records"
{
    Caption = 'Project Records';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Guid)
        {
            Caption = 'Id';
        }
        field(2; Branch; Code[20])
        {
            Caption = 'Branch';
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('BRANCH'));
            NotBlank = true;
            trigger OnValidate()
            var
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                Rec."Project No." := getNoSeriesCode(Rec.Branch) + '-' + NoSeriesMgt.GetNextNo(getNoSeriesCode(Rec.Branch), WorkDate(), true);
            end;
        }
        field(3; "Project No."; Code[20])
        {
            Caption = 'Project No.';
            Editable = false;
            NotBlank = true;
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date ';
        }
        field(5; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
                RecCustomer: Record Customer;
            begin
                if RecCustomer.GET(Rec."Customer No.") then
                    Rec."Customer Name" := RecCustomer.Name;
            end;
        }
        field(6; "Customer Name"; Text[2048])
        {
            Caption = 'Customer Name';
        }
        field(7; "Service Value"; Decimal)
        {
            Caption = 'Service Value';
        }
        field(8; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = "Open","Closed","Hold";
        }
        field(9; "Project Manager"; Code[20])
        {
            Caption = 'Project Manager';
            ValidateTableRelation = false;
            TableRelation = Resource.Name where("Project Manager" = const(true));
        }
        field(10; "Job Description"; Text[250])
        {
            Caption = 'Job Description';
        }
        field(11; "Area"; Code[50])
        {
            Caption = 'Area';
            ValidateTableRelation = false;
            TableRelation = "Dimension Value".Name where("Dimension Code" = filter('SALES AREA'));
        }
        field(12; "Quantity Engineering Days"; Integer)
        {
            Caption = 'Quantity Engineering Days';
        }
        field(13; "Quantity Rack Build Days"; Integer)
        {
            Caption = 'Quantity Rack Build Days ';
        }
        field(14; "Quantity PM Days"; Integer)
        {
            Caption = 'Quantity PM Days';
        }
        field(15; "Quantity CSP Days"; Integer)
        {
            Caption = 'Quantity CSP Days';
        }
        field(16; "Number of Rooms"; Integer)
        {
            Caption = 'Number of Rooms ';
        }
        field(17; "Qty. Engineering Days Booked"; Integer)
        {
            Caption = 'Qty. Engineering Days Booked';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Engineer Bookings" where("Work Type" = CONST(Engineering), "Project No." = field("Project No.")));
        }
        field(18; "Qty. Rack Build Days Booked"; Integer)
        {
            Caption = 'Qty. Rack Build Days Booked';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Engineer Bookings" where("Work Type" = CONST("Rack Build"), "Project No." = field("Project No.")));
        }
        field(19; "Qty. PM Days Booked"; Integer)
        {
            Caption = 'Qty. PM Days Booked';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Engineer Bookings" where("Work Type" = CONST("Project Management"), "Project No." = field("Project No.")));
        }
        field(20; IsMailSend; Boolean)
        {
            Caption = 'IsMailSend';
            InitValue = false;
        }
        field(21; "Qty. CSP Days Booked"; Integer)
        {
            Caption = 'Qty. CSP Days Booked';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Engineer Bookings" where("Work Type" = CONST(CSP), "Project No." = field("Project No.")));
        }
        field(22; "Engineer Rate"; Decimal)
        {
            Caption = 'Engineer Rate';
        }
        field(23; "PM Rate"; Decimal)
        {
            Caption = 'PM Rate';
        }
        field(24; "Rack Build Rate"; Decimal)
        {
            Caption = 'Rack Build Rate';
        }
        field(25; "CSP Rate"; Decimal)
        {
            Caption = 'CSP Rate';
        }
    }
    keys
    {
        key(PK; "Project No.")
        {
            Clustered = true;
        }
        key(key1; Id)
        {
            Clustered = false;
        }
    }

    procedure getNoSeriesCode(branch: Code[20]): Code[20];
    var
        RecNoSeries: Record "No. Series";
        NoSeries: code[20];
    begin
        RecNoSeries.SetRange(Code, branch);
        if RecNoSeries.FindFirst() then begin
            NoSeries := RecNoSeries.Code;
        end;
        exit(NoSeries);
    end;
}