tableextension 58109 "Payment Terms Ext" extends "Payment Terms"
{
    fields
    {
        field(58100; "Special Terms"; Boolean)
        {
            Caption = 'Special Terms';
            DataClassification = ToBeClassified;
        }
        field(58101; "From 1st to"; Integer)
        {
            Caption = 'From 1st to ';
            DataClassification = ToBeClassified;
            MinValue = 1;
            MaxValue = 31;
            trigger OnValidate()
            begin
                if Rec."From 1st to" = 31 then begin
                    Rec.From := Rec."From 1st to";
                end
                else
                    Rec.From := Rec."From 1st to" + 1;
            end;
        }
        field(58102; "Day of Month From"; Integer)
        {
            Caption = 'Day of Month';
            DataClassification = ToBeClassified;
            MinValue = 1;
            MaxValue = 31;
        }
        field(58103; From; Integer)
        {
            Caption = 'From';
            DataClassification = ToBeClassified;
            Editable = false;
            MaxValue = 31;
        }
        field(58104; "To"; Integer)
        {
            Caption = 'To';
            DataClassification = ToBeClassified;
            MinValue = 1;
            MaxValue = 31;
            trigger OnValidate()
            begin
                if Rec."To" <> 31 then begin
                    if Rec."To" <= Rec.From then begin
                        Error('Value for "To" field must be greater than "From" field value.');
                    end;
                end
                else
                    if Rec."To" < Rec.From then begin
                        Error('Value for "To" field must be greater than "From" field value.');
                    end;

            end;
        }
        field(58105; "Day of month To"; Integer)
        {
            Caption = 'Day of month';
            DataClassification = ToBeClassified;
            MinValue = 1;
            MaxValue = 31;
        }
        field(58106; "Due Date-add additional months"; Option)
        {
            Caption = 'Due Date - add additional months';
            DataClassification = ToBeClassified;
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10","11","12";
        }
    }
    trigger OnInsert()
    begin
        Rec."To" := 31;
    end;
}