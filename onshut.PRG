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
  For xx=1 To Asessions(sessionList)
    Set DataSession To sessionList[m.xx]
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
  Endfor

  * Clear out memory first, close data later
  Clear All
  Clear Program
  Clear Resources
  Close All

  * Miscellaneous stuff
  Set Printer To
  Set Printer Off
  Set Talk Off
  Set Help To
  Set Help On
  Clear
  If Version(2)>0
    * Development Environment Specific Stuff
    * POP KEY
  Endif
  Cancel
  Return