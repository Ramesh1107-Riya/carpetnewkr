*Supplier Weaving Order in Hand
SET PROCEDURE TO Catool
Open Database Carpet
DO csTrimInfo      && Trim Information for Check Purpose !
	*Supplier Weaving Order in Hand
	CREATE SQL VIEW temprepview1 AS SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT,;
		 	 b.ORDER_TYPE, b.BCODE, b.SPCL_INST, b.FRINGES, b.WASHTYPE,s.GRADE,s.LOOMDT,b.QUALITY, b.CTRL_NO,s.CATEGORY,m.Text2-s.WEV_LAST_DT NODAY,s.WEV_DT;	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.ISSDT) .and. empty(s.fdate) ;
	HAVING s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text2
	
	
	CREATE SQL VIEW temprepview AS SELECT *;
	FROM Carpet!temprepview1;
	WHERE ccsMatch4(Weaver) .and. ccsMatch7(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, WASHTYPE, CATEGORY); 
	ORDER BY WEV_LAST_DT,OL_NO ASC
	
	*	HAVING NODAY>=m.Text4
 && We Extend the Weaving Date by giving No. of Day some value

USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prcordhndi.frx  PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcordhndi.frx to printer prompt noconsole
Endcase
Endif
Return