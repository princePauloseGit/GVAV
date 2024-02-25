codeunit 58101 "Debt Chasing"
{
    /// <summary>
    /// Check overdue sales invoices.
    /// </summary>
    procedure CheckOverdueSaleInvoices()
    var
        RecSalesInvoiceHeader: Record "Sales Invoice Header";
        RecDebtChasing: Record "Debt Chasing";
        IsEmpty: Boolean;
    begin
        IsEmpty := RecDebtChasing.IsEmpty();
        if IsEmpty then begin
            RecSalesInvoiceHeader.SetFilter("Due Date", '<%1', Today);
            RecSalesInvoiceHeader.SetFilter("Remaining Amount", '<>%1', 0);
            if RecSalesInvoiceHeader.FindSet() then
                repeat
                    InsertIntoDebtChasing(RecSalesInvoiceHeader);
                until RecSalesInvoiceHeader.Next() = 0;
        end
        else begin
            RecSalesInvoiceHeader.SetFilter("Due Date", '<%1', Today);
            RecSalesInvoiceHeader.SetFilter("Remaining Amount", '<>%1', 0);
            if RecSalesInvoiceHeader.FindSet() then
                repeat
                    RecDebtChasing.SetRange("Invoice No.", RecSalesInvoiceHeader."No.");
                    if not RecDebtChasing.FindSet() then
                        InsertIntoDebtChasing(RecSalesInvoiceHeader);
                until RecSalesInvoiceHeader.Next() = 0;
        end;
    end;

    /// <summary>
    /// Insert overdue sales invoices into Debt chasing table
    /// </summary>
    /// <param name="RecSalesInvoiceHeader"></param>
    procedure InsertIntoDebtChasing(RecSalesInvoiceHeader: Record "Sales Invoice Header")
    var
        RecDebtChasing: Record "Debt Chasing";
        RecDimensionValue: Record "Dimension Value";
        BranchName, SalesArea : Text;
    begin
        RecDimensionValue.Reset();
        Clear(BranchName);
        Clear(SalesArea);

        RecDimensionValue.SetRange(Code, RecSalesInvoiceHeader."Shortcut Dimension 1 Code");
        if RecDimensionValue.FindFirst() then begin
            BranchName := RecDimensionValue.Name;
        end;

        RecDimensionValue.SetRange(Code, RecSalesInvoiceHeader."Shortcut Dimension 2 Code");
        if RecDimensionValue.FindFirst() then begin
            SalesArea := RecDimensionValue.Name;
        end;

        RecSalesInvoiceHeader.CalcFields("Amount Including VAT");
        RecSalesInvoiceHeader.CalcFields("Remaining Amount");
        RecDebtChasing.Init();
        RecDebtChasing.Id := CreateGuid();
        RecDebtChasing.UserId := UserId;
        RecDebtChasing."Invoice No." := RecSalesInvoiceHeader."No.";
        RecDebtChasing.Branch := BranchName;
        RecDebtChasing."Customer No." := RecSalesInvoiceHeader."Sell-to Customer No.";
        RecDebtChasing."Due Date" := RecSalesInvoiceHeader."Due Date";
        RecDebtChasing."Invoice Date" := RecSalesInvoiceHeader."Order Date";
        RecDebtChasing."Invoice Amount" := RecSalesInvoiceHeader."Amount Including VAT";
        RecDebtChasing."Amount outstanding" := RecSalesInvoiceHeader."Remaining Amount";
        RecDebtChasing."Customer Name" := RecSalesInvoiceHeader."Sell-to Customer Name";
        RecDebtChasing."Sales Area" := SalesArea;
        RecDebtChasing.Insert(true);
    end;
}