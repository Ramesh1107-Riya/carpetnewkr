*CUSTOM STATUS *RPRCSTAT.PRG PRC Report
Open Database Carpet share
DO CASE
CASE empty(m.BCODE) .and. !empty(m.ORDER_TYPE)
	CREATE SQL VIEW temprepview AS SELECT b.PO_NO, b.OL_NO,  b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, s.CARD_NO, s.WEAVER, b.PO_DT, b.DELIRY_DT, ;
					s.ISSDT, s.WEV_LAST_DT, b.ORDER_TYPE, s.WEV_DT, s.WEV_CM ;
	FROM Carpet!Cabuyord b, Carpet!Casupord s;
	Where b.ol_no=s.ol_no .and. b.ORDER_TYPE=alltrim(m.ORDER_TYPE) .and. !empty(s.ISSDT) .and. empty(s.FDATE);
	ORDER BY s.weaver,b.PO_NO, b.ol_no

CASE !empty(m.BCODE) .and. !empty(m.ORDER_TYPE) 
	CREATE SQL VIEW temprepview AS SELECT b.PO_NO, b.OL_NO,  b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, s.CARD_NO, s.WEAVER, b.PO_DT, b.DELIRY_DT, ;
					s.ISSDT, s.WEV_LAST_DT, b.ORDER_TYPE, s.WEV_DT, s.WEV_CM ;
	FROM Carpet!Cabuyord b, Carpet!Casupord s;
	Where b.ol_no=s.ol_no .and. b.ORDER_TYPE=alltrim(m.ORDER_TYPE) .and. !empty(s.ISSDT) .and. empty(s.FDATE) .and. b.BCODE=m.BCODE;
	ORDER BY s.weaver,b.PO_NO, b.ol_no

CASE !empty(m.BCODE) .and. empty(m.ORDER_TYPE) 
	CREATE SQL VIEW temprepview AS SELECT b.PO_NO, b.OL_NO,  b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, s.CARD_NO, s.WEAVER, b.PO_DT, b.DELIRY_DT, ;
					s.ISSDT, s.WEV_LAST_DT, b.ORDER_TYPE, s.WEV_DT, s.WEV_CM ;
	FROM Carpet!Cabuyord b, Carpet!Casupord s;
	Where b.ol_no=s.ol_no .and. !empty(s.ISSDT) .and. empty(s.FDATE) .and. b.BCODE=m.BCODE;
	ORDER BY s.weaver,b.PO_NO, b.ol_no

CASE empty(m.BCODE) .and. empty(m.ORDER_TYPE) 
	CREATE SQL VIEW temprepview AS SELECT b.PO_NO, b.OL_NO,  b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, s.CARD_NO, s.WEAVER, b.PO_DT, b.DELIRY_DT, ;
					s.ISSDT, s.WEV_LAST_DT, b.ORDER_TYPE, s.WEV_DT, s.WEV_CM ;
	FROM Carpet!Cabuyord b, Carpet!Casupord s;
	Where b.ol_no=s.ol_no .and. !empty(s.ISSDT) .and. empty(s.FDATE);
	ORDER BY s.weaver,b.PO_NO, b.ol_no

ENDCASE 

USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prcstat.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcstat.frx to printer prompt noconsole
Endcase
Endif
Return