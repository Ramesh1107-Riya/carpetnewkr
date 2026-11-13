SET DELETED ON
SET PROCEDURE TO Catool
SET TALK OFF
SET SAFE OFF
Set Date to Briti
Set Century on
SET ANSI ON


DO csTrimInfos      && Trim Information for Check Purpose, for Stock !
Open Database Carpet
 IF m.DoNotSrchExp=.T.  && exclude Exported Carpet
	CREATE SQL VIEW temprepview1 AS SELECT BCODE, CARD_NO, CARPETNO, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, FIELDCODE, BREADTH, LENGTH,;
 		WASHTYPE, SPCL_INST, CSTATUS, ORDER_TYPE, CTYPE, NOTES, YRPHY,SQMT,LOCATION,SL_NO;
 	FROM  Stkcarpet;
	WHERE cstatus!="Exported" 
ELSE && Search All including Exported Carpet Also
	CREATE SQL VIEW temprepview1 AS SELECT BCODE, CARD_NO, CARPETNO, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, FIELDCODE, BREADTH, LENGTH,;
		WASHTYPE, SPCL_INST, CSTATUS, ORDER_TYPE, CTYPE, NOTES, YRPHY,SQMT,LOCATION,SL_NO;
 	FROM  Stkcarpet
ENDIF


CREATE SQL VIEW temprepview AS SELECT *;
FROM Carpet!temprepview1;
WHERE ccsMatch11(BCODE,CARD_NO, CARPETNO, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, ;
	  WASHTYPE, SPCL_INST, CSTATUS, CTYPE, NOTES, YRPHY,LOCATION,SL_NO);
ORDER BY CARPETNO ASC

USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form rstkcarpet.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form rstkcarpet.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,  CARPETNO, PO_NO, CTRL_NO, SL_NO, QUALITY, DESIGN, COLOUR, BREADTH, LENGTH,;
 		SQMT, CSTATUS,LOCATION, YRPHY 
		Messagebox("Search Stock Carpet Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
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
BROWSE FIELDS CARPETNO:H="Carpet No":R,DESIGN:H="Design":16:R,QUALITY:H="Quality":10:R,COLOUR:H="Color":9:R,SZCODE:H="Ord-Size":R,;
  SL_NO:H="Category":10:R,LOCATION:H="Location":10:R,PO_NO:H="P.O.NO.":R,BCODE:H="Buyer":10:R,YRPHY:H="Yr.Phy":6:R REST;
  FREEZE CARPETNO NOAPPEND NODELETE NOEDIT NOMENU ;                 && NOMENU TIMEOUT 15
  TITLE "Matching Orders with Search, Select by Arrow key and press [F10] to EDIT / [ESC] to Exit" WINDOW cosSrchWn_ COLOR SCHEME 9
m.coVar1  = LASTKEY()
ON KEY LABEL F10
molno=ol_no		

*USE IN botCursor

IF m.coVar1 = 23   && F10 Pressed: Point to the Same Record !    (ON KEY LABEL ENTER    KEYBOARD CHR(13))
SELECT STKCARPET
REPLACE ALL Label WITH .F.  && instead of Recd, label used
GO TOP

UPDATE STKCARPET;
SET Label=.T.;
WHERE OL_NO IN (SELECT OL_NO FROM botCursor)

  SELECT STKCARPET
  SET ORDER TO  OL_NO
  Locate for ol_no=molno
  *SEEK m.coVar2
  IF (.NOT. FOUND())
    ?? CHR(7)
    WAIT WINDOW "This Record is Just Deleted by Another User !!!" TIMEOUT 3
  ELSE
  	 mrecno=recno()
 	Do Form Transtkcarpet
  ENDIF
ENDIF
*
USE IN botCursor
UNLOCK ALL
RELEASE WINDOW cosSrchWn_
RETURN
* EoP()
