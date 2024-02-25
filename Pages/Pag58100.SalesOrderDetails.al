page 58100 "Sales Order Details"
{
    ApplicationArea = All;
    Caption = 'Sales Order History';
    PageType = List;
    SourceTable = "Sales Order Details";
    UsageCategory = Administration;
    InsertAllowed = true;
    DeleteAllowed = false;
    DataCaptionExpression = Rec."Document No.";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity  field.';
                    Caption = 'Quantity';
                    trigger OnValidate()
                    begin
                        NegativeValueValidation(Rec.Quantity, 'Quantity');
                        CalcTotalValue();
                    end;
                }
                field("Total Value"; Rec."Total Value")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Value field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                    Caption = 'Unit Price';
                    trigger OnValidate()
                    begin
                        NegativeValueValidation(Rec."Unit Price", 'Unit Price');
                        CalcTotalValue();
                    end;
                }
                field("Add or Omit"; Rec."Add or Omit")
                {
                    ToolTip = 'Specifies the value of the Add or Omit field.';
                    trigger OnValidate()
                    begin
                        CalcTotalValue();
                    end;
                }
                field(Notes; Rec.Notes)
                {
                    ToolTip = 'Specifies the value of the Notes field.';
                }
            }
        }
    }

    procedure CalcTotalValue()
    var
        EnumAddOmit: Enum "Add or Omit";
    begin
        case Rec."Add or Omit" of
            EnumAddOmit::Addition:
                Rec."Total Value" := Rec.Quantity * Rec."Unit Price" * 1;
            EnumAddOmit::Omission:
                Rec."Total Value" := Rec."Total Value" * -1;
        end;
    end;

    procedure NegativeValueValidation(value: Decimal; Caption: Text)
    begin
        if value < 0 then begin
            Error('%1 should be positive', Caption);
        end;
    end;
}