**Delivery Late Summary/Empty Report
**Group by PO_NO
SET DELETED ON
Set Date to Briti
Set Century off
SET SAFE OFF
SET TALK OFF
SET ANSI ON

SET PROCEDURE TO Catool
DO csTrimInfo      && Trim Information for Check Purpose !
*Open Database Carpet shared
Do Case
	Case m.OptRep='LS' &&Late Summary Report
		IF m.DoNotSrchExp=.T. && exclude Exported Carpet
			SELECT b.BCODE, b.PO_NO, b.CTRL_NO, b.OL_NO, b.QUALITY, b.DESIGN, b.SZCODE, b.COLOUR, b.SPCL_INST, b.CSTATUS, b.NOTES,sum(b.SQMT) SQMT, b.PO_DT, b.yrncaldt as DELIRY_DT, b.SKUNO,;
			 		b.FIELDCODE,b.ORDER_TYPE,b.CTYPE, b.WASHTYPE,s.CARPETNO, s.SUPPLIER, s.CUTDATE, s.ISSDT, s.WEV_LAST_DT, s.WEV_CM, s.WEV_CMDT,s.FDATE,s.ISSDTWASH, s.RCDDTWASH,m.Text10-b.yrncaldt as NODAY,;
			 		b.BREADTH,b.LENGTH,b.COMMENT,sum(b.QTY) Qty;
			FROM  Cabuyord b;
			LEFT OUTER JOIN Casupord s;
			ON b.OL_NO=s.OL_NO;
			WHERE b.cstatus<>"Exported" .and.  yrncaldt>=m.Text1 .and. yrncaldt<=m.Text10 .and. !empty(yrncaldt);
			Group by PO_No,yrncaldt;
			Order by b.bcode,yrncaldt;
			Into Cursor temprepview1 
		ELSE && Search All including Exported Carpet Also
			SELECT b.BCODE, b.PO_NO, b.CTRL_NO, b.OL_NO, b.QUALITY, b.DESIGN, b.SZCODE, b.COLOUR, b.SPCL_INST, b.CSTATUS, b.NOTES,sum(b.SQMT) SQMT, b.PO_DT, b.yrncaldt as DELIRY_DT, b.SKUNO,;
			 		b.FIELDCODE,b.ORDER_TYPE,b.CTYPE, b.WASHTYPE,s.CARPETNO, s.SUPPLIER, s.CUTDATE, s.ISSDT, s.WEV_LAST_DT, s.WEV_CM, s.WEV_CMDT,s.FDATE,s.ISSDTWASH, s.RCDDTWASH,m.Text10-b.yrncaldt as NODAY,;
			 		b.BREADTH,b.LENGTH,b.COMMENT,SUM(b.QTY) QTY;
			FROM  Cabuyord b;
			LEFT OUTER JOIN Casupord s;
			ON b.OL_NO=s.OL_NO;
			WHERE b.cstatus="Exported" .and.  yrncaldt>=m.Text1 .and. yrncaldt<=m.Text10 .and. !empty(yrncaldt);
			Group by PO_No,yrncaldt;
			Order by b.bcode,yrncaldt;
			Into Cursor temprepview1 
		ENDIF
	Case m.OptRep='ES' &&Empty Summary Report
		IF m.DoNotSrchExp=.T. && exclude Exported Carpet
			SELECT b.BCODE, b.PO_NO, b.CTRL_NO, b.OL_NO, b.QUALITY, b.DESIGN, b.SZCODE, b.COLOUR, b.SPCL_INST, b.CSTATUS, b.NOTES,sum(b.SQMT) SQMT, b.PO_DT, b.yrncaldt as DELIRY_DT, b.SKUNO,;
			 		b.FIELDCODE,b.ORDER_TYPE,b.CTYPE, b.WASHTYPE,s.CARPETNO, s.SUPPLIER, s.CUTDATE, s.ISSDT, s.WEV_LAST_DT, s.WEV_CM, s.WEV_CMDT,s.FDATE,s.ISSDTWASH, s.RCDDTWASH,m.Text10-b.yrncaldt as NODAY,;
			 		b.BREADTH,b.LENGTH,b.COMMENT,sum(b.QTY) Qty;
			FROM  Cabuyord b;
			LEFT OUTER JOIN Casupord s;
			ON b.OL_NO=s.OL_NO;
			WHERE b.cstatus<>"Exported" .and. yrncaldt>=m.Text1 .and. yrncaldt<=m.Text10 .and. empty(yrncaldt);
			Group by PO_No,yrncaldt;
			Order by b.bcode,yrncaldt;
			Into Cursor temprepview1 
		ELSE && Search All including Exported Carpet Also
			SELECT b.BCODE, b.PO_NO, b.CTRL_NO, b.OL_NO, b.QUALITY, b.DESIGN, b.SZCODE, b.COLOUR, b.SPCL_INST, b.CSTATUS, b.NOTES,sum(b.SQMT) SQMT, b.PO_DT, b.yrncaldt as DELIRY_DT, b.SKUNO,;
			 		b.FIELDCODE,b.ORDER_TYPE,b.CTYPE, b.WASHTYPE,s.CARPETNO, s.SUPPLIER, s.CUTDATE, s.ISSDT, s.WEV_LAST_DT, s.WEV_CM, s.WEV_CMDT,s.FDATE,s.ISSDTWASH, s.RCDDTWASH,m.Text10-b.yrncaldt as NODAY,;
			 		b.BREADTH,b.LENGTH,b.COMMENT,SUM(b.QTY) QTY;
			FROM  Cabuyord b;
			LEFT OUTER JOIN Casupord s;
			ON b.OL_NO=s.OL_NO;
			WHERE b.cstatus="Exported" .and.  yrncaldt>=m.Text1 .and. yrncaldt<=m.Text10 .and. empty(yrncaldt);
			Group by PO_No,yrncaldt;
			Order by b.bcode,yrncaldt;
			Into Cursor temprepview1 
		ENDIF
	ENDCASE
SELECT *;
FROM temprepview1;
WHERE ccsMatch12(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, WASHTYPE, SPCL_INST, CSTATUS, CTYPE, NOTES);
ORDER BY PO_NO;
Into Cursor temprepview1a

Select t.*,b.name;
From Temprepview1a t,Cabuyer b;
Where t.bcode=b.bcode;
Order by PO_NO;
Into Cursor temprepview 

Select temprepview 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
	Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form rbuyordelspo.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form rbuyordelspo.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,PO_NO,CTRL_NO,OL_NO,CARPETNO,DESIGN,COLOUR,QUALITY,BREADTH,LENGTH,SQMT,CSTATUS,SPCL_INST,NOTES,PO_DT,DELIRY_DT,SKUNO,COMMENT,;
	 		FIELDCODE,SUPPLIER,CUTDATE,ISSDT,WEV_LAST_DT,WEV_CM,WEV_CMDT,FDATE,ISSDTWASH,RCDDTWASH,WASHTYPE,NAME
		Messagebox("Search Buyer Order Carpet Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Endcase
Endif
Return
