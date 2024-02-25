codeunit 58107 "Customer Framework Options"
{
    /// <summary>
    /// Procedure to set permissions to record based on permission set
    /// </summary>
    /// <returns></returns>
    procedure EditPermission() SetPermission: Boolean;
    var
        RecAccessControl: Record "Access Control";
        RecPermission: Record "Expanded Permission";
    begin
        RecAccessControl.SetRange("User Security ID", UserSecurityId());
        RecAccessControl.SetFilter("Role ID", '=%1|=%2', 'FRAMEWORKACCESS', 'SUPER');

        if RecAccessControl.FindSet() then begin
            SetPermission := true;
        end
        else begin
            SetPermission := false;
        end;
    end;

    /// <summary>
    /// event to insert values for framework fields after creating warehouse shipment
    /// </summary>
    /// <param name="WarehouseShipmentHeader"></param>
    /// <param name="WarehouseRequest"></param>
    /// <param name="SalesLine"></param>
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateShptHeader', '', false, false)]
    local procedure OnAfterCreateShptHeader(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; WarehouseRequest: Record "Warehouse Request"; SalesLine: Record "Sales Line");
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(Enum::"Sales Document Type"::Order, SalesLine."Document No.") then begin
            WarehouseShipmentHeader."Customer Framework" := SalesHeader."Customer Framework";
            WarehouseShipmentHeader."Direct Rebate" := SalesHeader."Direct Rebate";
            WarehouseShipmentHeader."Customer Framework Percentage" := SalesHeader."Customer Framework Percentage";
            WarehouseShipmentHeader."Direct Rebate Percentage" := SalesHeader."Direct Rebate Percentage";
            WarehouseShipmentHeader.Modify(true);
        end;
    end;
}