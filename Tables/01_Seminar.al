table 123456701 "CSD Seminar"
{
    Caption = 'Seminar';

    fields
    {
        field(10; "No."; code[20])
        {
            Caption = 'No.';

            trigger OnValidate();
            begin
                if "No." <> xRec."No." then begin
                    SeminarSetup.GET;
                    NoSeriesManagement.TestManual(SeminarSetup."Seminar Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(20; "Name"; text[50])
        {
            Caption = 'Name';

            trigger OnValidate();
            begin
                if("Search Name" = UpperCase(xRec.Name))
                or("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(30; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0 : 1;
        }
        field(40; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        field(50; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(60; "Search Name"; code[50])
        {
            Caption = 'Search Name';
        }
        field(70; "Blocked"; Boolean)
        {
            Caption = 'Blocked';
        }
        field(80; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(90; "Comment"; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            //CalcFormula=exist("Seminar Comment Line" where("Table Name"= const("Seminar"),"No."=Field("No.")));
        }
        field(100; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 1;
        }
        field(110; "Gen. Prod. Posting Group"; code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate();
            begin
                if "Gen. Prod. Posting Group" <> xRec."Gen. Prod. Posting Group" then begin
                    if GenProductPostingGroup.ValidateVatProdPostingGroup(GenProductPostingGroup, "Gen. Prod. Posting Group") then begin
                        validate("VAT Prod. Posting Group", GenProductPostingGroup."Def. VAT Prod. Posting Group");
                    end;
                end;
            end;
        }
        field(120; "VAT Prod. Posting Group"; code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(130; "No. Series"; code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        SeminarSetup: Record "CSD Seminar Setup";
        //SeminarCommentLine : Record "CSD Seminar Comment Line";
        Seminar: Record "CSD Seminar";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
        NoSeriesManagement: Codeunit "NoSeriesManagement";

    trigger OnInsert();
    var
        NoSeriesMgt: codeunit NoSeriesManagement;
        SeminarSetup: Record "CSD Seminar Setup";
    begin
        if "No." = '' then begin
            SeminarSetup.GET;
            SeminarSetup.TestField("Seminar Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

    end;

    trigger OnModify();
    begin
        "Last Date Modified" := today;
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := today;
    end;

    trigger OnDelete();
    begin

    end;

    procedure AssistEdit(): Boolean;
    begin
        with Seminar do
        begin
            Seminar := rec;
            SeminarSetup.get;
            SeminarSetup.TestField("Seminar Nos.");
            if NoSeriesManagement.SelectSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", "No. Series") then begin
                NoSeriesManagement.SetSeries("No.");
                rec := Seminar;
                exit(true);
            end;
        end;
    end;
}