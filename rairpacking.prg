*AIR PACKING LIST report 
SET DELETE ON
SET TALK OFF
SET SAFE OFF

Open Database Carpet share
CREATE SQL VIEW temprepview AS SELECT p.INVNO, p.BALENO, p.SLNO, p.PO_NO, p.OL_NO, p.SL_NO, p.DESIGN, p.COLOUR,;
			 p.SHIPBRTH, p.SHIPLNGTH, p.SQMT, p.BALEWT, p.FIELDCODE, p.NOTES ;
FROM Carpet!Packtran p;
Where p.ship_inst="AIR";
HAVING p.Invno = m.Invno;
ORDER BY p.SLNO

SET COLOR TO
USE temprepview shared 
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="F"
		Report form rairpacking.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="F"
		Report form rairpacking.frx to printer prompt noconsole

	Case m.PrnStat="V" .and. m.Option="S"
		Report form rairpackgbale.frx PREVIEW WINDOW wReport
		 DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="S"
		Report form rairpackgbale.frx to printer prompt noconsole
	
	Case m.PrnStat="V" .and. m.Option="T"
		Report form rairpackexcl.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="T"
		Report form rairpackexcl.frx to printer prompt noconsole

	Case  m.PrnStat="V" .and. m.Option="E" 
  		EXPORT TO &exclfile TYPE XL5 FIELDS BALENO,SLNO,PO_NO,OL_NO,SL_NO,DESIGN,COLOUR,SHIPBRTH,SHIPLNGTH,SQMT,FIELDCODE,NOTES
		Messagebox("Packing List Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Otherwise
		Messagebox("Invalid choice, make correct Choice!!")
Endcase
Endif
Return