codeunit 50073 Events
{
    trigger OnRun()
    begin

    end;
    //<<<<<START********************************PAGE-6510*****************************************
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnRegisterChangeOnAfterCreateReservEntry', '', false, false)]
    local procedure OnRegisterChangeOnAfterCreateReservEntry(var ReservEntry: Record "Reservation Entry"; TrackingSpecification: Record "Tracking Specification"; OldTrackingSpecification: Record "Tracking Specification"; CurrentRunMode: Enum "Item Tracking Run Mode"; CurrentSourceType: Integer; TempReservEntry: Record "Reservation Entry");
    begin
        ReservEntry."Back Pack/Display" := OldTrackingSpecification."Back Pack/Display";
        ReservEntry.Modify();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCopyTrackingSpec', '', false, false)]
    local procedure OnAfterCopyTrackingSpec(var SourceTrackingSpec: Record "Tracking Specification"; var DestTrkgSpec: Record "Tracking Specification");
    begin
        DestTrkgSpec."Back Pack/Display" := SourceTrackingSpec."Back Pack/Display";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterEntriesAreIdentical', '', false, false)]
    local procedure OnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean);
    begin
        IdenticalArray[2] := IdenticalArray[2] And (ReservEntry1."Back Pack/Display" = ReservEntry2."Back Pack/Display")
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterMoveFields', '', false, false)]
    local procedure OnAfterMoveFields(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry");
    begin
        ReservEntry."Back Pack/Display" := TrkgSpec."Back Pack/Display";
    end;
    //<<<<<END********************************PAGE-6510*****************************************

    //<<<<<<<START********************************CU-22*****************************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertSetupTempSplitItemJnlLine', '', false, false)]
    local procedure OnBeforeInsertSetupTempSplitItemJnlLine(var TempTrackingSpecification: Record "Tracking Specification"; var TempItemJournalLine: Record "Item Journal Line"; var PostItemJnlLine: Boolean; var ItemJournalLine2: Record "Item Journal Line"; SignFactor: Integer; FloatingFactor: Decimal);
    begin
        TempItemJournalLine."Back Pack/Display" := TempTrackingSpecification."Back Pack/Display";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer);
    begin
        NewItemLedgEntry."Back Pack/Display" := ItemJournalLine."Back Pack/Display";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitValueEntry', '', false, false)]
    local procedure OnAfterInitValueEntry(var ValueEntry: Record "Value Entry"; var ItemJournalLine: Record "Item Journal Line"; var ValueEntryNo: Integer; var ItemLedgEntry: Record "Item Ledger Entry");
    begin
        ValueEntry."Back Pack/Display" := ItemLedgEntry."Back Pack/Display";
    end;
    //<<<<<<<END********************************CU-22*****************************************

    //<<<<<<<START********************************CU-91*****************************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    begin
        DefaultOption := 1;
        IF DefaultOption = 1 then begin
            PurchaseHeader.TestField("Vendor Invoice No.");
            PurchaseHeader.TestField("Document Date");
        end;

    end;
    //>>>>>>>END********************************CU-91*****************************************

    //<<<<<<<START********************************Report-5753*****************************************
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateRcptHeader', '', false, false)]
    local procedure OnAfterCreateRcptHeader(var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WarehouseRequest: Record "Warehouse Request"; PurchaseLine: Record "Purchase Line")
    var
        PurchaseHeader: Record 38;
    begin
        PurchaseHeader.reset;
        PurchaseHeader.SetRange("No.", PurchaseLine."Document No.");
        if PurchaseHeader.FindFirst() then begin
            WarehouseReceiptHeader."Vendor Invoice No." := PurchaseHeader."Vendor Invoice No.";
            WarehouseReceiptHeader."Vendor Invoice Date" := PurchaseHeader."Document Date";
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnSelectEntriesOnAfterTransferFields', '', false, false)]
    local procedure OnSelectEntriesOnAfterTransferFields(var TempTrackingSpec: Record "Tracking Specification"; var TrackingSpecification: Record "Tracking Specification");
    var
        ILE: Record 32;
    begin
        // ILE.RESET;
        // ILE.SETRANGE("Lot No.", TrackingSpecification."Lot No.");
        // IF ILE.FINDFIRST THEN BEGIN
        //     TempTrackingSpec."Back Pack/Display" := ILE."Back Pack/Display";
        //     //TempTrackingSpec.Modify();
        // END;
    end;


}