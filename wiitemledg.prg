**Collect Report for Item as per condition,One item or all item(colour)
SET DELETED ON
SET TALK OFF
SET SAFE OFF

Procedure ItemColl
SET ANSI ON
CREATE CURSOR ITEMLEDG (QUALITY C(12),COLOUR C(10),DATE D(8),RECQTY N(11,3),ISSQTY N(11,3),RETQTY N(11,3),BILLNO C(6),;
PARTY C(20),COMMENT C(30), OPENBAL N(10,3))

SELECT QUALITY,COLOUR,DATE,(QUANTITY) RECQTY,BILLNO,PARTY,COMMENT;
FROM Carpet!WIRECV;
WHERE &CONDITION .and. DATE=<m.enddt;
ORDER BY DATE;
INTO CURSOR REV1

SELECT QUALITY,COLOUR,DATE,(QUANTITY) ISSQTY,BILLNO,PARTY,COMMENT;
FROM Carpet!WIISSUE;
WHERE &CONDITION .and. Dyewht='D' .and. DATE=<m.enddt;
ORDER BY DATE;
INTO CURSOR ISS1

SELECT QUALITY,COLOUR,DATE,(QUANTITY) RETQTY,BILLNO,PARTY,COMMENT;
FROM Carpet!WIRETURN;
WHERE &CONDITION .and. Dyewht='D' .and. DATE=<m.enddt;
ORDER BY DATE;
INTO CURSOR RETN


Select Opendate as Date,Quality,Colour,Comment,Openbal;
From Wistock;
Into Cursor cWistk

SELECT ITEMLEDG
APPEND FIELDS DATE,QUALITY,COLOUR,COMMENT,OPENBAL FROM DBF('cWistk') FOR &CONDITION
APPEND FROM DBF('REV1')
APPEND FROM DBF('ISS1')
APPEND FROM DBF('RETN')

if !empty(m.Supplier)
	SELECT *;
	FROM ITEMLEDG;
	WHERE Party=m.Supplier;
	ORDER BY COLOUR,DATE;
	INTO CURSOR ITEMLEDG1
Else
	SELECT *;
	FROM ITEMLEDG;
	ORDER BY COLOUR,DATE;
	INTO CURSOR ITEMLEDG1
ENDIF
SET ANSI OFF
RETURN

Procedure ItemOne   &&One Quality, One Item (Colour)
***********Min Max Actual Date, Data Range in Report
Private msdate,medate
msdate=Date()
medate=m.enddt
Select Min(date) from  ITEMLEDG1 into cursor mindate
select mindate
msdate=mindate->min_date
Select max(date) from  ITEMLEDG1 into cursor maxdate
select maxdate
medate=maxdate->Max_date
*********************************************
Select ITEMLEDG1
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		SET COLOR TO
		Report form wiitemledg.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wiitemledg.frx to printer prompt noconsole
Endcase
Endif
RETURN

Procedure ItemAll   &&One Quality, All Item (Colur)
***********Min Max Actual Date, Data Range in Report
Private msdate,medate
msdate=Date()
medate=m.enddt
Select Min(date) from  ITEMLEDG1 into cursor mindate
select mindate
msdate=mindate->min_date
Select max(date) from  ITEMLEDG1 into cursor maxdate
select maxdate
medate=maxdate->Max_date
*********************************************
Select ITEMLEDG1
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		SET COLOR TO
		Report form wiitemAll.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wiitemAll.frx to printer prompt noconsole
Endcase
Endif
RETURN
