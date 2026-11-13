*Grsearchregisd.prg Search Issue/Recive/Lost-Damaged
Local irdhead
irdhead=""
SET DELETED ON
set procedure to catool
SET TALK OFF
SET SAFE OFF
Set Date to Briti
Set Century on
SET ANSI ON

DO grSTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet Share

Do Case
		Case pIssEntry=.T.	&& create grregstr view from faster		
			SELECT *;
			FROM Carpet!grregview;
			WHERE ccsMatch15(BCODE,DESIGN,SZCODE,QUALITY,ROOMS,FULLHALF,ORDER_TYPE,REMARK,MASTER_NR,REG_NR,IR);
			HAVING IR="S";
			ORDER BY DESIGN, SZCODE, QUALITY ASC,REG_NR;
			INTO CURSOR botCursor
			irdhead="Matching Register Graph for Issue, Select by Arrow key and press [F10] to Issue to Supplier  / [ESC] to Exit"
			
		Case pRecEntry=.T.
			SELECT *;
			FROM Carpet!GrSupRegViw;
			WHERE ccsMatch17(BCODE,DESIGN,SZCODE,QUALITY,ROOMS,FULLHALF,ORDER_TYPE,REMARK,MASTER_NR,REG_NR,IR,SUPPLIER,SUPIR);
			HAVING IR="I" .and. Empty(Retdt);
			ORDER BY DESIGN, SZCODE, QUALITY ASC,REG_NR;
			INTO CURSOR botCursor
			irdhead="Matching Receive Graph (Only Stock Graph), Select by Arrow key and press [F10] to Recive from Supplier  / [ESC] to Exit"
			
		Case pIssEdDel=.T.
			SELECT *;
			FROM Carpet!GrSupRegViw;
			WHERE ccsMatch17(BCODE,DESIGN,SZCODE,QUALITY,ROOMS,FULLHALF,ORDER_TYPE,REMARK,MASTER_NR,REG_NR,IR,SUPPLIER,SUPIR);
			HAVING IR="I" .and. Empty(RETDT);
			ORDER BY DESIGN, SZCODE, QUALITY ASC,REG_NR;
			INTO CURSOR botCursor
			irdhead="Matching Issue Register Graph for Edit/Delete, Select by Arrow key and press [F10] Edit/Delete Issue / [ESC] to Exit"
			
		Case pRecEdDel=.T.		
			SELECT *;
			FROM Carpet!GrSupRegViw;
			WHERE ccsMatch17(BCODE,DESIGN,SZCODE,QUALITY,ROOMS,FULLHALF,ORDER_TYPE,REMARK,MASTER_NR,REG_NR,IR,SUPPLIER,SUPIR);
			ORDER BY DESIGN, SZCODE, QUALITY ASC,REG_NR;
			INTO CURSOR botCursor
			irdhead="Matching Receive Graph for Edit/Delete, Select by Arrow key and press [F10] to Edit/Delete Recive / [ESC] to Exit"
ENDCASE			&&	HAVING !EMPTY(RETDT); && withdrawn on July 15,2011 it did not give chace to edit

Select botCursor
GO TOP

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else  && Endif in the end
Public m.psreg_nr, m.psupplier, m.pissdt, m.pretdt, m.psupir
m.psreg_nr=""
Private m.coVar1, srchcall
srchcall=.T.
SET COLOR OF SCHEME 9 TO ;
    W+/BG, W+/BG, B/BG, GR+/W, GR+/B, W+/GR, W+/B, N+/N, GR+/W, N+/W, +
?? CHR(7)
WAIT WINDOW ALLTRIM(STR(RECCOUNT("botCursor"))) + " Matching Records Found !" NOWAIT

IF pIssEntry=.T.
	DEFINE WINDOW cosSrchWn_ FROM 5.5,00 TO 45,130 IN SCREEN DOUBLE CLOSE FLOAT GROW ZOOM MDI ;
		 TITLE "[Order Searched by Criteria / [ESC] to Exit ]" 
		ON KEY LABEL F10 KEYBOARD CHR(23)
	BROWSE FIELDS Reg_nr,Master_nr,Design,Szcode,Quality,Rooms,Fullhalf,Bcode,Order_type,IR, Remark ;
  	 NOAPPEND NODELETE NOEDIT NOMENU  TITLE irdhead WINDOW cosSrchWn_ COLOR SCHEME 9
Else
	DEFINE WINDOW cosSrchWn_ FROM 5.5,00 TO 45,130 IN SCREEN DOUBLE CLOSE FLOAT GROW ZOOM MDI ;
		 TITLE "[Order Searched by Criteria / [ESC] to Exit ]" 
		ON KEY LABEL F10 KEYBOARD CHR(23)
	BROWSE FIELDS Reg_nr,Master_nr,Design,Szcode,Supplier,Issdt,Retdt,Quality,Rooms,Fullhalf,Bcode,Order_type,IR,Remark ;
  	 NOAPPEND NODELETE NOEDIT NOMENU  TITLE irdhead WINDOW cosSrchWn_ COLOR SCHEME 9
ENDIF

m.coVar1  = LASTKEY()
m.psreg_nr=reg_nr
If  !(pIssEntry=.T.)
	m.psupplier=supplier
	m.pissdt=issdt
	m.pretdt=retdt
	m.psupir=supir
Endif

ON KEY LABEL F10
USE IN botCursor
*****************************************************8
If !(pIssEntry=.T.)
SELECT GrSupTran
IF m.coVar1 = 23   && F10 Pressed: Point to the Same Record !    (ON KEY LABEL ENTER    KEYBOARD CHR(13))
  SET ORDER TO  reg_nr
  Locate for reg_nr=m.psreg_nr .and. supplier=m.psupplier .and. issdt=m.pissdt .and. retdt=m.pretdt .and. supir=m.psupir 
   IF (.NOT. FOUND())
    ?? CHR(7)
    WAIT WINDOW "This Record is Just Deleted by Another User !!!" TIMEOUT 3
  ELSE
  	Do Case 
  		*Case pIssEntry=.T.		
 		*	Do Form grregstriss
 		Case pIssEdDel=.T.
 			Do Form grregstriss
 		Case pRecEntry=.T.
 			Do Form grregstrrev
 		Case pRecEdDel=.T.
 			Do Form grregstrrev
 	Endcase
 ENDIF
ENDIF
Else && If !(pIssEntry=.T.)
	SELECT GrRegstr
	IF m.coVar1 = 23   && F10 Pressed: Point to the Same Record !    (ON KEY LABEL ENTER    KEYBOARD CHR(13))
  		SET ORDER TO  reg_nr
 		Locate for reg_nr=m.psreg_nr
 		IF (.NOT. FOUND())
   			 ?? CHR(7)
    		WAIT WINDOW "This Record is Just Deleted by Another User !!!" TIMEOUT 3
    	Else
 			Do Form grregstriss
 		Endif
Endif
Endif
RELEASE WINDOW cosSrchWn_
Endif && Big endif RECNO()>RECCOUNT()
RETURN
* EoP()
