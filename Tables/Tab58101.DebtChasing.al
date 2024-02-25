table 58101 "Debt Chasing"
{
    Caption = 'Debt Chasing';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(2; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
        }
        field(3; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(4; Branch; Code[20])
        {
            Caption = 'Branch';
        }
        field(5; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(6; "Amount outstanding"; Decimal)
        {
            Caption = 'Amount outstanding';
        }
        field(7; Notes; Text[2048])
        {
            Caption = 'Notes';
        }
        field(8; "Invoice Amount"; Decimal)
        {
            Caption = 'Invoice Amount';
        }
        field(9; Id; Guid)
        {
            Caption = 'Id';
        }
        field(10; UserId; Code[100])
        {
            Caption = 'UserId';
        }
        field(11; "Customer Name"; Text[250])
        {
            Caption = 'Customer Name';
        }
        field(12; "Sales Area"; Code[20])
        {
            Caption = 'Sales Area';
        }
    }
    keys
    {
        key(PK; Id)
        {
        }
    }
}