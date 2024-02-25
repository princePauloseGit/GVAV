page 58109 "Integration Log"
{
    ApplicationArea = All;
    Caption = 'GVAV Integration Log';
    PageType = List;
    SourceTable = IntegrationLogs;
    UsageCategory = Administration;
    SourceTableView = sorting(Id)
    order(descending);
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec.Id)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Message; Rec.Message)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(ExtentedMessage; Rec.ExtentedMessage)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Severity; Rec.Severity)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }
}