**Report made for Packing
SET DELETED ON
Set Date to Briti
Set Century off
SET SAFE OFF
SET TALK OFF
SET ANSI ON

SET PROCEDURE TO Catool
DO csTrimInfo      && Trim Information for Check Purpose !
*Open Database Carpet shared
IF m.DoNotSrchExp=.T.  && exclude Exported Carpet
		SELECT BCODE, CARPETNO, PO_NO, PO_DT, CTRL_NO, OL_NO, DESIGN,QUALITY,SUBSTR(COLOUR,1,10) AS COLOUR,SZCODE,BREADTH,LENGTH,SQMT, SPCL_INST, CSTATUS,SUBSTR(NOTES,1,40) AS NOTES,SKUNO,ORDER_TYPE, FIELDCODE, WASHTYPE,CTYPE,COMMENT,YRNCALDT as DELIRY_DT;
		FROM  Stkcarpet;
		WHERE cstatus<>"Exported";
		UNION ALL;
		SELECT b.BCODE,s.CARPETNO,b.PO_NO,b.PO_DT,b.CTRL_NO, b.OL_NO,b.DESIGN,QUALITY,COLOUR,b.SZCODE,b.BREADTH,b.LENGTH,b.SQMT,b.SPCL_INST,b.CSTATUS,b.NOTES,b.SKUNO,b.ORDER_TYPE,b.FIELDCODE,b.WASHTYPE,b.CTYPE,b.COMMENT,YRNCALDT as DELIRY_DT;
		FROM  Cabuyord b;
		Inner Join Casupord s;
		On b.ol_no=s.ol_no;
		WHERE b.cstatus<>"Exported"  .and. !empty(s.fdate);
		Into cursor  temprepview1 
ELSE && Search All including Exported Carpet Also
		SELECT BCODE, CARPETNO, PO_NO, PO_DT, CTRL_NO, OL_NO, DESIGN,QUALITY,SUBSTR(COLOUR,1,10) AS COLOUR,SZCODE,BREADTH,LENGTH,SQMT, SPCL_INST, CSTATUS,SUBSTR(NOTES,1,40) AS NOTES,SKUNO,ORDER_TYPE, FIELDCODE, WASHTYPE,CTYPE,COMMENT,YRNCALDT as DELIRY_DT;
		FROM  Stkcarpet;
		UNION ALL;
		SELECT b.BCODE,s.CARPETNO,b.PO_NO,b.PO_DT,b.CTRL_NO, b.OL_NO,b.DESIGN,QUALITY,COLOUR,b.SZCODE,b.BREADTH,b.LENGTH,b.SQMT,b.SPCL_INST,b.CSTATUS,b.NOTES,b.SKUNO,b.ORDER_TYPE,b.FIELDCODE,b.WASHTYPE,b.CTYPE,b.COMMENT,YRNCALDT as DELIRY_DT;
		FROM  Cabuyord b;
		Inner Join Casupord s;
		On b.ol_no=s.ol_no;
		WHERE !empty(s.fdate);
		Into cursor  temprepview1 
ENDIF

SELECT *;
FROM temprepview1;
WHERE ccsMatch12(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, WASHTYPE, SPCL_INST, CSTATUS, CTYPE, NOTES);
ORDER BY PO_NO,Design,Notes,Sqmt;
Into Cursor temprepview 

Select temprepview 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
	Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form rbuyordpk-2.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form rbuyordpk-2.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,PO_NO,CTRL_NO,OL_NO,CARPETNO,DESIGN,COLOUR,QUALITY,BREADTH,LENGTH,SQMT,CSTATUS,SPCL_INST,NOTES,PO_DT,DELIRY_DT,SKUNO,COMMENT,WASHTYPE
		Messagebox("Search Buyer Order Carpet Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Endcase
Endif
Return
