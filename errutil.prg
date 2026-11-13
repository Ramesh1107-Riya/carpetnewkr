**Calling program
  	  *  ON ERROR DO errhand IN errutil WITH SYS(0), ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO(1), DBF(), DATE(), TIME()
**End of error trap setup.

PROCEDURE errhand
PARAMETER m.machine, m.messgnum, m.messg, m.linecode, m.callprog, m.inline, m.OPENTABL, m.errdate, m.errtime

m.errspace=SELECT()      && Store current work area.
m.errorder=ORDER()       && Store current order.

IF LEN(ALLTRIM(m.callprog))=0
    m.callprog="Command Line"
STORE SPACE(0) TO m.linecode
ENDIF

outmsgline="Error Message; "+m.messg+CHR(13)+"Line "+STR(m.inline)+ CHR(13)+ ;
"program name = "+m.callprog+CHR(13)+"Syntax is  :"+m.linecode

* Normal Errors - Program should not hang here.
DO CASE
  CASE  m.messgnum=3  .OR. m.messgnum=110  &&File  is Excusively used by another user
	    WAIT WINDOW outmsgline TIMEOUT 2 
    	RETURN
  CASE  m.messgnum=1705           && File Access Denied
  		WAIT WINDOW outmsgline TIMEOUT 2 
    	RETURN
  CASE  m.messgnum=1520  && No file Open
  		RETURN TO MASTER
  		    
  OTHERWISE
		WAIT CLEAR && astrik by ramesh
		SET BELL      TO 500, 15
		DEFINE WINDOW ErrWindow FROM 0,0 TO 24,79 IN SCREEN PANEL NOCLOSE NOFLOAT ;
		NOGROW NOZOOM COLOR SCHEME 5          && IIF(ISCOLOR(), 5, 1)
		ACTIVATE WINDOW ErrWindow NOSHOW TOP
		PRIVATE m.GuideUser1, m.GuideUser2
		m.GuideUser1 = "E R R O R     O C C U R E D"
		m.GuideUser2 = "Please note down the above message and call your consultant !"
		?? CHR(7) + CHR(7)               && Double Beep
		@ 1,(WCOLS()-LEN(m.GuideUser1))/2 SAY m.GuideUser1
		@ 5,2  SAY "         Error Code : " + ALLTRIM(STR( m.messgnum))
		@ 7,2  SAY "            Message : " + m.messg
		@ 9,2  SAY "        Line Number : " + ALLTRIM(STR(m.inline))
		@ 11,2 SAY "Program/Module Name : " + m.callprog
		@ 13,2 SAY "     FoxPro Command : " + LEFT(m.linecode, 150) &&254 is original value
		@ 15,2 SAY "Open Table (*.DBF)  : " + m.OPENTABL
		@ 18,1  SAY m.GuideUser2
		@ 21,5  SAY "Press [ESC] to Continue"
		SHOW WINDOW ErrWindow
		DO WHILE LASTKEY() # 27
		  m.TempKey = INKEY(0)
		ENDDO
ENDCASE

* Write problem from above parameters in Errolog.dbf for review later
* If No Errorlog.dbf create one Else wite in the database
   IF !USED("ERRORLOG")
	      IF FILE("ERRORLOG.DBF")
	         SELECT 0
	         USE errorlog
	      ELSE
	         SELECT 0
	         thisversion=VERSION()
	         IF LEFT(ALLTRIM(thisversion),6)="Visual"
	            * Create Free table for Visual FoxPro Versions
	            CREATE TABLE errorlog FREE (machine c(20), messgnum N(4,0), ;
	               messg c(70), linecode c(70), callprog c(40), ;
	               inline N(6,0), OPENTABL c(25), errdate d, errtime c(8))
	         ELSE
	               CREATE TABLE errorlog (machine c(20), messgnum N(4,0), ;
	                    messg c(70), linecode c(70), callprog c(40), ;
	                 inline N(6,0), OPENTABL c(25), errdate d, errtime c(8))
	               ENDIF
	            ENDIF
	        ENDIF
	        INSERT INTO errorlog FROM MEMVAR
	        SELECT errorlog                  && Select errorlog table.
	        USE                              && Close errorlog table.
	        SELECT (m.errspace)              && Return to stored work area.
	        IF !EMPTY(ALIAS())
	      SET ORDER TO (m.errorder)
	       ENDIF
	      RELEASE ALL LIKE m.messgnum, m.messg, m.linecode, m.callprog, m.inline
	      Do closeall
*eof Errorlog

Procedure closeall
Local myprg
myprg=.F.
  * Procedure CLOSEALL
  * Closes, Clears and Resets most everything after an error or suspend
  * I usually assign this routine to a function key using on key label
  * 1st:  Clean up ON routines
  On Error
  On Shutdown
  On Escape
  Set Escape On
  On Key
  Clear Typeahead
  *Set Sysmenu 

**This program is completely withdrawn 97/08/2011 to hang up, later check
If myprg=.T.
#define MAX_SESSIONS 200

LOCAL lnCurrentDataSession, ;
  lnCurrentWorkArea, ;
  lcErrorCode, ;
  laFiles[1]

PRIVATE plError

plError = .F.
lcErrorCode = ON( "error")
ON ERROR plError = .T.

IF USED() && code added on 21/7/2011 if no file is opened then also it works
FOR lnCurrentDataSession = 1 TO MAX_SESSIONS
  SET DATASESSION TO ( lnCurrentDataSession )
  IF plError
    *-- An error occured, must not have
    *-- any data in this datasession
    plError = .f.
  ELSE
    *-- Ok, we have data here
    FOR lnCurrentWorkArea = 1 to AUSED( laFiles )
      SELECT (laFiles[lnCurrentWorkArea])
      IF CURSORGETPROP("BUFFERING") > 1
        TABLEREVERT(.T.)
      ENDIF
      USE && close the table
      plError = .F.
    ENDFOR
  ENDIF
ENDFOR
FLUSH
ENDIF
*-- Now reset the error handling code
IF NOT EMPTY( lcErrorCode )
  ON ERROR &lcErrorCode
ELSE
  ON ERROR
ENDIF

Endif && Myprg endif  
*********************************
 
  * 2nd: Trash and reset the menus
  * These are done early in case any variables/fields are used in SKIP FOR
  ON KEY LABEL ENTER
  ON KEY LABEL INS
  ON KEY LABEL DEL
  ON KEY LABEL ESC
  ON ESCAPE
  SET ESCAPE    OFF
  ON ERROR      ?? ""
  SET PRINTER   TO
  SET PRINTER   OFF
  SET CONSOLE   ON
  SET CLOCK     OFF
  SET CLEAR     ON
  Deactivate Menu All
  Clear Menus
  Clear Popups
  Set Sysmenu To Default

 * Clear out memory first, close data later
  CLOSE DATABASES
  CLEAR WINDOWS
  CLEAR GETS
  CLOSE ALL
  CLEAR READ ALL
  ACTIVATE SCREEN
  CLEAR
  *Clear All && withdrawn on 18/7/2011 by Ramesh
  Clear Program
  Clear Resources
  Close All
  * Miscellaneous stuff
  Set Printer To
  Set Printer Off
  Set Talk Off
  Set Help On
  Clear
  *Return
  Quit 
*****************
