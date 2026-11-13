***rstkboth.prg
SET DELETED ON
SET PROCEDURE TO Catool
SET TALK OFF
SET SAFE OFF
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo     && Trim Information for Check Purpose, for Stock !
Open Database Carpet
 IF m.DoNotSrchExp=.T.  && exclude Exported Carpet
		SELECT BCODE, CARPETNO, PO_NO, PO_DT, CTRL_NO, OL_NO, DESIGN,QUALITY,SUBSTR(COLOUR,1,10) AS COLOUR,SZCODE,BREADTH,LENGTH,SQMT, SPCL_INST, CSTATUS,SUBSTR(NOTES,1,40) AS NOTES,SKUNO,ORDER_TYPE, FIELDCODE, WASHTYPE,CTYPE,COMMENT,SCODE;
		FROM  Stkcarpet;
		WHERE cstatus<>"Exported" .and. ccsMatch4A(WASHTYPE);
		UNION ALL;
		SELECT b.BCODE,s.CARPETNO,b.PO_NO,b.PO_DT,b.CTRL_NO, b.OL_NO,b.DESIGN,QUALITY,COLOUR,b.SZCODE,b.BREADTH,b.LENGTH,b.SQMT,b.SPCL_INST,b.CSTATUS,b.NOTES,b.SKUNO,b.ORDER_TYPE,b.FIELDCODE,b.WASHTYPE,b.CTYPE,b.COMMENT,b.SCODE;
		FROM  Cabuyord b;
		Inner Join Casupord s;
		On b.ol_no=s.ol_no;
		WHERE b.cstatus<>"Exported" .and. !empty(fdate) .and. ccsMatch4A(WASHTYPE);
		Into cursor  temprepview1 
ELSE && Search All including Exported Carpet Also
		SELECT BCODE, CARPETNO, PO_NO, PO_DT, CTRL_NO, OL_NO, DESIGN,QUALITY,SUBSTR(COLOUR,1,10) AS COLOUR,SZCODE,BREADTH,LENGTH,SQMT, SPCL_INST, CSTATUS,SUBSTR(NOTES,1,40) AS NOTES,SKUNO,ORDER_TYPE, FIELDCODE, WASHTYPE,CTYPE,COMMENT,SCODE;
		FROM  Stkcarpet;
		WHERE ccsMatch4A(WASHTYPE);		
		UNION ALL;
		SELECT b.BCODE,s.CARPETNO,b.PO_NO,b.PO_DT,b.CTRL_NO, b.OL_NO,b.DESIGN,QUALITY,COLOUR,b.SZCODE,b.BREADTH,b.LENGTH,b.SQMT,b.SPCL_INST,b.CSTATUS,b.NOTES,b.SKUNO,b.ORDER_TYPE,b.FIELDCODE,b.WASHTYPE,b.CTYPE,b.COMMENT,b.SCODE;
		FROM  Cabuyord b;
		Inner Join Casupord s;
		On b.ol_no=s.ol_no;
		WHERE !empty(fdate) .AND. ccsMatch4A(WASHTYPE);
		Into cursor  temprepview1 
ENDIF

SELECT *;
FROM temprepview1;
WHERE ccsMatch6B(BCODE,CARPETNO,PO_NO,CTRL_NO,OL_NO,QUALITY,DESIGN,SZCODE,COLOUR,SPCL_INST,CSTATUS,NOTES);
ORDER BY CARPETNO ASC;
Into cursor  temprepview 

Select temprepview  
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form rstkboth.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form rstkboth.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		?SYS(5)+CURDIR()
		CD EXCELFILES			
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,CARPETNO,PO_NO,CTRL_NO,QUALITY,DESIGN,COLOUR,SZCODE,BREADTH,LENGTH,SQMT,CSTATUS,NOTES,COMMENT,SPCL_INST,SKUNO,SCODE,WASHTYPE
		Messagebox("Search Stock Carpet Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
		CD..
	Endcase
Endif
Return