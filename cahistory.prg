SET DELETED ON
Set Date to Briti
Set Century on
SET SAFE OFF
SET TALK OFF
SET ANSI ON

SET PROCEDURE TO Catool

DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

IF m.DoNotSrchExp=.T. && exclude Exported Carpet
	CREATE SQL VIEW temprepview1 AS SELECT BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, FIELDCODE, BREADTH, LENGTH,;
 		WASHTYPE, SPCL_INST, CSTATUS, ORDER_TYPE, CTYPE, NOTES, SQMT, PO_DT, DELIRY_DT, QTY, COMMENT ;
 	FROM  Cabuyord;
	WHERE cstatus<>"Exported"
ELSE && Search All including Exported Carpet Also
	CREATE SQL VIEW temprepview1 AS SELECT BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, FIELDCODE, BREADTH, LENGTH,;
 		WASHTYPE, SPCL_INST, CSTATUS, ORDER_TYPE, CTYPE, NOTES, SQMT, PO_DT, DELIRY_DT, QTY, COMMENT ;
 	FROM  Cabuyord
ENDIF

CREATE SQL VIEW temprepview AS SELECT *;
FROM Carpet!temprepview1;
WHERE ccsMatch12(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, ;
	  WASHTYPE, SPCL_INST, CSTATUS, CTYPE, NOTES  );
ORDER BY PO_NO,OL_NO ASC

USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
	Do VIEWEDIT
Endif
Return
******************************************new program start**************
PROCEDURE VIEWEDIT
Private m.coVar1, molno
public m.puol_no
m.puol_no=""
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
BROWSE FIELDS PO_NO:H="P.O.NO.":R, BCODE:H="Buyer":10:R, OL_NO:H="OL No.":12:R,ORDER_TYPE:H="O.Type":10:R, DESIGN:H="Design":16:R, ;
  QUALITY:H="Quality":10:R, SZCODE:H="Ord-Size":R, COLOUR:H="Color":9:R, CSTATUS:H="Status":10:R, FIELDCODE:H="Fld":5:R, CTYPE:H="C.Type":10:R, ;
  PO_DT:H="PO Date":R, DELIRY_DT:H="Dlv. Date":R, QTY:P="9999":H="Qty.":4:R, ;
  COMMENT:R REST FREEZE OL_NO NOAPPEND NODELETE NOEDIT NOMENU ;                 && NOMENU TIMEOUT 15
  TITLE "Matching Orders with Search, Select by Arrow key and press [F10] to VIEW / [ESC] to Exit" WINDOW cosSrchWn_ ;
  COLOR SCHEME 9
m.coVar1  = LASTKEY()
m.puol_no=alltrim(ol_no)
ON KEY LABEL F10
USE IN botCursor
IF m.coVar1 = 23   && F10 Pressed: Point to the Same Record !    (ON KEY LABEL ENTER    KEYBOARD CHR(13))
  	Do Form cahistory
ENDIF

RELEASE WINDOW cosSrchWn_
RETURN

* EoP()

