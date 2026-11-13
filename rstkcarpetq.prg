SET DELETED ON
SET PROCEDURE TO Catool
SET TALK OFF
SET SAFE OFF
Set Date to Briti
Set Century on
SET ANSI ON


DO csTrimInfos      && Trim Information for Check Purpose, for Stock !
Open Database Carpet
 IF m.DoNotSrchExp=.T.  && exclude Exported Carpet
	SELECT BCODE, CARD_NO, CARPETNO, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, FIELDCODE, BREADTH, LENGTH,;
 		WASHTYPE, SPCL_INST, CSTATUS, ORDER_TYPE, CTYPE, NOTES, YRPHY,SQMT,LOCATION,SL_NO,SKUNO,COMMENT;
 	FROM  Stkcarpet;
	WHERE cstatus!="Exported";
	Into cursor  temprepview1
ELSE && Search All including Exported Carpet Also
	SELECT BCODE, CARD_NO, CARPETNO, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, FIELDCODE, BREADTH, LENGTH,;
		WASHTYPE, SPCL_INST, CSTATUS, ORDER_TYPE, CTYPE, NOTES, YRPHY,SQMT,LOCATION,SL_NO,SKUNO,COMMENT;
 	FROM  Stkcarpet;
	Into cursor  temprepview1 
ENDIF


SELECT *;
FROM temprepview1;
WHERE ccsMatch11(BCODE,CARD_NO, CARPETNO, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, ;
	  WASHTYPE, SPCL_INST, CSTATUS, CTYPE, NOTES, YRPHY,LOCATION,SL_NO);
ORDER BY CARPETNO ASC;
Into cursor  temprepview 

*1)BCODE,PO_NO,QUALITY Old Stok Summary (rstcarpetq.prg), Qualitywise summary
	SELECT s.BCODE,alltrim(b.NAME) as Name, PO_NO,QUALITY, sum(SQMT) as SQMT,count(ol_no) as pcs;
 	FROM temprepview s;
 	LEFT JOIN Cabuyer b;
 	ON s.BCODE=b.BCODE;
	WHERE cstatus<>'Exported';
	Order by s.BCODE,po_no,QUALITY;
	Group by s.BCODE,po_no,QUALITY;
	Into cursor  temprepviewf

Select temprepviewf 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form rstkcarpetq.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form rstkcarpetq.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,NAME,PO_NO,QUALITY,SQMT,PCS 
		Messagebox("Search Stock Carpet Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Case  m.PrnStat="V" .and. m.Option="C" && Viw Edit
		DO VIEWEDIT
	Endcase
Endif
Return

