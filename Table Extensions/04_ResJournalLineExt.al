tableextension 123456704 "CSD ResJournalLineExt" extends "Res. Journal Line"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 4-2
{
    fields
    {
        field(123456700;"CSD Seminar No.";code[20])
        {
            Caption='Seminar No.';
            TableRelation=Seminar;
        }
        field(123456701;"CSD Seminar Registration No.";code[20])
        {
            Caption='Seminar Registration No.';
            TableRelation="Seminar Registration Header";
        }        
    }
}