*srchweaver.prg Finds records for particular or many weavers separated by ;

Set Date to Briti
Set Century on
SET ANSI ON


* Public Variable for Carpet-Inventory Search Option !!
PUBLIC m.psWeaver

**Initialization
STORE SPACE(150) TO m.psWeaver
m.psWeaver = m.Text3 && variable in defined in tag form

*WAIT WINDOW "Retrieving Records ... Please wait" NOWAIT
set procedure to catool
DO csTrimInfo2  
&& Trim Information for Check Purpose !

&&Issued condition from form rordiss.scx
&&condition='b.ol_no=s.ol_no .and. !empty(s.issdt) .and. empty(s.loomdt)'  this is Distri Carpets not started

Open Database Carpet

	CREATE SQL VIEW temprepview1 AS SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.BREADTH, b.LENGTH, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT,;
		 	 b.ORDER_TYPE, b.BCODE, b.SPCL_INST, b.FRINGES, b.WASHTYPE,s.GRADE,s.LOOMDT,b.QUALITY, b.CTRL_NO, b.CSTATUS;	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE &condition;
	HAVING s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text2;
    ORDER BY s.ISSDT,b.OL_NO ASC

	CREATE SQL VIEW temprepview AS SELECT *;
	FROM Carpet!temprepview1;
	WHERE ccsMatch4(Weaver);
	ORDER BY ISSDT,OL_NO ASC

Use temprepview share
RETURN

**************

