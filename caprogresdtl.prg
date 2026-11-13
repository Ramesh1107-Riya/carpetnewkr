*Carpet Progress Report made from Order Not Distributed Report- for this required fileds are little more
SET DELETED ON
Set talk off
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

SET PROCEDURE TO CATOOL
DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

SELECT  BCODE, PO_NO, PO_DT, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, FIELDCODE,;
 	WASHTYPE, SPCL_INST, COMMENT, b.CSTATUS, ORDER_TYPE, CTYPE, SQMT, DELIRY_DT,QTY,c.GSTATUS,b.datetime;
FROM  Carpet!Cabuyord b, CSTATUS c;
HAVING c.status=alltrim(b.cstatus);
WHERE ccsMatch6a(BCODE, PO_NO, QUALITY, DESIGN, SZCODE, COLOUR) .AND. PO_DT>=m.Startdt .and. PO_DT<=m.Enddt;
ORDER BY b.datetime;
INTO CURSOR CAPROGRESDTL

*&WHERE ccsMatch6(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, WASHTYPE, SPCL_INST, COMMENT, CSTATUS, CTYPE );
* .AND. PO_DT>=m.Startdt .and. PO_DT<=m.Enddt;

SELECT CAPROGRESDTL
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A" 
		Report form caprogresdtl.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B" 
		Report form caprogresdtl.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="C"  
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE, PO_NO, QUALITY, OL_NO, DESIGN, COLOUR, SZCODE, SQMT, CTYPE, DELIRY_DT, GSTATUS
		Messagebox("Search Non Distributed Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File")
Endcase
Endif
Return

