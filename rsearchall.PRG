SET DELETED ON
SET PROCEDURE TO Catool
SET TALK OFF
SET SAFE OFF
Set Date to Briti
Set Century off
SET ANSI ON


DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

IF m.DoNotSrchExp=.T. && exclude Exported Carpet
	SELECT b.BCODE, s.CARD_NO, s.CARPETNO, b.PO_NO, b.CTRL_NO, b.OL_NO, b.QUALITY, b.DESIGN, b.SZCODE, b.COLOUR, b.FIELDCODE, b.BREADTH, b.LENGTH,;
 		b.WASHTYPE, b.SPCL_INST, b.COMMENT, s.COMMENT QLTCOMMENT, s.SUPPLIER, b.CSTATUS, b.ORDER_TYPE, b.CTYPE, s.LOOMDT, s.ISSDT, s.WEV_LAST_DT, s.FDATE,;
		s.CATEGORY,	s.WEAVER, b.NOTES, b.SQMT,s.ESTSHIP_DT,s.CARPETWT,s.rate,s.amt;
	FROM  Cabuyord b, Casupord s;
	WHERE b.ol_no = s.ol_no .and. cstatus!="Exported" .and. s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text10;
	Into Cursor temprepview1
	
ELSE && Search All including Exported Carpet Also
	SELECT b.BCODE, s.CARD_NO, s.CARPETNO, b.PO_NO, b.CTRL_NO, b.OL_NO, b.QUALITY, b.DESIGN, b.SZCODE, b.COLOUR, b.FIELDCODE, b.BREADTH, b.LENGTH,;
 		b.WASHTYPE, b.SPCL_INST, b.COMMENT, s.COMMENT QLTCOMMENT,  s.SUPPLIER, b.CSTATUS, b.ORDER_TYPE, b.CTYPE, s.LOOMDT, s.ISSDT, s.WEV_LAST_DT, s.FDATE,;
		s.CATEGORY,	s.WEAVER, b.NOTES, b.SQMT, s.ESTSHIP_DT,s.CARPETWT,s.rate,s.amt;
	FROM  Cabuyord b, Casupord s;
	WHERE b.ol_no = s.ol_no .and. s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text10;
	Into Cursor temprepview1
ENDIF

SELECT *;
FROM temprepview1;
WHERE ccsMatch3(BCODE,CARD_NO, CARPETNO, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, ;
	  SUPPLIER, WASHTYPE, SPCL_INST, COMMENT, QLTCOMMENT, CSTATUS,  LOOMDT, CTYPE, CATEGORY, WEAVER, NOTES, ESTSHIP_DT );
ORDER BY  SUPPLIER, OL_NO ASC;
Into Cursor temprepview

**** For Company head Pema Rug or Kamal Rug on bill top**** 6/10/2021
Select k.compname;
From cabuyer i;
Join temprepview j;
On i.bcode=j.bcode;
Join packhead k;
On i.compcode=k.compcode;
Into Cursor billhead
Select billhead
pcname=billhead->compname
************************

Select temprepview 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form rsearchall.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form rsearchall.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS SUPPLIER,DESIGN, COLOUR, PO_NO, OL_NO, BREADTH, LENGTH, SQMT,RATE,AMT, QUALITY, ISSDT, LOOMDT, WEV_LAST_DT, FDATE, CSTATUS, CARPETNO,CARPETWT
		Messagebox("Search Production Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
Endcase
Endif
Return


