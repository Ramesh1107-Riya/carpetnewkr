		**Calling program
  	  *  ON ERROR DO errhand IN errutil ;
	  *   WITH SYS(0), ERROR(), MESSAGE(), MESSAGE(1), ;
	  *   PROGRAM(), LINENO(1), DBF(), DATE(), TIME()
	      * End of error trap setup.
	      
	      
	      PROCEDURE errhand
	      PARAMETER m.machine, m.messgnum, m.messg, m.linecode, ;
	         m.callprog, m.inline, m.OPENTABL, m.errdate, ;
	         m.errtime
	         m.errspace=SELECT()      && Store current work area.
	         m.errorder=ORDER()       && Store current order.
	      IF LEN(ALLTRIM(m.callprog))=0
	         m.callprog="Command Line"
	        STORE SPACE(0) TO m.linecode
	      ENDIF
	      outmsgline="Error ; "+m.messg+CHR(13)+"Line "+STR(m.inline)+ ;
	           CHR(13)+ ;
	          "program name = "+m.callprog+CHR(13)+"Syntax is  :"+m.linecode
	      * Visual FoxPro users use =MESSAGEBOX(outmsgline,32+0)
	      * MAC uUse the FXALERT() Function in Foxtools.mlb
	      * FoxPro For Windows users use the MsgBox() Function in Foxtools.fll
	      WAIT WINDOW outmsgline TIMEOUT 5 && All versions can use this syntax.
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
	      RELEASE ALL LIKE m.messgnum, m.messg, m.linecode, m.callprog, ;
	          m.inline
	      RETURN

* Create ztest.prg
       * DO errutil          && Activates ON ERROR routine in Errutil.prg.
	    *  USE c:\noexist.dbf  && These files should not exist in order to
	     * DO C:\noexist.prg   && produce errors for testing purposes.
 *Do ztest


***************** 
** When you Shut Down	Find all the procedure again in internet
 Procedure closeall
  * Procedure CLOSEALL
  * Closes, Clears and Resets most everything after an error or suspend
  * I usually assign this routine to a function key using on key label
  *
  * Written in VFP8 by Ben Creighton 9/1/2005
  * 1st:  Clean up ON routines
  On Error
  On Shutdown
  On Escape
  Set Escape On
  On Key
  Clear Typeahead

  * 2nd: Trash and reset the menus
  * These are done early in case any variables/fields are used in SKIP FOR
  Deactivate Menu All
  Clear Menus
  Clear Popups
  Set Sysmenu To Default
  Set Sysmenu On

  * Go through each session, rollback transactions,
  * and tableupdate unless there is an error in which case revert
*  For xx=1 To Asessions(sessionList)  && 17/07/2011 withdrawn by Ramesh to adjust in Version VFP-6
*    Set DataSession To sessionList[m.xx]
    Do While Txnlevel() > 0
      Rollback
    Enddo
    For yy=1 To Aused(usedA)
      Select (usedA[m.yy,1])
      If CursorGetProp("Buffering") > 1
        If !Tableupdate(2, .T.)
          Tablerevert(.T.)
        Endif
      Endif
    Endfor
*  Endfor

  * Clear out memory first, close data later
  Clear All
  Clear Program
  Clear Resources
  Close All

  * Miscellaneous stuff
  Set Printer To
  Set Printer Off
  Set Talk Off
*  Set Help To
  Set Help On
  Clear
  Quit && Added by Ramesh 18 July,2011
*  If Version(2)>0
    * Development Environment Specific Stuff
    * POP KEY
 * Endif
  *Cancel
  *Return
  
  
