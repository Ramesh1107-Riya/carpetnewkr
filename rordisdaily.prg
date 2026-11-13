*Order Issue All, Distri, Unfinish, finish, packed, exported.

*srchweaver.prg Finds records for particular or many weavers separated by ;

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

	CREATE SQL VIEW temprepview1 AS SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.BREADTH, b.LENGTH, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT,;
		 	 b.ORDER_TYPE, b.BCODE, b.SPCL_INST, b.FRINGES, b.WASHTYPE,s.GRADE,s.LOOMDT,b.QUALITY, b.CTRL_NO, b.CSTATUS;	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. s.issdt>=m.Text1 .and. s.issdt<=m.Text2;
	ORDER BY s.ISSDT,b.OL_NO ASC

	CREATE SQL VIEW temprepview AS SELECT *;
	FROM Carpet!temprepview1;
	WHERE ccsMatch20(Weaver,Design,Colour);
	ORDER BY ISSDT,OL_NO ASC
	
	
USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form ordisdaily.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form ordisdaily.frx to printer prompt noconsole
	Case  m.PrnStat="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS OL_NO,DESIGN,COLOUR,SZCODE,BREADTH,LENGTH,SQMT,QUALITY,WEAVER
		Messagebox("Daily Order Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
Endcase
Endif
Return