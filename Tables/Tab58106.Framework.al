table 58106 Framework
{
    Caption = 'Framework';
    InherentPermissions = R;
    Permissions = tabledata Framework = R;

    fields
    {
        field(1; "Framework Code"; Code[20])
        {
            Caption = 'Framework Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Rebate Percentage"; Decimal)
        {
            Caption = 'Rebate Percentage';
        }
        field(4; Threshold; Boolean)
        {
            Caption = 'Threshold';
        }
        field(5; "Threshold Range Minimum"; Integer)
        {
            Caption = 'Threshold Range Minimum';
        }
        field(6; "Threshold Range Maximum"; Integer)
        {
            Caption = 'Threshold Range Maximum';
        }
        field(7; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = Framework,"Direct Rebate";
        }
    }
    keys
    {
        key(PK; "Framework Code")
        {
            Clustered = true;
        }
    }
}
