*Report Repdyebill.prg Dyeing Issue Report
SET DELETED ON
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

If empty(m.Dyename)
	SELECT Distinc b.carpetno,a.pno,a.quality,a.colour,b.refno,b.qty,a.quantity,a.hank,a.date,a.Suplier,b.bcode,b.construction;
	FROM Yrnissdy a;
	Inner Join Yrnchtran b;
	On a.Ol_no=b.Carpetno;
	WHERE Date>=m.SDate .and.  Date<=m.EDate ;
	Into Cursor cDyebill
Else
	SELECT Distinc b.carpetno,a.pno,a.quality,a.colour,b.refno,b.qty,a.quantity,a.hank,a.date,a.Suplier,b.bcode,b.construction;
	FROM Yrnissdy a;
	Inner Join Yrnchtran b;
	On a.Ol_no=b.Carpetno;
	WHERE Date>=m.SDate .and.  Date<=m.EDate .and. Suplier=m.Dyename ;
	Into Cursor cDyebill
Endif
*OL_NO,PNO,QUALITY,COLOUR,DATE,BILLNO,QUANTITY,SUPLIER;
*carpetno,pno,quality,colour,refno,qty,dyeisskg,hank,dyeissdt,dyename,bcode
SELECT cDyebill
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repdyebilladd.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repdyebilladd.frx to printer prompt noconsole
	Case  m.PrnStat="E" 
	 EXPORT TO &exclfile TYPE XL5 FIELDS carpetno,pno,quality,colour,refno,qty,quantity,hank,date,Suplier,bcode,construction
   	 Messagebox("Dyeing Issue Bill Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
Endcase
Endif
Return
