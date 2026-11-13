*Supplier Order - Loom On Time (Detail)
SET PROCEDURE TO Catool
Open Database Carpet
DO csTrimInfo      && Trim Information for Check Purpose !
SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT,b.Notes,b.yrncaldt as buydelidt,b.po_dt,;
 	 b.ORDER_TYPE, b.BCODE, b.SPCL_INST, b.FRINGES, b.WASHTYPE,s.GRADE,s.LOOMDT,b.QUALITY, b.CTRL_NO,s.CATEGORY,(s.WEV_LAST_DT-Date()) NODAY,s.WEV_DT;	
FROM  Cabuyord b, Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.ISSDT) .and. !empty(s.Loomdt).and. empty(fdate) .and. s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text2;
Having s.WEV_LAST_DT-Date()>=0;
Into Cursor temprepview1
	
SELECT t.*,c.Name;
FROM temprepview1 t;
Join Cabuyer c;
On c.bcode=t.bcode;
WHERE ccsMatch4(Weaver) .and. ccsMatch7(t.BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, t.WASHTYPE, CATEGORY) .and. noday<=m.text4;
ORDER BY Weaver,NODAY Desc;
Into Cursor temprep7
		
Select temprep7
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prcordhontime.frx  PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcordhontime.frx to printer prompt noconsole
Endcase
Endif
Return