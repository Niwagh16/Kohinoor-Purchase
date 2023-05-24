codeunit 50202 Events
{
    trigger OnRun()
    begin

    end;
    //<<<<<<<START********************************CU-90*****************************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterInsertReceiptHeader', '', false, false)]
    local procedure OnAfterInsertReceiptHeader(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; WhseReceive: Boolean; CommitIsSuppressed: Boolean)
    begin
        //PurchRcptHeader."Vendor Invoice No." := PurchHeader."Vendor Invoice No.";
        PurchRcptHeader."Vendor Invoice No." := TempWhseRcptHeader."Vendor Invoice No.";
        PurchRcptHeader."LR No." := TempWhseRcptHeader."LR No.";
        PurchRcptHeader."LR Date" := TempWhseRcptHeader."LR Date";
        PurchRcptHeader.Modify();
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnInsertReceiptLineOnAfterCalcShouldGetWhseRcptLine', '', false, false)]
    // local procedure OnInsertReceiptLineOnAfterCalcShouldGetWhseRcptLine(PurchRcptHeader: Record "Purch. Rcpt. Header"; PurchLine: Record "Purchase Line"; PostedWhseRcptHeader: Record "Posted Whse. Receipt Header"; WhseRcptHeader: Record "Warehouse Receipt Header"; CostBaseAmount: Decimal; WhseReceive: Boolean; WhseShip: Boolean; var ShouldGetWhseRcptLine: Boolean; xPurchLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    // begin
    //     PurchRcptHeader."Vendor Invoice No." := WhseRcptHeader."Vendor Invoice No.";
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostItemJnlLineOnAfterCopyDocumentFields', '', false, false)]
    // local procedure OnPostItemJnlLineOnAfterCopyDocumentFields(var ItemJournalLine: Record "Item Journal Line"; PurchaseLine: Record "Purchase Line"; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; PurchRcptHeader: Record "Purch. Rcpt. Header")
    // begin
    //     PurchRcptHeader."Vendor Invoice No." := WarehouseReceiptHeader."Vendor Invoice No.";
    // end;
    //<<<<<<<END********************************CU-90*****************************************

    [EventSubscriber(ObjectType::Report, report::"Copy Purchase Document", 'OnValidateDocNoOnAfterTransferFieldsFromPurchRcptHeader', '', false, false)]
    local procedure OnValidateDocNoOnAfterTransferFieldsFromPurchRcptHeader(FromPurchHeader: Record "Purchase Header"; FromPurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        FromPurchHeader."Vendor Invoice No." := FromPurchRcptHeader."Vendor Invoice No.";
    end;


    //<<<<<START********************************CU-6500*****************************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnAfterCreateSNInformation', '', false, false)]
    local procedure OnAfterCreateSNInformation(var SerialNoInfo: Record "Serial No. Information"; TrackingSpecification: Record "Tracking Specification")
    begin
        SerialNoInfo."Back Pack Dispaly" := TrackingSpecification."Back Pack Dispaly";
    end;
    //<<<<<END********************************CU-6500*****************************************

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
    var
        RecItem: Record 27;
    begin
        NewItemLedgEntry."Back Pack/Display" := ItemJournalLine."Back Pack/Display";
        //<<PCPL/NSW/07  CODE FOR OTHER REQUIRMENT TO FLOW NEW FIELD TO ILE
        NewItemLedgEntry.Reset();
        NewItemLedgEntry.SetRange("Item No.", RecItem."No.");
        IF NewItemLedgEntry.FindFirst() then
            NewItemLedgEntry."Item Status" := RecItem."Item Status";
        //>>PCPL/NSW/07  CODE FOR OTHER REQUIRMENT TO FLOW NEW FIELD TO ILE
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
    //<<<<<<<END********************************CU-415*****************************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterReleasePurchaseDoc', '', false, false)]
    local procedure OnAfterReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    var
        Vend: Record Vendor;
        PL: record "Purchase Line";
    begin
        IF PurchaseHeader.Status = PurchaseHeader.Status::Released then begin
            IF Vend.get(PurchaseHeader."Buy-from Vendor No.") then
                if Vend."E-Mail" = '' then
                    Message('Vendor Email is blank so system will not send the mail')
                else
                    // IF Confirm('Do you want to send the mail', true) then
                    PurchaseHeader.SendMail();
            //end;////
        end;
    end;

}