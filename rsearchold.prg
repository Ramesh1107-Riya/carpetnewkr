SET DELETED ON
SET PROCEDURE TO Catool
SET TALK OFF
SET SAFE OFF
Set Date to Briti
Set Century off
SET ANSI ON

DO csTrimInfold    && Trim Information for Check Purpose !
Open Database Carpet

SELECT BCODE,CARPETNO,PO_NO,PO_DT,OL_NO,QUALITY,DESIGN,COLOUR,SZCODE,BREADTH,LENGTH,SQMT,NOTES,INVNO,INVDT,BALENO,DELIRY_DT,FDATE,BUYNAME,ISSDT,SUPNAME,BTHWEAV,LTHWEAV,SHIPBY;
FROM Sold;
WHERE ccsMatch3old(BCODE,CARPETNO,PO_NO,OL_NO,QUALITY,DESIGN,SZCODE,COLOUR,NOTES);
ORDER BY  PO_DT;
Into Cursor temprepview

Select temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" 
		Report form rsearchold.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" 
		Report form rsearchold.frx to printer prompt noconsole
	Case  m.PrnStat="E" 
		?SYS(5)+CURDIR()
		CD EXCELFILES	
		EXPORT TO &exclfile TYPE XL5 FIELDS  BCODE,CARPETNO,PO_NO,PO_DT,OL_NO,QUALITY,DESIGN,COLOUR,SZCODE,BREADTH,LENGTH,SQMT,NOTES,INVNO,INVDT,BALENO,DELIRY_DT,FDATE,BUYNAME,ISSDT,SUPNAME,BTHWEAV,LTHWEAV,SHIPBY
		Messagebox("Search All Old Carept 2001 to 2018 Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
		CD..
Endcase
Endif
Return


