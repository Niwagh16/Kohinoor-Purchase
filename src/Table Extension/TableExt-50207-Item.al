tableextension 50207 Item_Status extends Item
{
    fields
    {
        field(50201; "Item Status"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Status"."Item Code";
        }
        field(50202; "EAN Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

    }

    var
        myInt: Integer;
}