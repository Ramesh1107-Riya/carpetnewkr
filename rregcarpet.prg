SET DELETED ON
SET PROCEDURE TO Catool
SET TALK OFF
SET SAFE OFF
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfos  && Trim Information for Check Purpose, for Stock !
Open Database Carpet
IF m.DoNotSrchExp=.T.  && exclude Exported Carpet and also On-Loom, Distri
	CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, s.CARD_NO, s.CARPETNO, b.PO_NO, b.CTRL_NO, b.OL_NO, b.QUALITY, b.DESIGN, b.SZCODE, b.COLOUR, b.FIELDCODE, b.BREADTH, b.LENGTH,;
 		b.WASHTYPE, b.SPCL_INST, b.CSTATUS, b.ORDER_TYPE, b.CTYPE, b.NOTES, s.YRPHY,  b.SQMT, s.FDATE;
 	FROM  Cabuyord b, Casupord s;
	WHERE b.ol_no = s.ol_no .and. !EMPTY(s.FDATE) .AND. b.EXPORTED <> .T.
ELSE && Search All including Exported Carpet Also
	CREATE SQL VIEW temprepview1 AS SELECT  b.BCODE, s.CARD_NO,  s.CARPETNO, b.PO_NO, b.CTRL_NO, b.OL_NO, b.QUALITY, b.DESIGN, b.SZCODE, b.COLOUR, b.FIELDCODE, b.BREADTH, b.LENGTH,;
 		b.WASHTYPE, b.SPCL_INST, b.CSTATUS, b.ORDER_TYPE, b.CTYPE, b.NOTES, s.YRPHY,  b.SQMT, s.FDATE;
 	FROM  Cabuyord b, Casupord s;
 	WHERE b.ol_no = s.ol_no .and. !EMPTY(s.FDATE)
ENDIF


CREATE SQL VIEW temprepview AS SELECT *;
FROM Carpet!temprepview1;
WHERE ccsMatch11(BCODE,CARD_NO, CARPETNO, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, ;
	  WASHTYPE, SPCL_INST, CSTATUS, CTYPE, NOTES, YRPHY) .and. Fdate>=m.Text1 .and. Fdate<=m.Text10;
ORDER BY CARPETNO ASC

USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form rregcarpet.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form rregcarpet.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,  CARPETNO, CARD_NO, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, COLOUR, BREADTH, LENGTH,;
 		SQMT, CSTATUS, FIELDCODE, ORDER_TYPE,  WASHTYPE, CTYPE, NOTES, YRPHY, FDATE
		Messagebox("Search Current Order Carpet Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Case  m.PrnStat="V" .and. m.Option="C" && Viw Edit
		DO VIEWEDIT
	Endcase
Endif
Return

*******************************Procedure to view/ edit
PROCEDURE VIEWEDIT
Private m.coVar1, molno
SET COLOR OF SCHEME 9 TO ;
    W+/BG, W+/BG, B/BG, GR+/W, GR+/B, W+/GR, W+/B, N+/N, GR+/W, N+/W, +

SELECT *;
FROM Carpet!temprepview;
INTO CURSOR botCursor

?? CHR(7)
*DO MessDisplay WITH "[F10]= Return to the Same Record in Buyers Order     [F5]= Print     [ESC]= Exit"
WAIT WINDOW ALLTRIM(STR(RECCOUNT("botCursor"))) + " Matching Records Found !" NOWAIT
SELECT botCursor
GO TOP
*m.coF10Key = ON("KEY","F10")
DEFINE WINDOW cosSrchWn_ FROM 5.5,00 TO 45,120 IN SCREEN DOUBLE CLOSE FLOAT GROW ZOOM MDI ;
	 TITLE "[Order Searched by Criteria / [ESC] to Exit ]" 
	 
ON KEY LABEL F10 KEYBOARD CHR(23)
BROWSE FIELDS CARPETNO:H="Carpet No":R,CARD_NO:H="Card No":R, OL_NO:H="OL No.":12:R,YRPHY:H="Yr.Phy":6:R,ORDER_TYPE:H="O.Type":8:R,DESIGN:H="Design":16:R, QUALITY:H="Quality":10:R,;
  SZCODE:H="Ord-Size":R, COLOUR:H="Color":9:R, FIELDCODE:H="Fld":5:R, CTYPE:H="C.Type":10:R, PO_NO:H="P.O.NO.":R, BCODE:H="Buyer":10:R, FDATE:H="Fin.DT", CSTATUS:H="Status";
  REST FREEZE CARPETNO NOAPPEND NODELETE NOEDIT NOMENU ;                 && NOMENU TIMEOUT 15
  TITLE "Matching Orders with Search, Select by Arrow key and press [F10] to EDIT / [ESC] to Exit" WINDOW cosSrchWn_ ;
  COLOR SCHEME 9
m.coVar1  = LASTKEY()
ON KEY LABEL F10
molno=ol_no		

*USE IN botCursor

IF m.coVar1 = 23   && F10 Pressed: Point to the Same Record !    (ON KEY LABEL ENTER    KEYBOARD CHR(13))
SELECT Casupord
REPLACE ALL Recd WITH .F.  && instead of Recd, label used
GO TOP

UPDATE Casupord;
SET Recd=.T.;
WHERE OL_NO IN (SELECT OL_NO FROM botCursor)

  SELECT Casupord
  SET ORDER TO  OL_NO
  Locate for ol_no=molno
  *SEEK m.coVar2
  IF (.NOT. FOUND())
    ?? CHR(7)
    WAIT WINDOW "This Record is Just Deleted by Another User !!!" TIMEOUT 3
  ELSE
  	 mrecno=recno()
 	Do Form TranSupord
  ENDIF
ENDIF
*
USE IN botCursor
UNLOCK ALL
RELEASE WINDOW cosSrchWn_
RETURN
* EoP()
