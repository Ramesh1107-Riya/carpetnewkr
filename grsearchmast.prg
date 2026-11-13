*Grsearch
SET PROCEDURE TO Catool
SET DELETED ON
SET TALK OFF
SET SAFE OFF

DO grmTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet shared
 	*(CALLED FROM Master Graph)
	CREATE SQL VIEW temprepview AS SELECT Bcode, Design, Szcode, Quality, Rooms, Fullhalf, Order_Type, Remark, Master_nr,Preparedt;
 	FROM  carpet!grmaster; 
 	WHERE ccsMatch16(BCODE,DESIGN,SZCODE,QUALITY,ROOMS,FULLHALF,ORDER_TYPE,REMARK,MASTER_NR);
 	ORDER BY DESIGN, SZCODE, QUALITY ASC

USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form grsearchm.frx to console preview in screen
	Case m.PrnStat="P" .and. m.Option="B"
		Report form grsearchm.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE, DESIGN, SZCODE, QUALITY, ROOMS, FULLHALF, ORDER_TYPE, REMARK, MASTER_NR, PREPAREDT
		Messagebox("Master Graph Search Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Case  m.PrnStat="V" .and. m.Option="C" && Viw Edit
		DO VIEWEDIT
	Endcase
Endif
Return
******************************************new program start**************
PROCEDURE VIEWEDIT
Private m.coVar1, srchcall
srchcall=.T.
Public m.pmaster_nr
m.pmaster_nr=""

SET COLOR OF SCHEME 9 TO ;
    W+/BG, W+/BG, B/BG, GR+/W, GR+/B, W+/GR, W+/B, N+/N, GR+/W, N+/W, +

SELECT *;
FROM Carpet!temprepview;
INTO CURSOR botCursor

?? CHR(7)
WAIT WINDOW ALLTRIM(STR(RECCOUNT("botCursor"))) + " Matching Records Found !" NOWAIT
SELECT botCursor
GO TOP
DEFINE WINDOW cosSrchWn_ FROM 5.5,00 TO 45,120 IN SCREEN DOUBLE CLOSE FLOAT GROW ZOOM MDI ;
	 TITLE "[Order Searched by Criteria / [ESC] to Exit ]" 

ON KEY LABEL F10 KEYBOARD CHR(23)

If regcall=.T.  && Extra Added
BROWSE FIELDS Master_nr,Design,Szcode,Quality,Rooms,Fullhalf,Bcode,Order_type,Preparedt,Remark ;
  NOAPPEND NODELETE NOEDIT NOMENU ;                 && NOMENU TIMEOUT 15
  TITLE "Matching Master Graph, Select by Arrow key and press [F10] to ENTER (Copy Master Graph Into Graph Register )/ [ESC] to Exit" WINDOW cosSrchWn_ ;
  COLOR SCHEME 9
Else  
BROWSE FIELDS Master_nr,Design,Szcode,Quality,Rooms,Fullhalf,Bcode,Order_type,Preparedt,Remark ;
  NOAPPEND NODELETE NOEDIT NOMENU ;                 && NOMENU TIMEOUT 15
  TITLE "Matching Master Graph with Search, Select by Arrow key and press [F10] to EDIT / [ESC] to Exit" WINDOW cosSrchWn_ ;
  COLOR SCHEME 9
Endif
  
m.coVar1  = LASTKEY()
m.pmaster_nr= master_nr
ON KEY LABEL F10
USE IN botCursor
*************************************************

SELECT grmaster
IF m.coVar1 = 23   && F10 Pressed: Point to the Same Record !    (ON KEY LABEL ENTER    KEYBOARD CHR(13))
  SET ORDER TO  master_nr
  Locate for master_nr=m.pmaster_nr
  IF (.NOT. FOUND())
    ?? CHR(7)
    WAIT WINDOW "This Record is Just Deleted by Another User !!!" TIMEOUT 3
  ELSE
  	 IF regcall=.T.   && added for copying master graph
  		 Do Form grregstrme  && Graph Register Entry
  	 Else
  		 mrecno=recno()
 		 Do Form grmastere  && Master Grah Entry
 	 ENDIF
  ENDIF
ENDIF
RELEASE WINDOW cosSrchWn_
RETURN
* EoP()
