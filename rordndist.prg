*Order Not Distributed Ordres (carpets)
SET DELETED ON
Set talk off
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

SET PROCEDURE TO CATOOL
DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

CREATE SQL VIEW deliview1 AS SELECT b.BCODE, b.PO_NO, b.CTRL_NO, b.OL_NO, b.QUALITY, b.DESIGN, b.SZCODE, b.COLOUR, b.FIELDCODE, b.BREADTH, b.LENGTH,;
 	b.WASHTYPE, b.SPCL_INST, b.COMMENT, b.CSTATUS, b.ORDER_TYPE, b.CTYPE,  b.SQMT, b.DELIRY_DT;
FROM  Cabuyord b;
WHERE b.CSTATUS="NotDistri"

CREATE SQL VIEW deliview AS SELECT *;
FROM Carpet!deliview1;
WHERE ccsMatch6(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE,;
		 WASHTYPE, SPCL_INST, COMMENT, CSTATUS, CTYPE );
ORDER BY BCODE,PO_NO,OL_NO ASC

USE deliview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A" 
		Report form rordndist.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B" 
		Report form rordndist.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="C"  
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE, PO_NO, QUALITY, CTRL_NO, OL_NO, DESIGN, COLOUR, SZCODE, BREADTH, LENGTH, SQMT, CSTATUS, FIELDCODE, ;
 			WASHTYPE, SPCL_INST, COMMENT, ORDER_TYPE, CTYPE,   DELIRY_DT
		Messagebox("Search Non Distributed Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File")
Endcase
Endif
Return

