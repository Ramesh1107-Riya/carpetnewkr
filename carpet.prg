* Bof()                          Carpet.PRG
*
* Main Propcedure for Carpet Inventory Database Program !!

* Environment Settings
SET TALK           OFF
SET ALTERNATE      OFF
SET ANSI           OFF
SET AUTOSAVE       OFF
SET BELL           OFF
SET BELL           TO 1500,3
SET BLINK          OFF
SET BLOCKSIZE      TO 64
SET BORDER         TO SINGLE
SET BRSTATUS       OFF
SET CARRY          OFF
SET CENTURY        ON
SET CLEAR          OFF
SET CLOCK          OFF
SET COMPATIBLE     OFF
SET CONFIRM        ON
SET CONSOLE        ON
SET CURRENCY       TO "NPR"
SET CURRENCY       LEFT
SET CURSOR         OFF
SET DATE           BRITISH
SET DEBUG          OFF
SET DECIMALS       TO 2
SET DEFAULT        TO
SET DELETED        ON
SET DELIMITERS     OFF
SET DEVELOPMENT    OFF
SET DEVICE         TO SCREEN
SET DISPLAY        TO VGA25
SET DOHISTORY      OFF
SET ECHO           OFF
SET ESCAPE         OFF
SET EXACT          OFF
SET EXCLUSIVE      OFF
SET FIELDS         OFF
SET FIXED          ON
SET FULLPATH       ON
SET HEADING        OFF
SET HELP           OFF
SET HOURS          TO 24
SET INTENSITY      ON
SET LIBRARY        TO
SET LOGERRORS      ON
SET MACKEY         TO
SET MARGIN         TO 0
SET MARK           TO
SET MEMOWIDTH      TO 65
SET MESSAGE        TO 24 CENTER
SET MOUSE          OFF
SET NEAR           OFF
SET NOTIFY         ON
SET ODOMETER       TO 100
SET OPTIMIZE       OFF
SET PATH           TO
SET PDSETUP        TO
SET POINT          TO
SET PRINTER        OFF
SET REFRESH        TO  300
SET RESOURCE       OFF
SET REPROCESS      TO  5  SECONDS
SET SAFETY         OFF
SET SCOREBOARD     OFF
SET SEPARATOR      TO
SET SHADOWS        OFF
SET SPACE          ON
SET STATUS         OFF
SET STEP           OFF
SET STICKY         ON
SET SYSMENU        OFF
SET TALK           OFF
SET TEXTMERGE      ON
SET TRBETWEEN      OFF
SET TYPEAHEAD      TO 20
SET UDFPARMS       TO VALUE
SET UNIQUE         OFF
SET VIEW           OFF

CLOSE DATABASE
CLEAR WINDOWS
CLEAR GETS
CLEAR ALL
CLOSE ALL
CLEAR

* 'GLOBAL' Wondows
DEFINE WINDOW BigWin_ FROM 02,00 TO 23,79 IN SCREEN DOUBLE NOCLOSE NOFLOAT ;
  NOGROW NOZOOM COLOR SCHEME 10

SET PROCEDURE TO CATools
* Error Trapping Procedure
ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()

* Disable all Function Keys with their Combinations
DO DisableKey

* Screen Colour Setting
DO SetColour WITH ISCOLOR()

* General Public Variables
PUBLIC m.Company_, m.CompAddr1_, m.CompAddr2_, m.ProgDir_, m.FileLocked, ;
  m.Color10Line
PUBLIC m.RepSortOn1, m.RepSortOn2, m.RepSortOn3, m.RepSortOn4, m.RepSortOn5, ;
  m.RepSortOn6, m.RepSortOn7, m.RepSortOn8, m.RepSortOn9
STORE "" TO m.RepSortOn1, m.RepSortOn2, m.RepSortOn3, m.RepSortOn4, ;
  m.RepSortOn5, m.RepSortOn6, m.RepSortOn7, m.RepSortOn8, m.RepSortOn9
m.Company_   = "Samling Carpet Industries"
m.CompAddr1_ = "Tinchuli Boudha"
m.CompAddr2_ = "Kathmandu, NEPAL"
m.ProgDir_   = "\CARPET"
m.FileLocked = .F.
m.Color10Line= IIF(ISCOLOR(), "GR+/W", "W+/N")
PUBLIC m.InMenuWait, m.InBrowWait, m.InReadWait
m.InMenuWait = 600   && 10 Minutes
m.InBrowWait = 300   &&  5 Minute
m.InReadWait = 600   && 10 Minutes

* System Checkings
*	1:	Not the 8066, 8088 or 80286 Machine (Means 386, 486 or Others)
*	2:	Minimum DOS Verion 3.1 - in Above '4.*' shoule not be allowed since
*		there's a bug in file handling of that version of DOS. The best is
*		Version 5.00 or above, even the 3.3 is better than all (if not 5.00).
*	3:	Must be the DOS Platform - _DOS
*	4:	Must run Under the Extended Version of FoxPro (X) or FoxPro/LAN
*	5:	Difference of FoxPro'x Memory - SYS(1001) and User Allocated memory
*		- SYS(1016) at this point at least 1 MB required.
*	6:	Other Checkings

*DO CASE
*  CASE (.NOT. ("FoxPro 2.6" $ VERSION()))
*    DO SysClose_ WITH "FoxPro Version 2.6 Required to Run this Program !"
*  CASE VAL(RIGHT(OS(), 5)) < 3
*    DO SysClose_ WITH "This Program Requires DOS Version of 3.0 or Greater !"
*  CASE VAL(SYS(2010)) < 50
*    DO SysClose_ WITH "Please Set  FILES=50  and  BUFFERS=30  in CONFIG.SYS file and Try Again !"
*  CASE VAL(SYS(1001)) < 222222
*    DO SysClose_ WITH "Insufficient Memory !"
*  CASE (SYS(2003) # m.ProgDir_) .OR. SYS(9) # "22080-065-0111272" .OR. ;
*    (.NOT. SYS(17) $ "80386 80486") .OR. SYS(2006) # "VGA/Color"
*  CASE (SYS(2003) # m.ProgDir_) .OR. (.NOT. SYS(17) $ "80386 80486") ;
*    .OR. SYS(2006) # "VGA/Color"
*    DO SysClose_ WITH "This is a COPY VERSION of Original Program !"
*  CASE SYS(2020) # "527654912" .OR. SYS(2022) # "8192"
*    DO SysClose_ WITH "This is a COPY VERSION of Original Program !"
*  CASE DISKSPACE() < 1024 * 5000
*    DO SysClose_ WITH "Insufficient Disk Space - (Minimum 5 MB FREE Disk Space Required) !"
*ENDCASE

* Open Necessary Data Files
PRIVATE m.TempLoopVar
m.TempLoopVar = 1
DO WHILE .T.
  m.FileLocked = .F.
  IF m.TempLoopVar = 1         && Try in Exclusive Mode for Re-Indexing
    USE CaMenu   IN 1  ORDER TAG CaMenu      ALIAS MenuFile   EXCLUSIVE
    USE CaUser   IN 2  ORDER TAG USER_ID     ALIAS UserFile   EXCLUSIVE
    USE CaTrail  IN 3  ORDER TAG CaTrail     ALIAS TrailAudit EXCLUSIVE
    USE CaCtrl   IN 4                        ALIAS Control    EXCLUSIVE
    USE CaGroup  IN 5  ORDER TAG GROUPCODE   ALIAS AccsGroup  EXCLUSIVE
    USE CaPrintr IN 6  ORDER TAG PRINTER     ALIAS Printer    EXCLUSIVE
    IF m.FileLocked
      * Do not Show any Message, but wait 2 Seconds
      = INKEY(1)
      IF LASTKEY() = 27
        DO SysClose_ WITH "Process Interrupted by User !"
      ENDIF
      m.TempLoopVar = m.TempLoopVar + 1
      LOOP
    ENDIF
    * Re-Index all Files
    SELECT MenuFile
    PACK
    REINDEX
    SELECT UserFile
    * PACK         && Because 'Password' is Encrypted with RECNO()
    REINDEX
    SELECT TrailAudit
    PACK
    REINDEX
    SELECT Control
    PACK
    SELECT AccsGroup
    PACK
    REINDEX
    SELECT Printer
    PACK
    REINDEX
    m.TempLoopVar = m.TempLoopVar + 1
    LOOP
  ELSE
    * Now indexing done, re-open them in Sharable Mode
    USE CaMenu   IN 1  ORDER TAG CaMenu      ALIAS MenuFile
    USE CaUser   IN 2  ORDER TAG USER_ID     ALIAS UserFile
    USE CaTrail  IN 3  ORDER TAG CaTrail     ALIAS TrailAudit
    USE CaCtrl   IN 4                        ALIAS Control
    USE CaGroup  IN 5  ORDER TAG GROUPCODE   ALIAS AccsGroup
    USE CaPrintr IN 6  ORDER TAG PRINTER     ALIAS Printer
  ENDIF
  IF m.FileLocked
    * Do not Show any Message, but wait 2 Seconds
    = INKEY(2)
    IF LASTKEY() = 27
      DO SysClose_ WITH "Process Interrupted by User !"
    ENDIF
    m.TempLoopVar = m.TempLoopVar + 1
    * If the Files were locked for more than one minute
    IF m.TempLoopVar > 30
      DO SysClose_ WITH "Could Not Lock Necessary Files, Try Again !"
    ENDIF
  ELSE
    EXIT
  ENDIF
ENDDO
RELEASE m.TempLoopVar

* 'Browse Menu' Popups
DEFINE POPUP bPopup FROM 11,20 TO 22,60 IN SCREEN MARGIN SCROLL TITLE "[[ Browse Options ]]" ;
  COLOR SCHEME 10
DEFINE BAR 1  OF bPopup PROMPT "Search" SKIP FOR IsFreeze MESSAGE "Search a String"
DEFINE BAR 2  OF bPopup PROMPT "Goto  (Line Number)" SKIP FOR IsFreeze MESSAGE "Goto Line Number   (Use After Search)"
DEFINE BAR 3  OF bPopup PROMPT "\-"
DEFINE BAR 4  OF bPopup PROMPT "Print to a File" MESSAGE "Print this report to a file"
DEFINE BAR 5  OF bPopup PROMPT "Print to Printer" MESSAGE "Print this report from printer"
DEFINE BAR 6  OF bPopup PROMPT "\-"
DEFINE BAR 7  OF bPopup PROMPT "Horizontal Freeze" SKIP FOR IsFreeze MESSAGE "Freeze headings - Show them permanentaly"
DEFINE BAR 8  OF bPopup PROMPT "Vertical Freeze" SKIP FOR IsFreeze MESSAGE "Freeze columns - Show them permanently"
DEFINE BAR 9  OF bPopup PROMPT "Both Freeze" SKIP FOR IsFreeze MESSAGE "Freeze both headings and comulns"
DEFINE BAR 10 OF bPopup PROMPT "Clear Freeze" SKIP FOR .NOT. IsFreeze MESSAGE "Show full screen report - Normal report"
ON SELECTION POPUP bPopup DO bMenuSel_

* General Public Variables
PUBLIC m.CurrUserID, m.DefaultPrn
m.CurrUserID = SPACE(LEN(UserFile.USER_ID))
m.DefaultPrn = SPACE(LEN(UserFile.PRINTER))

* Logo
CLEAR
PRIVATE m.TempVar1, m.TempVar2, m.TempVar3, m.TempVar4, m.TempVar5
DO BigChars WITH 1, 5, " SAMLING|  Carpet| Inventory"

* Control File - First Time Job
SELECT Control
GO TOP
IF RECNO() > RECCOUNT()          && End of File
  IF (.NOT. FileLock("Control"))
    DO SysClose_ WITH "Could Not Lock Necessary Files, Try Again !"
  ENDIF
  APPEND BLANK
  FLUSH
  UNLOCK IN Control
ENDIF

* Access Group File - First Time Job
SELECT AccsGroup
GO TOP
IF RECNO() > RECCOUNT()       && End of File
  IF (.NOT. FileLock("AccsGroup"))
    DO SysClose_ WITH "Could Not Lock Necessary Files, Try Again !"
  ENDIF
  m.TempVar1 = ASC("A")
  DO WHILE m.TempVar1 <= ASC("Z")
    APPEND BLANK
    REPLACE GROUPCODE WITH CHR(m.TempVar1)
    m.TempVar1 = m.TempVar1 + 1
  ENDDO
  FLUSH
  UNLOCK IN AccsGroup
ENDIF

* System User File
SELECT UserFile
GO TOP
IF RECNO() > RECCOUNT()        && End of File
  IF (.NOT. FileLock("UserFile"))
    ?? CHR(7)
    WAIT WINDOW "Could Not Lock Necessary Files, Try Again !" TIMEOUT 3
  ENDIF
  m.TempVar1 = 1
  m.TempVar2 = ""
  m.TempVar3 = RECCOUNT() + 1
  m.TempVar4 = LEFT("SUPER" + SPACE(LEN(PASSWD)), LEN(PASSWD))
  m.TempVar4 = PwCoding(m.TempVar4, "E")
  APPEND BLANK
  REPLACE USER_ID WITH "SUPERVISOR", NAME WITH "System Supervisor", GROUP ;
    WITH "ABCDEFGHIJKLMNOPQRSTUVWXYZ", PASSWD WITH m.TempVar4
  FLUSH
  UNLOCK IN UserFile
ENDIF

* Password
DEFINE WINDOW PassTry FROM 19,43 TO 24,79 IN SCREEN PANEL NOCLOSE NOFLOAT ;
  NOGROW NOZOOM COLOR SCHEME 7
m.TempVar1 = 5

ACTIVATE WINDOW PassTry
@ 0,1 SAY "Chances Remain :"
@ 2,1 SAY "User  ID :"
@ 3,1 SAY "Password :"
SET CURSOR    ON
DO WHILE m.TempVar1 > 0
  @ 0,18 SAY LTRIM(STR(m.TempVar1))
  SELECT UserFile
  m.TempVar2 = SPACE(LEN(USER_ID))
  m.TempVar3 = SPACE(LEN(PASSWD))
  @ 2,12 GET m.TempVar2 PICTURE "@!"
  @ 3,12 GET m.TempVar3 WHEN .F.
  READ VALID ReadExit() TIMEOUT 60
  IF LASTKEY() = 27 .OR. (.NOT. SEEK(m.TempVar2, "UserFile"))
    m.TempVar1 = m.TempVar1 - 1
    LOOP
  ENDIF
  *
  m.TempVar3 = SpecialPW(3, 12, LEN(m.TempVar3), 0)
  *
  m.TempVar5 = PwCoding(m.TempVar3, "E")
  IF PASSWD = m.TempVar5
    m.DefaultPrn = UserFile.PRINTER
    EXIT
  ENDIF
  m.TempVar1 = m.TempVar1 - 1
ENDDO
RELEASE WINDOW PassTry
IF m.TempVar1 <= 0
  DO SysClose_ WITH "Incorrect ID/Password Entry !"
ENDIF
SET CURSOR    OFF
m.CurrUserID = m.TempVar2

* Remove 'Logo' WindowS
m.TempVar1 = 1
DO WHILE m.TempVar1 <= 100
  IF WEXIST("letter" + ALLTRIM(STR(m.TempVar1)))
    RELEASE WINDOW ("letter" + ALLTRIM(STR(m.TempVar1)))
  ENDIF
  m.TempVar1 = m.TempVar1 + 1
ENDDO
CLEAR
* Temporary Window for Showing all Menus promptly
DEFINE WINDOW TempWin_ FROM 0,0 TO 24,79 IN SCREEN NONE NOCLOSE NOFLOAT ;
  NOGROW NOZOOM COLOR SCHEME 1
ACTIVATE WINDOW TempWin_ TOP

* Menu Header
ACTIVATE SCREEN
@ 0,01  SAY "User: " + LEFT(m.CurrUserID + SPACE(10), 10)
@ 0,18  SAY CHR(179)
@ 0,20  SAY "Samling Carpet Inventory"
@ 0,45  SAY CHR(179)
@ 0,47  SAY LEFT(LEFT(CDOW(DATE()), 3) + ", " + DMY(DATE()) + SPACE(22), 22)
@ 0,70  SAY CHR(179)
@ 1,00  TO 1,WCOLS()
@ 1,18  SAY CHR(193)
@ 1,45  SAY CHR(193)
@ 1,70  SAY CHR(193)
@ 0,00  FILL TO 1,WCOLS() COLOR SCHEME 7
@ 0,20  SAY "Samling Carpet Inventory" COLOR B/G
FOR m.TempVar2 = 2 TO 23 STEP 1
  @ m.TempVar2,0 SAY REPLICATE(CHR(177), 80)
ENDFOR
RELEASE m.TempVar1, m.TempVar2, m.TempVar3, m.TempVar4, m.TempVar5

* Public Variables for Printing Purpose
PUBLIC m.PageBreak, m.PageLength, m.PageWidth, m.PrnCurLine, ;
  m.OutputDevice, PrintArray[30, 7], m.PrnInvMess, m.PageNumber, ;
  m.PrnUnqFile, m.prnLMargin, m.actLMargin
m.PageBreak  = .T.
m.PageLength = 58
m.PageWidth  = 60
m.PrnCurLine = 1
m.Outputdevice = "S"
m.PrnInvMess = ""
m.PageNumber = 1
m.PrnUnqFile = ""
m.prnLMargin = Control.LEFTMARGIN
m.actLMargin = 0

* Public Variable for Carpet-Inventory Search Option !!
PUBLIC m.psCarpetNo, m.psOrderNo, m.psCtrlNo, m.psOLNumber, m.psQuality, ;
  m.psDesign, m.psColour, m.psField, m.psCarpType, m.psSize, m.psSpclInst, ;
  m.psWashInst, m.psCardNo, m.psSupplier, m.psWashType, m.psComment, ;
  m.psQltComment, m.psOrdType, m.psSupOrdNo
STORE SPACE(150) TO m.psCardNo, m.psCarpetNo, m.psOrderNo, m.psCtrlNo, ;
  m.psOLNumber, m.psSupOrdNo
STORE SPACE(60) TO m.psQuality, m.psDesign, m.psColour, m.psField, ;
  m.psSize, m.psSupplier, m.psWashType
m.psOrdType    = " "
m.psCarpType   = " "
m.psComment    = SPACE(25)
m.psQltComment = SPACE(25)
m.psSpclInst   = SPACE(25)
m.psWashInst   = SPACE(25)

* Public Menu Variables
PUBLIC m.CurrScr__, m.MenuScr__, m.MenuRec__, m.ShowRec__
PUBLIC m.CurrMenuID, m.MenuScr_, m.MenuRec_

m.CurrScr__  = 1
m.MenuScr__  = "m.MenuScr_" + LTRIM(STR(m.CurrScr__))
m.MenuRec__  = "m.MenuRec_" + LTRIM(STR(m.CurrScr__))
&MenuRec__   = 0
m.ShowRec__  = .T.
SAVE SCREEN TO &MenuScr__
m.CurrMenuID  = "MAIN      "

DO UpdateTA WITH "System Started at " + TIME()
ON KEY LABEL CTRL+L   DO SystemLock
*

IF LEFT(m.Company_, 1) = "~"
  ?? CHR(7) + CHR(7)
  m.Company_  = RIGHT(m.Company_, LEN(m.Company_) - 1)
  WAIT WINDOW m.Company_ NOWAIT
ENDIF

DO WHILE .T.
  m.MenuScr__ = "m.MenuScr_" + LTRIM(STR(m.CurrScr__))
  m.MenuRec__ = "m.MenuRec_" + LTRIM(STR(m.CurrScr__))
  RESTORE SCREEN FROM &MenuScr__
  *
  * Since Company Could be Changed - so it is to be Shown !
  *
  @ 0,01  SAY "User: " + LEFT(m.CurrUserID + SPACE(10), 10) COLOR SCHEME 7
  @ 0,47  SAY LEFT(LEFT(CDOW(DATE()), 3) + ", " + DMY(DATE()) + SPACE(22), 22) COLOR SCHEME 7
  *
  SELECT MenuFile
  SEEK m.CurrMenuID
  PRIVATE m.MinRow, m.MaxRow, m.HeadRow, m.MenuHead
  m.MinRow  = ROW
  m.MaxRow  = ROW
  m.HeadRow = ROW
  m.MenuHead = "Menu Heading"
  DO WHILE CURR_MENU = m.CurrMenuID .AND. (.NOT. EOF())
    m.HeadRow = IIF(LEFT(DESC, 1) = ".", ROW, m.HeadRow)
    m.MenuHead = IIF(LEFT(DESC, 1) = ".", ALLTRIM(RIGHT(DESC, LEN(DESC)-1)), m.MenuHead)
    m.MaxRow  = MAX(ROW, m.MaxRow)
    m.MinRow  = MIN(ROW, m.MinRow)
    SKIP
  ENDDO
  SEEK m.CurrMenuID
  @ m.MinRow-1, COL-4   CLEAR TO m.MaxRow+1, COL+LEN(DESC)+2
  @ m.MinRow-1, COL-4   TO m.MaxRow+1, COL+LEN(DESC)+2  DOUBLE COLOR SCHEME 5
  @ m.HeadRow+1, COL-3  TO m.HeadRow+1, COL+LEN(DESC)+1 DOUBLE COLOR SCHEME 5
  @ m.HeadRow+2, COL-2  TO m.MaxRow, COL-2 COLOR SCHEME 5
  DO WHILE (.NOT. EOF()) .AND. CURR_MENU = m.CurrMenuID
    IF LEFT(DESC, 1) = "."
      m.MenuCol = COL + (LEN(DESC) - LEN(m.MenuHead))/2
      @ ROW,m.MenuCol SAY m.MenuHead     && COLOR SCHEME 5
      m.MenuRow = ROW
      SKIP
    ENDIF
    * Show 'Arrow' for Sub-Menus
    IF (.NOT. EMPTY(SUB_MENU))
      @ ROW,COL-1 SAY " " + DESC + " "
    ELSE
      @ ROW,COL-1 SAY " " + DESC + "  "
    ENDIF
    SKIP
  ENDDO
  SAVE SCREEN TO &MenuScr__
  SEEK m.CurrMenuID
  IF m.ShowRec__
    IF &MenuRec__ > 0
      GOTO &MenuRec__
    ENDIF
    m.ShowRec__ = .F.
  ENDIF
  * Release Temporary Window
  IF WEXIST("TempWin_")
    RELEASE WINDOW TempWin_
    SET CLOCK      TO 0,72
    SET CLOCK      ON
  ENDIF
  * Show Bottom Message
  DO MessDisplay WITH "Arrows (Up/Down)    [ENTER] to Select    PgUp/Home   PgDn/End    [ESC] to Return"

  * Menu Choices to the User
  DO WHILE .T.
    IF LEFT(DESC, 1) = "."
      SKIP
    ENDIF
    IF (.NOT. EMPTY(SUB_MENU))
      @ ROW,COL-1 SAY " " + DESC + " " COLOR SCHEME 7
    ELSE
      @ ROW,COL-1 SAY " " + DESC + "  " COLOR SCHEME 7
    ENDIF
    CLEAR GETS
    READ TIMEOUT m.InMenuWait
    m.__xxVar__ = LASTKEY()
    IF READKEY() = 20 .OR. READKEY() = 276
      DO SystemLock
      LOOP
    ENDIF
    *
    IF (.NOT. EMPTY(SUB_MENU))
      @ ROW,COL-1 SAY " " + DESC + " "
    ELSE
      @ ROW,COL-1 SAY " " + DESC + "  "
    ENDIF
    *
    DO CASE
      CASE m.__xxVar__ = 24       && DOWN ARROW
        SKIP
        IF EOF() .OR. CURR_MENU # m.CurrMenuID
          SEEK m.CurrMenuID
        ENDIF
      CASE m.__xxVar__ = 5        && UP ARROW
        SKIP -1
        IF BOF() .OR. CURR_MENU # m.CurrMenuID .OR. LEFT(DESC,1) = "."
          DO WHILE CURR_MENU = m.CurrMenuID .AND. (.NOT. EOF())
            SKIP
          ENDDO
          SKIP -1
        ENDIF
      CASE m.__xxVar__ = 18 .OR. m.__xxVar__ = 1     && PGUP or HOME
        SEEK m.CurrMenuID
      CASE m.__xxVar__ = 3 .OR. m.__xxVar__ = 6      && PGDN or END
        DO WHILE CURR_MENU = m.CurrMenuID .AND. (.NOT. EOF())
          SKIP
        ENDDO
        SKIP -1
      CASE m.__xxVar__ = 13           && SELECT
        * Check for Validity of the User
        IF (.NOT. SEEK(m.CurrUserID, "UserFile"))
          DO SysClose_ WITH "Your User ID have been Deleted from the System. Contact SUPERVISOR !!"
        ENDIF
        * The Rest
        IF SEEK(m.CurrUserID, "UserFile") .AND. (.NOT. EMPTY(GROUP))
          PRIVATE m.UserGroup_, m.Counter_, m.Allowed_
          m.UserGroup_ = ALLTRIM(UserFile.GROUP)
          m.Counter_   = 1
          m.Allowed_   = .F.
          DO WHILE m.Counter_ <= LEN(m.UserGroup_)
            IF SUBSTR(m.UserGroup_, m.Counter_, 1) $ GROUP
              m.Allowed_ = .T.
              EXIT
            ENDIF
            m.Counter_ = m.Counter_ + 1
          ENDDO
          IF (.NOT. m.Allowed_)
            ?? CHR(7) + CHR(7)
            DO ShowMess  WITH "You DO NOT have access to this option !", ;
              "(Please Contact your Supervisor.)"
            RELEASE m.UserGroup_, m.Counter_, m.Allowed_
            LOOP
          ENDIF
          RELEASE m.UserGroup_, m.Counter_, m.Allowed_
        ENDIF
        @ m.MenuRow,m.MenuCol SAY m.MenuHead
        @ m.MinRow-1,COL-4  TO m.MaxRow+1,COL+LEN(DESC)+2 DOUBLE
        @ m.HeadRow+1,COL-3 TO m.HeadRow+1,COL+LEN(DESC)+1 DOUBLE
        @ m.HeadRow+2, COL-2  TO m.MaxRow, COL-2
        IF (.NOT. EMPTY(SUB_MENU))
          @ ROW,COL-1 SAY " " + DESC + " " COLOR SCHEME IIF(ISCOLOR(), 6, 7)
        ELSE
          @ ROW,COL-1 SAY " " + DESC + "  " COLOR SCHEME IIF(ISCOLOR(), 6, 7)
        ENDIF
        IF (.NOT. EMPTY(SUB_MENU))
          m.CurrMenuID = SUB_MENU
          m.MenuHead   = ALLTRIM(DESC)
          m.MenuRec__  = "m.MenuRec_" + LTRIM(STR(m.CurrScr__))
          &MenuRec__   = RECNO()
          m.CurrScr__  = m.CurrScr__ + 1
          m.MenuScr__  = "m.MenuScr_" + LTRIM(STR(m.CurrScr__))
          SAVE SCREEN TO &MenuScr__
          EXIT
        ENDIF
        m.__xxVar__  = ALLTRIM(PROGRAM)
        m.MenuRec__  = "m.MenuRec_" + LTRIM(STR(m.CurrScr__))
        &MenuRec__   = RECNO()
        m.MenuScr__  = "m.MenuScr_" + LTRIM(STR(m.CurrScr__))
        SAVE SCREEN TO &MenuScr__
        IF (.NOT. EMPTY(m.__xxVar__))
          DO MessDisplay  WITH " "          && to Clear Last Line
          SET CURSOR    ON
          UNLOCK ALL
          DO &__xxVar__
          SET CURSOR    OFF
        ELSE
          ?? CHR(7)
          WAIT WINDOW "Program/Module not Made yet !" TIMEOUT 2
        ENDIF
        m.ShowRec__ = .T.
        EXIT
      CASE m.__xxVar__ = 27        && EXIT
        m.CurrScr__ = m.CurrScr__ - IIF(m.CurrScr__ > 1, 1, 0)
        IF EMPTY(RET_MENU)
          @ m.MenuRow,m.MenuCol SAY m.MenuHead
          @ m.MinRow-1,COL-4  TO m.MaxRow+1,COL+LEN(DESC)+2 DOUBLE
          @ m.HeadRow+1,COL-3 TO m.HeadRow+1,COL+LEN(DESC)+1 DOUBLE
          @ m.HeadRow+2, COL-2  TO m.MaxRow, COL-2
          IF Confirm_("Are you Sure to Exit ?", "Yes", "Exit to DOS", ;
            "No", "Do not Exit") = "Y"
            * Delete Trail Audit Record for More than 30 Days old !
            SELECT TrailAudit
            IF FLOCK()
              DELETE ALL FOR DATE <= DATE() - 30
              FLUSH
            ENDIF
            UNLOCK ALL
            * Do not 'CLOSE DATABASE' before 'SysClose_'
            DO SysClose_ WITH "Have a Nice Time " + ALLTRIM(m.CurrUserID) + " !"
            * CLOSE DATABASE
            * DEACTIVATE WINDOW ALL
            * CLOSE ALL
            * CLEAR ALL
            * ON KEY
            * SET TALK     ON
            * SET CLOCK    TO
            * SET ESCAPE   ON
            * SET HELP     ON
            * SET DELETED  OFF
            * SET EXCLUSIV ON
            * SET RESOURCE ON
            * SET CURSOR   ON
            * CLEAR
            * RETURN
          ENDIF
          @ m.MenuRow,m.MenuCol SAY m.MenuHead      && COLOR SCHEME 5
          @ m.MinRow-1,COL-4  TO m.MaxRow+1,COL+LEN(DESC)+2 DOUBLE COLOR SCHEME 5
          @ m.HeadRow+1,COL-3 TO m.HeadRow+1,COL+LEN(DESC)+1 DOUBLE COLOR SCHEME 5
          @ m.HeadRow+2, COL-2  TO m.MaxRow, COL-2 COLOR SCHEME 5
          LOOP
        ENDIF
        m.CurrMenuID = RET_MENU
        SEEK m.CurrMenuID
        IF EMPTY(RET_MENU)
          m.MenuHead = "Main Menu"
        ELSE
          m.__xxVar__ = RET_MENU
          m.__xxVra__ = CURR_MENU
          LOCATE FOR CURR_MENU = m.__xxVar__ .AND. SUB_MENU = m.__xxVra__
          m.MenuHead = ALLTRIM(DESC)
        ENDIF
        m.ShowRec__  = .T.
        EXIT
    ENDCASE
  ENDDO
ENDDO

* Eof()
