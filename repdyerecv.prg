*Report Repdyerecv.prg Dyeing Received Report
SET DELETED ON
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

If empty(m.Dyename)
	SELECT carpetno,pno,quality,colour,refno,qty,dyeisskg,hank,dyeissdt,dyename,bcode,dyrecdt,dyerecvkg,remark,repeatno,redydt;
	FROM yrnchtran;
	WHERE Dyrecdt>=m.SDate .and. Dyrecdt<=m.EDate;
	Into Cursor cDyerecv
Else
	SELECT carpetno,pno,quality,colour,refno,qty,dyeisskg,hank,dyeissdt,dyename,bcode,dyrecdt,dyerecvkg,remark,repeatno,redydt;
	FROM yrnchtran;
	WHERE  Dyrecdt>=m.SDate .and. Dyrecdt<=m.EDate .and. dyename=m.Dyename;
	Into Cursor cDyerecv
Endif


SELECT cDyerecv
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repdyerecv.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repdyerecv.frx to printer prompt noconsole
	Case  m.PrnStat="E" 
	 EXPORT TO &exclfile TYPE XL5 FIELDS carpetno,pno,quality,colour,refno,qty,dyeisskg,hank,dyeissdt,dyename,bcode,dyrecdt,dyerecvkg,remark,repeatno,redydt
   	 Messagebox("Dyeing Received Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 		
Endcase
Endif
Return
