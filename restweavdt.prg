*Estimated Weaving On Time/ Late Report, Today Date - Est.Weave Date
SET PROCEDURE TO Catool
DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

Do Case
  Case m.allweave=.T.
	CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, s.WEAVER, s.CATEGORY, b.ORDER_TYPE, s.CARD_NO, b.QUALITY, b.DESIGN, b.COLOUR, b.SZCODE,;
			 b.SQMT, b.OL_NO, s.WEV_LAST_DT, s.WEV_DT, m.Text2-s.WEV_DT NODAY, b.PO_NO, b.CTRL_NO, b.WASHTYPE, b.CSTATUS; 
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.WEV_DT) .and. empty(FDATE)  ;  
	HAVING s.WEV_DT>=m.Text1 .and. s.WEV_DT<=m.Text2
	
  Case m.posweave=.T.  && we have -ve value adjusted on 17/03/2011 due to comment +VE MORE LATE, -VE FOR BEFORE
	CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, s.WEAVER, s.CATEGORY, b.ORDER_TYPE, s.CARD_NO, b.QUALITY, b.DESIGN, b.COLOUR, b.SZCODE,;
			 b.SQMT, b.OL_NO, s.WEV_LAST_DT, s.WEV_DT, m.Text2-s.WEV_DT NODAY, b.PO_NO, b.CTRL_NO, b.WASHTYPE, b.CSTATUS; 
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.WEV_DT) .and. empty(FDATE) ; 
	HAVING s.WEV_DT>=m.Text1 .and. s.WEV_DT<=m.Text2 .and. NODAY<0

 Case  m.negweave=.T. && we have +ve value adjusted on 17/03/2011 due to comment  +VE MORE LATE, -VE FOR BEFORE
	CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, s.WEAVER, s.CATEGORY, b.ORDER_TYPE, s.CARD_NO, b.QUALITY, b.DESIGN, b.COLOUR, b.SZCODE,;
			 b.SQMT, b.OL_NO, s.WEV_LAST_DT, s.WEV_DT, m.Text2-s.WEV_DT NODAY, b.PO_NO, b.CTRL_NO, b.WASHTYPE, b.CSTATUS; 
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.WEV_DT) .and. empty(FDATE) ;
	HAVING s.WEV_DT>=m.Text1 .and. s.WEV_DT<=m.Text2 .and. NODAY>=0
Endcase	

CREATE SQL VIEW temprepview AS SELECT *;
FROM Carpet!temprepview1;
WHERE ccsMatch4(Weaver) .and. ccsMatch7(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, WASHTYPE, CATEGORY);
ORDER BY BCODE,CATEGORY,WEAVER,WEV_LAST_DT,OL_NO ASC
	
USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form restWeavDt.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form restWeavDt.frx to printer prompt noconsole
Endcase
Endif
Return