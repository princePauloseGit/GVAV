tableextension 58108 "Warehouse Shipment Header Ext" extends "Warehouse Shipment Header"
{
    fields
    {
        field(58100; "Customer Framework"; Code[20])
        {
            Caption = 'Customer Framework';
            DataClassification = ToBeClassified;
            TableRelation = Framework."Framework Code" Where(Type = Filter(Framework));
            trigger OnValidate()
            var
                RecFramework: Record Framework;
                CustomerFrameworkPercentage: decimal;
            begin
                Clear(CustomerFrameworkPercentage);

                RecFramework.Reset();
                RecFramework.SetRange("Framework Code", Rec."Customer Framework");
                if RecFramework.FindFirst() then begin
                    CustomerFrameworkPercentage := RecFramework."Rebate Percentage";
                end;

                Rec."Customer Framework Percentage" := CustomerFrameworkPercentage;
                Rec.Modify();
            end;
        }
        field(58101; "Direct Rebate"; Code[20])
        {
            Caption = 'Direct Rebate';
            DataClassification = ToBeClassified;
            TableRelation = Framework."Framework Code" Where(Type = Filter("Direct Rebate"));
            trigger OnValidate()
            var
                RecFramework: Record Framework;
                DirectRebatePercentage: decimal;
            begin
                Clear(DirectRebatePercentage);

                RecFramework.Reset();
                RecFramework.SetRange("Framework Code", Rec."Direct Rebate");
                if RecFramework.FindFirst() then begin
                    DirectRebatePercentage := RecFramework."Rebate Percentage";
                end;

                Rec."Direct Rebate Percentage" := DirectRebatePercentage;
                Rec.Modify();
            end;
        }
        field(58102; "Customer Framework Percentage"; Decimal)
        {
            Caption = 'Customer Framework Percentage';
            DataClassification = ToBeClassified;
        }
        field(58103; "Direct Rebate Percentage"; Decimal)
        {
            Caption = 'Direct Rebate Percentage';
            DataClassification = ToBeClassified;
        }
    }
}
