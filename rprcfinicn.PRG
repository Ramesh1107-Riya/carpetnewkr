*FINISHED (PRC) - Purchase report CarpetNowise
SET DELETED ON
SET PROCEDURE TO Catool
Set Century on
Set safe off
Set Date to Briti
SET ANSI ON

DO csTrimInfo5      && Trim Information for Check Purpose !
Open Database Carpet
*CREATE SQL VIEW temprepview1 AS
SELECT b.BCODE, b.QUALITY, s.CARD_NO, s.WEAVER, s.CARPETNO,  b.DESIGN, b.COLOUR, s.BTHWEAV,;
s.LTHWEAV, s.FINSQMT, b.OL_NO, s.ISSDT, s.GRADE, s.FDate, b.PO_NO, b.NOTES,s.DANDI,s.COMMENT,b.szcode,s.SUPPLIER,s.BillNo,b.Washtype;
FROM  Carpet!Cabuyord b, Carpet!Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) .and.  s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2;
Into Cursor Temprepview1 Nofilter

SELECT t.BCODE, t.QUALITY, t.CARD_NO, t.WEAVER, t.CARPETNO,  t.DESIGN, t.COLOUR, t.BTHWEAV, t.LTHWEAV, t.FINSQMT, t.OL_NO, t.ISSDT,;
	 t.GRADE, t.FDate, t.PO_NO, t.NOTES, t.DANDI, t.COMMENT, t.szcode, t.SUPPLIER, t.BillNo, s.Checker,t.Washtype;
FROM Temprepview1 t, CaSupplr s;
WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes,BillNo) .and. t.Supplier=Alltrim(s.Code) .and. ccsMatch4A(WASHTYPE);		
ORDER BY Carpetno ASC;
Into Cursor temprepview	

SELECT i.*,j.CompName;
FROM temprepview i,casupplr j;
WHERE i.Weaver=j.code;
ORDER BY i.Weaver,i.FDate ASC;
INTO CURSOR temprepviewf
	
Select temprepviewf
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prcfinicn.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcfinicn.frx to printer prompt noconsole
	Case  m.PrnStat="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS WASHTYPE,WEAVER,CARPETNO,OL_NO,DESIGN,COLOUR,SZCODE,BTHWEAV,LTHWEAV,FINSQMT,QUALITY,DANDI,GRADE,CHECKER,COMMENT
		Messagebox("Purchase Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
Endcase
Endif
Return


