table 58100 "Sales Order Details"
{
    Caption = 'Sales Order Details';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Guid)
        {
            Caption = 'Id';
        }
        field(2; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(3; "Add or Omit"; Enum "Add or Omit")
        {
            Caption = 'Add or Omit';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity ';
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(8; "Total Value"; Decimal)
        {
            Caption = 'Total Value';
        }
        field(9; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(10; Notes; Text[200])
        {
            Caption = 'Notes';
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
