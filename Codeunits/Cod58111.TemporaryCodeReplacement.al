codeunit 58111 "Temporary Code Replacement"
{
    /// <summary>
    /// Event to replace value of Temporary code with new item number before inserting sales line
    /// </summary>
    /// <param name="SalesOrderLine"></param>
    /// <param name="SalesOrderHeader"></param>
    /// <param name="SalesQuoteLine"></param>
    /// <param name="SalesQuoteHeader"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeInsertSalesOrderLine', '', false, false)]
    local procedure OnBeforeInsertSalesOrderLine(var SalesOrderLine: Record "Sales Line"; SalesOrderHeader: Record "Sales Header"; SalesQuoteLine: Record "Sales Line"; SalesQuoteHeader: Record "Sales Header")
    var
        RecItem: Record Item;
    begin
        if (SalesQuoteLine."New Item No." <> '') and (SalesQuoteLine."No." = 'TEMPORARY') then begin
            SalesOrderLine."No." := SalesQuoteLine."New Item No.";

            RecItem.SetRange("No.", SalesQuoteLine."New Item No.");
            if RecItem.FindFirst() then begin
                SalesOrderLine.Description := RecItem.Description;
            end;
        end;
    end;

    /// <summary>
    /// Event to check if sales quote contains temporary code and blank new item number before converting sales quote into order
    /// </summary>
    /// <param name="SalesHeader"></param>
    /// <param name="IsHandled"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order (Yes/No)", 'OnBeforeRun', '', false, false)]
    local procedure OnBeforeRun(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        RecSaleLine: Record "Sales Line";
    begin
        RecSaleLine.SetRange("Document Type", SalesHeader."Document Type");
        RecSaleLine.SetRange("Document No.", SalesHeader."No.");
        if RecSaleLine.FindSet() then
            repeat
                if (RecSaleLine."No." = 'TEMPORARY') and (RecSaleLine."New Item No." = '') then begin
                    Error('It cannot be converted into a sales order because the quotation line %1 contains a %2 and a blank New Item number.', RecSaleLine."Line No.", RecSaleLine."No.");
                    IsHandled := true;
                end;
            until RecSaleLine.Next() = 0;
    end;
}