tableextension 58103 "Sales Header Ext" extends "Sales Header"
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
        field(58104; "Order Received"; Boolean)
        {
            Caption = 'Order Received';
            DataClassification = ToBeClassified;
        }
        field(58105; "Date Order Received"; Date)
        {
            Caption = 'Date Order Received';
            DataClassification = ToBeClassified;
        }
        field(58106; "isSOConfirmationEmailSent"; Boolean)
        {
            Caption = 'Is SO Confirmation email sent';
            DataClassification = ToBeClassified;
        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                RecCustomer: Record Customer;
                RecFramework: Record Framework;
                DirectRebate, CustomerFramework : Code[20];
                CustomerFrameworkPercentage, DirectRebatePercentage : Decimal;
            begin
                Clear(DirectRebate);
                Clear(CustomerFramework);
                Clear(CustomerFrameworkPercentage);
                Clear(DirectRebatePercentage);

                RecCustomer.Reset();
                RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
                if RecCustomer.FindFirst() then begin
                    DirectRebate := RecCustomer."Direct Rebate";
                    CustomerFramework := RecCustomer."Customer Framework";
                end;

                RecFramework.Reset();
                RecFramework.SetRange("Framework Code", CustomerFramework);
                if RecFramework.FindFirst() then begin
                    CustomerFrameworkPercentage := RecFramework."Rebate Percentage";
                end;

                RecFramework.Reset();
                RecFramework.SetRange("Framework Code", DirectRebate);
                if RecFramework.FindFirst() then begin
                    DirectRebatePercentage := RecFramework."Rebate Percentage";
                end;

                Rec."Customer Framework" := CustomerFramework;
                Rec."Direct Rebate" := DirectRebate;
                Rec."Customer Framework Percentage" := CustomerFrameworkPercentage;
                Rec."Direct Rebate Percentage" := DirectRebatePercentage;

                if (Rec."No." = '') then begin
                    Rec.Insert(true);
                end else
                    Rec.Modify(true);
            end;
        }
    }
}