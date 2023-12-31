tableextension 50206 "WareHouse Rec. Header" extends "Warehouse Receipt Header"
{
    fields
    {
        field(50201; "Vendor Invoice No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(50202; "Vendor Invoice Date"; date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF Today < "Vendor Invoice Date" then
                    Error('Vendor invoice date should not greater then %1', Today);
            end;
        }
        field(50203; "LR No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50204; "LR Date"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(50205; Attachment; Text[100])
        {
            Caption = 'Attachment';
            DataClassification = ToBeClassified;
        }
        field(50206; Remarks; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50207; "Vehicle No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}