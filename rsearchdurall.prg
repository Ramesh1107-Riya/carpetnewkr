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
		s.CATEGORY,	s.WEAVER, b.NOTES, b.SQMT,s.ESTSHIP_DT,b.yrncaldt as DELIRY_DT,b.Po_Dt,b.Skuno,s.issdtwash,s.rcddtwash;
	FROM  Cabuyord b, Casupord s;
	WHERE b.ol_no = s.ol_no .and. cstatus!="Exported" .and. s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text10 .and. cstatus!="On-Loom";
	Into Cursor  temprepview1
ELSE && Search All including Exported Carpet Also
	SELECT b.BCODE, s.CARD_NO, s.CARPETNO, b.PO_NO, b.CTRL_NO, b.OL_NO, b.QUALITY, b.DESIGN, b.SZCODE, b.COLOUR, b.FIELDCODE, b.BREADTH, b.LENGTH,;
 		b.WASHTYPE, b.SPCL_INST, b.COMMENT, s.COMMENT QLTCOMMENT,  s.SUPPLIER, b.CSTATUS, b.ORDER_TYPE, b.CTYPE, s.LOOMDT, s.ISSDT, s.WEV_LAST_DT, s.FDATE,;
		s.CATEGORY,	s.WEAVER, b.NOTES, b.SQMT, s.ESTSHIP_DT,b.yrncaldt as DELIRY_DT,b.Po_Dt,b.Skuno,s.issdtwash,s.rcddtwash;
	FROM  Cabuyord b, Casupord s;
	WHERE b.ol_no = s.ol_no .and. s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text10 .and. cstatus!="On-Loom";
	Into Cursor  temprepview1
ENDIF

SELECT *;
FROM temprepview1;
WHERE ccsMatch3(BCODE,CARD_NO, CARPETNO, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, ;
	  SUPPLIER, WASHTYPE, SPCL_INST, COMMENT, QLTCOMMENT, CSTATUS,  LOOMDT, CTYPE, CATEGORY, WEAVER, NOTES, ESTSHIP_DT );
ORDER BY  SUPPLIER, OL_NO ASC;
Into Cursor temp4

Select BCODE,PO_NO,OL_NO,QUALITY,DESIGN,COLOUR,SZCODE,sqmt,po_dt,DELIRY_DT,issdt,issdt-po_dt as yrndurn,fdate,fdate-issdt as wevdurn,issdtwash,rcddtwash,;
		rcddtwash-issdtwash as washdurn,NOTES;
From Temp4;
Into Cursor CabuSup

Select i.Bcode,i.PO_NO,i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.SZCODE,i.sqmt,i.po_dt,i.DELIRY_DT,i.issdt,i.yrndurn,i.fdate,i.wevdurn,i.issdtwash,i.rcddtwash,i.washdurn,b.invno,i.Notes;
From CabuSup i;
Left Join Packtran b;
On i.ol_no=b.ol_no;
Into Cursor Temp3

Select i.Bcode,i.PO_NO,i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.SZCODE,i.sqmt,i.po_dt,i.DELIRY_DT,i.issdt,i.yrndurn,i.fdate,i.wevdurn,i.issdtwash,i.rcddtwash,i.washdurn,i.invno,b.invdt,b.invdt-i.rcddtwash as pkdur,b.invdt-i.DELIRY_DT as cuslate,i.Notes;
From Temp3 i;
Left Join Expackingnp b;
On i.invno=alltrim(b.invno);
Into Cursor temprepview1a

Select t.*,b.name;
From Temprepview1a t,Cabuyer b;
Where t.bcode=b.bcode;
Into Cursor temprepview 

Select temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form rsearchdurall.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form rsearchdurall.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS Bcode,name,PO_NO,OL_NO,QUALITY,DESIGN,COLOUR,SZCODE,sqmt,po_dt,DELIRY_DT,issdt,yrndurn,fdate,wevdurn,issdtwash,rcddtwash,washdurn,invno,invdt,Notes
		Messagebox("Search Production Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
Endcase
Endif
Return


