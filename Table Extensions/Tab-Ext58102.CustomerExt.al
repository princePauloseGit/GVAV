tableextension 58102 "Customer Ext" extends Customer
{
    fields
    {
        field(58100; "Customer Framework"; Code[20])
        {
            Caption = 'Customer Framework';
            DataClassification = ToBeClassified;
            TableRelation = Framework."Framework Code" Where(Type = Filter(Framework));
        }
        field(58101; "Direct Rebate"; Code[20])
        {
            Caption = 'Direct Rebate';
            DataClassification = ToBeClassified;
            TableRelation = Framework."Framework Code" Where(Type = Filter("Direct Rebate"));
        }
        field(58102; "Exclude from Automatic Email"; Boolean)
        {
            Caption = 'Exclude from Automatic Email';
            DataClassification = ToBeClassified;
        }
    }
}