tableextension 58100 ResourceExt extends Resource
{
    fields
    {
        field(58100; "Project Manager"; Boolean)
        {
            Caption = 'Project Manager';
            DataClassification = ToBeClassified;
        }
        field(58101; "Engineer Role"; Option)
        {
            Caption = 'Engineer Role';
            DataClassification = ToBeClassified;
            OptionMembers = "","Engineering","Rack Build","Project Management","CSP";
        }
        field(58102; Email; Text[100])
        {
            Caption = 'Email';
            DataClassification = ToBeClassified;
        }
    }
}