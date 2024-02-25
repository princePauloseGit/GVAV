report 58100 "Project Days Over Budget Alert"
{
    ApplicationArea = All;
    Caption = 'Project Days Over Budget Alert';
    UsageCategory = Administration;
    DefaultLayout = Word;
    WordLayout = 'Word Layouts\Report.docx';
    dataset
    {
        dataitem(ProjectRecords; "Project Records")
        {
            column(Area1; "Area")
            {
            }
            column(Branch; Branch)
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(Date; "Date")
            {
            }
            column(Id; Id)
            {
            }
            column(JobDescription; "Job Description")
            {
            }
            column(NumberofRooms; "Number of Rooms")
            {
            }
            column(ProjectManager; "Project Manager")
            {
            }
            column(ProjectNo; "Project No.")
            {
            }
            column(QtyEngineeringDaysBooked; "Qty. Engineering Days Booked")
            {
            }
            column(QtyPMDaysBooked; "Qty. PM Days Booked")
            {
            }
            column(QtyRackBuildDaysBooked; "Qty. Rack Build Days Booked")
            {
            }
            column(QuantityEngineeringDays; "Quantity Engineering Days")
            {
            }
            column(QuantityPMDays; "Quantity PM Days")
            {
            }
            column(QuantityRackBuildDays; "Quantity Rack Build Days")
            {
            }
            column(Status; Status)
            {
            }
            column(Service_Value; "Service Value")
            {
            }
            trigger OnPreDataItem()
            begin
                ProjectRecords.SetFilter("Project No.", ProjectNo);
            end;
        }
    }

    trigger OnPreReport()
    begin
        ProjectRecords.SetFilter("Project No.", ProjectNo);
    end;

    procedure setParameter(recProjectRecord: Record "Project Records")
    begin
        ProjectNo := recProjectRecord."Project No.";
    end;

    var
        ProjectNo: Code[20];
}
