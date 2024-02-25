table 58108 IntegrationLogs
{
    Caption = 'IntegrationLogs';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            AutoIncrement = true;
        }
        field(2; Message; Text[2048])
        {
            Caption = 'Message';
        }
        field(3; Severity; Enum Severity)
        {
            Caption = 'Severity';
        }
        field(4; ExtentedMessage; Text[2048])
        {
            Caption = 'Extented Message';
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