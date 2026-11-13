*PRC Weaving On Time/ Late Report, From Weave Last date,LATE ONLOOM Report, after supplier supplies the carpet 
SET PROCEDURE TO Catool
 
DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

Do Case
  Case m.allweave=.T.
	CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, s.WEAVER, s.CATEGORY, b.ORDER_TYPE, s.CARD_NO, b.QUALITY, b.DESIGN, b.COLOUR, b.SZCODE,;
			 s.FINSQMT, b.OL_NO, s.WEV_LAST_DT, s.FDATE, s.FDATE-s.WEV_LAST_DT NODAY, b.PO_NO, b.CTRL_NO, b.WASHTYPE; 
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.FDATE);  
	HAVING s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2
	
  Case m.posweave=.T.  && we have -ve value adjusted on 17/03/2011 due to comment
	CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, s.WEAVER, s.CATEGORY, b.ORDER_TYPE, s.CARD_NO, b.QUALITY, b.DESIGN, b.COLOUR, b.SZCODE,;
			 s.FINSQMT, b.OL_NO, s.WEV_LAST_DT, s.FDATE, s.FDATE-s.WEV_LAST_DT NODAY, b.PO_NO, b.CTRL_NO, b.WASHTYPE; 
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.FDATE);  
	HAVING s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2 .and. NODAY<0

 Case  m.negweave=.T. && we have +ve value adjusted on 17/03/2011 due to comment
	CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, s.WEAVER, s.CATEGORY, b.ORDER_TYPE, s.CARD_NO, b.QUALITY, b.DESIGN, b.COLOUR, b.SZCODE,;
			 s.FINSQMT, b.OL_NO, s.WEV_LAST_DT, s.FDATE, s.FDATE-s.WEV_LAST_DT NODAY, b.PO_NO, b.CTRL_NO, b.WASHTYPE; 
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.FDATE);  
	HAVING s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2 .and. NODAY>=0
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
		Report form prcweaving.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcweaving.frx to printer prompt noconsole
Endcase
Endif
Return