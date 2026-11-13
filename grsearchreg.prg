*Grsearch
SET DELETED ON
SET TALK OFF
SET SAFE OFF
SET PROCEDURE TO Catool

DO grTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet shared

*	(called from GrRegister)
	
	CREATE SQL VIEW temprepview AS SELECT *;
 	FROM  carpet!grregview; 
 	WHERE ccsMatch15(BCODE,DESIGN,SZCODE,QUALITY,ROOMS,FULLHALF,ORDER_TYPE,REMARK,MASTER_NR,REG_NR,IR,OL_NO);
 	ORDER BY DESIGN, SZCODE, QUALITY ASC
 	 	
USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form grsearchreg.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form grsearchreg.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE, DESIGN, SZCODE, QUALITY, ROOMS, FULLHALF, ORDER_TYPE, REMARK, MASTER_NR, REG_NR, IR, OL_NO
		Messagebox("Graph Register Search Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Case  m.PrnStat="V" .and. m.Option="C" && Viw Edit
		DO VIEWEDIT
	Endcase
Endif
Return
******************************************new program start**************
PROCEDURE VIEWEDIT
Private m.coVar1, mreg_nr, srchcall
srchcall=.T.

SET COLOR OF SCHEME 9 TO ;
    W+/BG, W+/BG, B/BG, GR+/W, GR+/B, W+/GR, W+/B, N+/N, GR+/W, N+/W, +

SELECT *;
FROM  Carpet!Temprepview;
INTO CURSOR botCursor
?? CHR(7)
WAIT WINDOW ALLTRIM(STR(RECCOUNT("botCursor"))) + " Matching Records Found !" NOWAIT
SELECT botCursor
GO TOP
DEFINE WINDOW cosSrchWn_ FROM 5.5,00 TO 45,120 IN SCREEN DOUBLE CLOSE FLOAT GROW ZOOM MDI ;
	 TITLE "[Order Searched by Criteria / [ESC] to Exit ]" 
ON KEY LABEL F10 KEYBOARD CHR(23)
BROWSE FIELDS Reg_nr,Master_nr,Ol_no,Design,Szcode,Quality,Rooms,Fullhalf,Bcode,Order_type,IR,Remark ;
  NOAPPEND NODELETE NOEDIT NOMENU ;                 && NOMENU TIMEOUT 15
  TITLE "Matching Graph with Search, Select by Arrow key and press [F10] to EDIT / [ESC] to Exit" WINDOW cosSrchWn_ ;
  COLOR SCHEME 9
m.coVar1  = LASTKEY()
mreg_nr=reg_nr
ON KEY LABEL F10
USE IN botCursor


*****************************************************8

SELECT grregstr
IF m.coVar1 = 23   && F10 Pressed: Point to the Same Record !    (ON KEY LABEL ENTER    KEYBOARD CHR(13))
  SET ORDER TO  reg_nr
  Locate for reg_nr=mreg_nr
  IF (.NOT. FOUND())
    ?? CHR(7)
    WAIT WINDOW "This Record is Just Deleted by Another User !!!" TIMEOUT 3
  ELSE
  	 mrecno=recno()
 	Do Form grregstrce
	ENDIF
ENDIF
RELEASE WINDOW cosSrchWn_
RETURN
* EoP()
