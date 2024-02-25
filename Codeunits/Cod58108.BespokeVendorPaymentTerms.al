codeunit 58108 "Bespoke Vendor Payment Terms"
{
    Permissions = tabledata "Purch. Inv. Header" = rmid;

    /// <summary>
    /// Event to update the value of due date
    /// </summary>
    /// <param name="Rec"></param>
    /// <param name="xRec"></param>
    /// <param name="CurrFieldNo"></param>
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Payment Terms Code', false, false)]
    local procedure OnAfterValidateQuantity(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        RecPaymentTerms: Record "Payment Terms";
        DueDate: Date;
        DocumentDateDay, DocumentDateMonth, AdditinalMonths, DocumentDateYear, DueDateDay, DaysInMonth : Integer;
        RecPurchaseInvoice: Record "Purch. Inv. Header";
        ChangeDueDate: Boolean;
    begin
        Clear(DocumentDateDay);
        Clear(DocumentDateYear);
        Clear(DocumentDateMonth);
        Clear(DueDateDay);
        Clear(AdditinalMonths);

        DocumentDateDay := Date2DMY(Rec."Document Date", 1);
        DocumentDateMonth := Date2DMY(Rec."Document Date", 2);
        DocumentDateYear := Date2DMY(Rec."Document Date", 3);

        RecPaymentTerms.SetRange(Code, Rec."Payment Terms Code");
        RecPaymentTerms.SetRange("Special Terms", true);
        if RecPaymentTerms.FindFirst() then begin

            AdditinalMonths := DocumentDateMonth + RecPaymentTerms."Due Date-add additional months";

            if AdditinalMonths > 12 then begin
                AdditinalMonths := ((AdditinalMonths - 1) MOD 12) + 1;
                DocumentDateYear := DocumentDateYear + 1;
            end;

            DaysInMonth := GetDaysInMonth(AdditinalMonths, DocumentDateYear);

            if (DocumentDateDay >= 1) and (DocumentDateDay <= RecPaymentTerms."From 1st to") then begin

                if RecPaymentTerms."Day of Month From" > DaysInMonth then begin
                    DueDateDay := DaysInMonth;
                end
                else begin
                    DueDateDay := RecPaymentTerms."Day of Month From";
                end;

                DueDate := DMY2Date(DueDateDay, AdditinalMonths, DocumentDateYear);
                ChangeDueDate := true;
            end

            else
                if (DocumentDateDay >= RecPaymentTerms.From) and (DocumentDateDay <= RecPaymentTerms."To") then begin

                    if RecPaymentTerms."Day of month To" > DaysInMonth then begin
                        DueDateDay := DaysInMonth;
                    end
                    else begin
                        DueDateDay := RecPaymentTerms."Day of month To";
                    end;

                    DueDate := DMY2Date(DueDateDay, AdditinalMonths, DocumentDateYear);
                    ChangeDueDate := true;
                end
                else begin
                    ChangeDueDate := false;
                end;

            if ChangeDueDate = true then begin
                Rec."Due Date" := DueDate;
                Rec.Validate("Due Date");
                Rec.Modify(true);
            end;
        end;
    end;

    /// <summary>
    /// procedure to get number of days in month
    /// </summary>
    /// <param name="AdditinalMonths"></param>
    /// <param name="DocumentDateYear"></param>
    /// <returns></returns>
    procedure GetDaysInMonth(AdditinalMonths: Integer; DocumentDateYear: Integer) Days: Integer
    var
        LastDayOfMonth: Date;
    begin
        LastDayOfMonth := CALCDATE('<-CM+CM>', DMY2Date(1, AdditinalMonths, DocumentDateYear));
        Days := Date2DMY(LastDayOfMonth, 1)
    end;
}