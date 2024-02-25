codeunit 58100 "Add or Omit"
{
    procedure AddOrOmitSalesOrder(No: Code[20])
    var
        recSalesLine: Record "Sales Line";
        recSalesOrderDetails: Record "Sales Order Details";
    begin
        recSalesOrderDetails.SetRange("Document No.", No);
        if not recSalesOrderDetails.FindFirst() then begin

            recSalesLine.SetRange("Document No.", No);
            if recSalesLine.FindSet() then
                repeat
                    recSalesOrderDetails.Init();
                    recSalesOrderDetails.Date := Today;
                    recSalesOrderDetails.Id := CreateGuid();
                    recSalesOrderDetails."Document No." := recSalesLine."Document No.";
                    recSalesOrderDetails."Item No." := recSalesLine."No.";
                    recSalesOrderDetails.Description := recSalesLine.Description;
                    recSalesOrderDetails.Quantity := recSalesLine.Quantity;
                    recSalesOrderDetails."Unit Price" := recSalesLine."Unit Price";
                    recSalesOrderDetails."Total Value" := recSalesLine.Quantity * recSalesLine."Unit Price";
                    recSalesOrderDetails.Insert(true);
                until recSalesLine.Next() = 0;
        end;
    end;
}