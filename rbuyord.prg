SET DELETED ON
Set Date to Briti
Set Century on
SET SAFE OFF
SET TALK OFF
SET ANSI ON

SET PROCEDURE TO Catool

DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet shared

IF m.DoNotSrchExp=.T. && exclude Exported Carpet
	SELECT BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, FIELDCODE, BREADTH, LENGTH,;
 		WASHTYPE, SPCL_INST, CSTATUS, ORDER_TYPE, CTYPE, NOTES, SQMT, PO_DT, DELIRY_DT, QTY, COMMENT, SHIP_INST,DATETIME;
 	FROM  Cabuyord;
	WHERE cstatus!="Exported";
	INTO CURSOR temp7
ELSE && Search All including Exported Carpet Also
	SELECT BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, FIELDCODE, BREADTH, LENGTH,;
 		WASHTYPE, SPCL_INST, CSTATUS, ORDER_TYPE, CTYPE, NOTES, SQMT, PO_DT, DELIRY_DT, QTY, COMMENT, SHIP_INST,DATETIME ;
 	FROM  Cabuyord;
 	INTO CURSOR temp7
ENDIF

SELECT *;
FROM temp7;
WHERE ccsMatch12(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, WASHTYPE, SPCL_INST, CSTATUS, CTYPE, NOTES);
ORDER BY DATETIME;
INTO CURSOR temp

Select Temp
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form rbuyord.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form rbuyord.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,CTRL_NO,QUALITY,PO_NO,DESIGN, COLOUR, SZCODE,OL_NO,FIELDCODE,BREADTH, LENGTH,;
 		SQMT,SPCL_INST, CSTATUS, ORDER_TYPE, CTYPE, WASHTYPE, NOTES, SHIP_INST 
		Messagebox("Search Buyer Order Carpet Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Case  m.PrnStat="V" .and. m.Option="C" && Viw Edit
		DO VIEWEDIT
	Endcase
Endif
Return
******************************************new program start**************
PROCEDURE VIEWEDIT
Private m.coVar1, m.ol_no, srchcall
srchcall=.T.

SET COLOR OF SCHEME 9 TO ;
    W+/BG, W+/BG, B/BG, GR+/W, GR+/B, W+/GR, W+/B, N+/N, GR+/W, N+/W, +

SELECT *;
FROM temp;
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
BROWSE FIELDS PO_NO:H="P.O.NO.":R, PO_DT:H="PO Date":R, BCODE:H="Buyer":7:R,CTRL_NO:H="Byer No.":10,OL_NO:H="OL No.":8:R,ORDER_TYPE:H="O.Type":10:R, DESIGN:H="Design":16:R, ;
  QUALITY:H="Quality":10:R, SZCODE:H="Ord-Size":10, COLOUR:H="Color":9:R, CSTATUS:H="Status":9:R, SHIP_INST:H="Ship":4:R,FIELDCODE:H="Fld":5:R, CTYPE:H="C.Type":10:R, ;
  DELIRY_DT:H="Dlv. Date":R, QTY:P="9999":H="Qty.":4:R, ;
  COMMENT:R REST FREEZE OL_NO NOAPPEND NODELETE NOEDIT NOMENU ;                 && NOMENU TIMEOUT 15
  TITLE "Matching Orders with Search, Select by Arrow key and press [F10] to EDIT / [ESC] to Exit" WINDOW cosSrchWn_ ;
  COLOR SCHEME 9
m.coVar1  = LASTKEY()
m.ol_no=ol_no
ON KEY LABEL F10
USE IN botCursor

**this was added for multiple order search temporarily withdrawn 7/8/2010 by ramesh
*SELECT Cabuyord
*REPLACE ALL Label WITH .F.
*GO TOP

*UPDATE CaBuyord;
*SET Label=.T.;
*WHERE OL_NO IN (SELECT OL_NO FROM botCursor)
*USE IN botCursor


SELECT CABUYORD
IF m.coVar1 = 23   && F10 Pressed: Point to the Same Record !    (ON KEY LABEL ENTER    KEYBOARD CHR(13))
  SET ORDER TO  OL_NO
  Locate for ol_no=m.ol_no
  *SEEK m.coVar2
  IF (.NOT. FOUND())
    ?? CHR(7)
    WAIT WINDOW "This Record is Just Deleted by Another User !!!" TIMEOUT 3
  ELSE
  	 mrecno=recno()
 	Do Form tranbuyord 	 
  ENDIF
ENDIF
RELEASE WINDOW cosSrchWn_
RETURN
* EoP()
