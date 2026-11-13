*Order Issue but not Received

Set Date to Briti
Set Century on
SET ANSI ON


* Public Variable for Carpet-Inventory Search Option !!
PUBLIC m.psWeaver, m.psDesign, m.psColour

**Initialization
STORE SPACE(100) TO m.psWeaver,m.psDesign,m.psColour
m.psWeaver = m.Text3 && variable in defined in tag form
m.psDesign = m.Text4
m.psColour = m.Text5

*WAIT WINDOW "Retrieving Records ... Please wait" NOWAIT
set procedure to catool
DO csTrimInfo9  
&& Trim Information for Check Purpose !

&&Issued condition from form rordiss.scx
&&condition='b.ol_no=s.ol_no .and. !empty(s.issdt)'  this is All Status Carpets having issdt

Open Database Carpet

	CREATE SQL VIEW temprepview1 AS SELECT b.DESIGN, b.COLOUR, b.SZCODE, b.BREADTH, b.LENGTH, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT,;
		 	 s.LOOMDT,b.QUALITY,s.FDATE,b.OL_NO;	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. s.issdt>=m.Text1 .and. s.issdt<=m.Text2;
	HAVING EMPTY(s.FDATE)

	CREATE SQL VIEW temprepview2 AS SELECT *;
	FROM Carpet!temprepview1;
	WHERE ccsMatch20(Weaver,Design,Colour)
	
	CREATE SQL VIEW temprepview AS SELECT temprepview2.*,sqmt as ssqmt;
	FROM Carpet!temprepview2;
	ORDER BY WEAVER,ISSDT ASC,SZCODE
	
USE temprepview shared  
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form ordiss.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form ordiss.frx to printer prompt noconsole
Endcase
Endif
Return