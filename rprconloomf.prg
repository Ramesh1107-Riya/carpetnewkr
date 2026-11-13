*RepPrcOnLoomf.prg Production Forecast with Loom Date
*srchweaver.prg Finds records for particular or many weavers separated by ;

SET PROCEDURE TO Catool
Set Date to Briti
Set Century on
SET ANSI ON

* Public Variable for Carpet-Inventory Search Option !!
PUBLIC m.psWeaver

**Initialization
STORE SPACE(150) TO m.psWeaver
m.psWeaver = m.Text3 && variable in defined in tag form

*WAIT WINDOW "Retrieving Records ... Please wait" NOWAIT

DO csTrimInfo2  

    && Trim Information for Check Purpose !
Open Database Carpet
Do Case
Case (!empty(m.bcode) .and. !empty(m.Text3))  
	CREATE SQL VIEW temprepview1 AS SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT WEV_LAST_DT,;
		 	 b.ORDER_TYPE, b.BCODE, b.SPCL_INST, b.FRINGES, b.WASHTYPE,s.GRADE,s.LOOMDT,b.LENGTH,s.WEV_CM,(b.LENGTH-s.WEV_CM)*(s.WEV_CMDT-s.LOOMDT)/s.WEV_CM DAYREQ,;
		 	 m.Text2+(b.LENGTH-s.WEV_CM)*(s.WEV_CMDT-s.LOOMDT)/s.WEV_CM-s.WEV_LAST_DT BAWLDT ;	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.loomdt) .and. empty(s.Fdate) .and. b.bcode=m.bcode .and. !empty(s.WEV_CMDT);
	HAVING s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text2 .and. s.LOOMDT<m.text2 .and. DAYREQ<=m.Text4;
    ORDER BY s.Weaver,s.ISSDT,b.OL_NO ASC
 
	CREATE SQL VIEW temprepview AS SELECT *;
	FROM Carpet!temprepview1;
	WHERE ccsMatch4(Weaver) &Condition;
	ORDER BY Weaver,ISSDT,OL_NO ASC
	
Case !empty(m.bcode) .and. empty(m.Text3)	
	CREATE SQL VIEW temprepview1 AS SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT WEV_LAST_DT,;
		 	 b.ORDER_TYPE, b.BCODE, b.SPCL_INST, b.FRINGES, b.WASHTYPE,s.GRADE,s.LOOMDT,b.LENGTH,s.WEV_CM,(b.LENGTH-s.WEV_CM)*(s.WEV_CMDT-s.LOOMDT)/s.WEV_CM DAYREQ,;
		 	 m.Text2+(b.LENGTH-s.WEV_CM)*(s.WEV_CMDT-s.LOOMDT)/s.WEV_CM-s.WEV_LAST_DT BAWLDT ;	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.loomdt) .and. empty(s.Fdate) .and. b.bcode=m.bcode .and. !empty(s.WEV_CMDT) &Condition;
	HAVING s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text2 .and. s.LOOMDT<m.text2 .and. DAYREQ<=m.Text4;
    ORDER BY s.Weaver,s.ISSDT,b.OL_NO ASC

Case empty(m.bcode) .and. !empty(m.Text3)
	CREATE SQL VIEW temprepview1 AS SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT WEV_LAST_DT,;
		 	 b.ORDER_TYPE, b.BCODE, b.SPCL_INST, b.FRINGES, b.WASHTYPE,s.GRADE,s.LOOMDT, b.LENGTH,s.WEV_CM,(b.LENGTH-s.WEV_CM)*(s.WEV_CMDT-s.LOOMDT)/s.WEV_CM DAYREQ,;
		 	 m.Text2+(b.LENGTH-s.WEV_CM)*(s.WEV_CMDT-s.LOOMDT)/s.WEV_CM-s.WEV_LAST_DT BAWLDT ;	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.loomdt) .and. empty(s.Fdate) .and. !empty(s.WEV_CMDT) &Condition;
	HAVING s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text2 .and. DAYREQ<=m.Text4;
    ORDER BY s.Weaver,s.ISSDT,b.OL_NO ASC

	CREATE SQL VIEW temprepview AS SELECT *;
	FROM Carpet!temprepview1;
	WHERE ccsMatch4(Weaver) &Condition;
	ORDER BY Weaver,ISSDT,OL_NO ASC
Case empty(m.bcode) .and. empty(m.Text3)
	CREATE SQL VIEW temprepview AS SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT WEV_LAST_DT,;
		 	 b.ORDER_TYPE, b.BCODE, b.SPCL_INST, b.FRINGES, b.WASHTYPE,s.GRADE,s.LOOMDT, b.LENGTH,s.WEV_CM,(b.LENGTH-s.WEV_CM)*(s.WEV_CMDT-s.LOOMDT)/s.WEV_CM DAYREQ,;
		 	 m.Text2+(b.LENGTH-s.WEV_CM)*(s.WEV_CMDT-s.LOOMDT)/s.WEV_CM-s.WEV_LAST_DT BAWLDT ;	 	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.loomdt) .and. empty(s.Fdate) .and. !empty(s.WEV_CMDT) &Condition; 
	HAVING s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text2 .and. DAYREQ<=m.Text4;
    ORDER BY s.Weaver,s.ISSDT,b.OL_NO ASC
Endcase

USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else

Do Case
	Case m.PrnStat="V"
		Report form prconloomf.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prconloomf.frx to printer prompt noconsole
Endcase
Endif
Return