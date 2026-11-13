* Export Delivery On Time/ Late Report, 
SET PROCEDURE TO Catool
DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

Do Case
  Case m.allweave=.T.
	SELECT b.BCODE, s.WEAVER, s.CATEGORY, b.ORDER_TYPE, s.CARD_NO, b.QUALITY, b.DESIGN, b.COLOUR, b.SZCODE, p.INVNO,;
			 p.SQMT, b.OL_NO, s.FDATE, b.DELIRY_DT, p.EXPDT, b.DELIRY_DT-p.EXPDT NODAY, b.PO_NO, b.CTRL_NO, b.WASHTYPE, p.SHIPBRTH, p.SHIPLNGTH, s.ISSDT  ; 
	FROM  Carpet!Cabuyord b, Carpet!Casupord s, Carpet!Packtran p ;
	WHERE b.ol_no=s.ol_no .and. s.ol_no=p.ol_no .and. !empty(p.EXPDT) .AND.  b.DELIRY_DT>=m.Text1 .and. b.DELIRY_DT<=m.Text2;
	INTO CURSOR temprepview1 
  Case m.negweave=.T.
	SELECT b.BCODE, s.WEAVER, s.CATEGORY, b.ORDER_TYPE, s.CARD_NO, b.QUALITY, b.DESIGN, b.COLOUR, b.SZCODE, p.INVNO,;
			 p.SQMT, b.OL_NO, s.FDATE, b.DELIRY_DT, p.EXPDT, b.DELIRY_DT-p.EXPDT NODAY, b.PO_NO, b.CTRL_NO, b.WASHTYPE, p.SHIPBRTH, p.SHIPLNGTH, s.ISSDT  ; 
	FROM  Carpet!Cabuyord b, Carpet!Casupord s, Carpet!Packtran p ;
	WHERE b.ol_no=s.ol_no .and. s.ol_no=p.ol_no .and. !empty(p.EXPDT) .and. b.DELIRY_DT>=m.Text1 .and. b.DELIRY_DT<=m.Text2 .and. NODAY<0;
	INTO CURSOR temprepview1
 Case m.posweave=.T.
	SELECT b.BCODE, s.WEAVER, s.CATEGORY, b.ORDER_TYPE, s.CARD_NO, b.QUALITY, b.DESIGN, b.COLOUR, b.SZCODE, p.INVNO,;
			 p.SQMT, b.OL_NO, s.FDATE, b.DELIRY_DT, p.EXPDT, b.DELIRY_DT-p.EXPDT NODAY, b.PO_NO, b.CTRL_NO, b.WASHTYPE, p.SHIPBRTH, p.SHIPLNGTH, s.ISSDT  ; 
	FROM  Carpet!Cabuyord b, Carpet!Casupord s, Carpet!Packtran p ;
	WHERE b.ol_no=s.ol_no .and. s.ol_no=p.ol_no .and. !empty(p.EXPDT) .and. b.DELIRY_DT>=m.Text1 .and. b.DELIRY_DT<=m.Text2 .and. NODAY>=0;
	INTO CURSOR temprepview1
Endcase	

	SELECT *;
	FROM Carpet!temprepview1;
	WHERE ccsMatch4(Weaver) .and. ccsMatch7(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, WASHTYPE, CATEGORY);
	ORDER BY BCODE,WEAVER,DELIRY_DT,OL_NO ASC;
	INTO CURSOR temprepview 
	
SELECT temprepview 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form rExDelExp.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form rExDelExp.frx to printer prompt noconsole
Endcase
Endif
Return