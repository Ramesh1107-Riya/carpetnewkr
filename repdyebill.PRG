*Report Repdyebill.prg Dyeing Issue Report
SET DELETED ON
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

If empty(m.Dyename)
	SELECT carpetno,pno,quality,colour,refno,qty,dyeisskg,hank,dyeissdt,dyename,bcode,construction;
	FROM yrnchtran;
	WHERE Dyeissdt>=m.SDate .and.  Dyeissdt<=m.EDate;
	Into Cursor cDyebill
Else
	SELECT carpetno,pno,quality,colour,refno,qty,dyeisskg,hank,dyeissdt,dyename,bcode,construction;
	FROM yrnchtran;
	WHERE Dyeissdt>=m.SDate .and.  Dyeissdt<=m.EDate .and. dyename=m.Dyename;
	Into Cursor cDyebill
Endif


SELECT cDyebill
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repdyebill.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repdyebill.frx to printer prompt noconsole
	Case  m.PrnStat="E" 
	 EXPORT TO &exclfile TYPE XL5 FIELDS carpetno,pno,quality,colour,refno,qty,dyeisskg,hank,dyeissdt,dyename,bcode,construction
   	 Messagebox("Dyeing Issue Bill Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
Endcase
Endif
Return
