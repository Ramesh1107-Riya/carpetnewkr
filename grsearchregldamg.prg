*Grsearchregisd.prg Search Lost-Damaged

Local irdhead
irdhead=""
SET DELETED ON
set procedure to catool
SET TALK OFF
SET SAFE OFF
Set Date to Briti
Set Century on
SET ANSI ON

DO grTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet shared
*	(called from GrRegister)

Do Case
		Case pLostDEntry=.T.
			SELECT *;
			FROM Carpet!grregview;
			WHERE ccsMatch15(BCODE,DESIGN,SZCODE,QUALITY,ROOMS,FULLHALF,ORDER_TYPE,REMARK,MASTER_NR,REG_NR,IR);
			HAVING IR<>"D";
			ORDER BY DESIGN, SZCODE, QUALITY ASC;
			INTO CURSOR botCursor
			irdhead="Matching Graph to Mark for Lost-Damage, Select by Arrow key and press [F10] to Mark Lost-Damage / [ESC] to Exit"
		Case pLostEdDel=.T.
			SELECT *;
			FROM Carpet!grregview;
			WHERE ccsMatch15(BCODE,DESIGN,SZCODE,QUALITY,ROOMS,FULLHALF,ORDER_TYPE,REMARK,MASTER_NR,REG_NR,IR);
			HAVING IR="D";
			INTO CURSOR botCursor
			irdhead="Matching Marked Lost-Damaged Registered Graph, Select by Arrow key and press [F10] to Mark Lost-Damaged / [ESC] to Exit"			
ENDCASE

Select botCursor
GO TOP
*SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else  && Endif in the end
Public m.psreg_nr
m.psreg_nr=""
Private m.coVar1, srchcall
srchcall=.T.
SET COLOR OF SCHEME 9 TO ;
    W+/BG, W+/BG, B/BG, GR+/W, GR+/B, W+/GR, W+/B, N+/N, GR+/W, N+/W, +
?? CHR(7)
WAIT WINDOW ALLTRIM(STR(RECCOUNT("botCursor"))) + " Matching Records Found !" NOWAIT
*SELECT botCursor
*GO TOP


DEFINE WINDOW cosSrchWn_ FROM 5.5,00 TO 45,120 IN SCREEN DOUBLE CLOSE FLOAT GROW ZOOM MDI ;
	 TITLE "[Order Searched by Criteria / [ESC] to Exit ]" 
ON KEY LABEL F10 KEYBOARD CHR(23)
BROWSE FIELDS Reg_nr,Master_nr,Design,Szcode,Quality,Rooms,Fullhalf,Bcode,Order_type,IR,lostdamgdt,Remark ;
  NOAPPEND NODELETE NOEDIT NOMENU  TITLE irdhead WINDOW cosSrchWn_ COLOR SCHEME 9
m.coVar1  = LASTKEY()
m.psreg_nr=reg_nr
ON KEY LABEL F10
USE IN botCursor
*****************************************************8
SELECT grregstr
IF m.coVar1 = 23   && F10 Pressed: Point to the Same Record !    (ON KEY LABEL ENTER    KEYBOARD CHR(13))
  SET ORDER TO  reg_nr
  Locate for reg_nr=m.psreg_nr
  IF (.NOT. FOUND())
    ?? CHR(7)
    WAIT WINDOW "This Record is Just Deleted by Another User !!!" TIMEOUT 3
  ELSE
  	mrecno=recno()
 	Do Form grregstrldamg
	ENDIF
ENDIF
RELEASE WINDOW cosSrchWn_
Endif && 
RETURN
* EoP()
