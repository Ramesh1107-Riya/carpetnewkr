* Bop()                         CaTool.PRG
*
* A set of Carpet Inventory Utilities
*
* System Error Handeling Procedure
PROCEDURE SystemErr
PARAMETER m.ErrCode, m.ErrMess, m.ErrLineNo, m.ErrCommand, m.ErrModule
PRIVATE m.ErrTmpVar, m.ErrTmpVar1, m.ErrTmpVar2
* Normal Errors - Program should not hang here.
DO CASE
  CASE m.ErrCode =3  .OR.  m.ErrCode =110
   	  outmsgline="Error Message: "+m.ErrMess+CHR(13)+;
  	  "Program Name = "+m.ErrModule+CHR(13)+"Syntax is  :"+ LEFT(m.ErrCommand,150)+CHR(13)
	   WAIT WINDOW outmsgline TIMEOUT 3 && All versions can use this syntax.
      RETURN
  CASE m.ErrCode =108            && File is in use by another  (m.ErrCode = 108  ) original code change done by ramesh
    IF (.NOT. m.FileLocked)
      ?? CHR(7) + CHR(7)
      WAIT WINDOW "Necessary Files are in Use by Others ! Try Later .." TIMEOUT 2
    ENDIF
    m.FileLocked = .T.
    RETURN
  CASE m.ErrCode = 1705           && File Access Denied
    m.FileLocked = .T.
    RETURN
  CASE m.ErrCode = 125            && Printer Not Ready - After PRINTSTATUS()
    ON ESCAPE
    SET ESCAPE     OFF
    SET PRINTER    OFF
    SET PRINTER    TO
    SET CONSOLE    ON
    ?? CHR(7) + CHR(7)
    WAIT WINDOW "Printer Error ! Returning to Menus !!" TIMEOUT 2
    UNLOCK ALL
    DO CloseFile
    DEACTIVATE WINDOW  ALL
    RETURN TO MASTER
ENDCASE
* Other System Errors - Show it on the screen and Quit to DOS
DO DisableKey
ON KEY LABEL ENTER
ON KEY LABEL ESC
ON  ESCAPE
SET ESCAPE   OFF
SET PRINTER  TO
SET PRINTER  OFF
SET CONSOLE  ON
SET CLOCK    OFF
ON  ERROR    ?? CHR(00)
* CLOSE DATABASE              && to Record Closing Time by 'SysClose_'
m.ErrTmpVar2 = ""
FOR m.ErrTmpVar1 = 1 TO 32
  IF EMPTY(PROGRAM(m.ErrTmpVar1))
    EXIT
  ENDIF
  IF m.ErrTmpVar2 # "SYSTEMERR"
    m.ErrTmpVar2 = m.ErrTmpVar2 + "-" + PROGRAM(m.ErrTmpVar1)
  ENDIF
ENDFOR
m.ErrModule = m.ErrTmpVar2
*WAIT CLEAR && astrik by ramesh
SET BELL      TO 500, 15
DEFINE WINDOW ErrWindow FROM 0,0 TO 24,79 IN SCREEN PANEL NOCLOSE NOFLOAT ;
  NOGROW NOZOOM COLOR SCHEME 5          && IIF(ISCOLOR(), 5, 1)
ACTIVATE WINDOW ErrWindow NOSHOW TOP
PRIVATE m.GuideUser1, m.GuideUser2
m.GuideUser1 = "E R R O R     O C C U R E D"
m.GuideUser2 = "Please note down the above message and call your consultant !"
?? CHR(7) + CHR(7)               && Double Beep
@ 1,(WCOLS()-LEN(m.GuideUser1))/2 SAY m.GuideUser1
@ 5,2  SAY "         Error Code : " + ALLTRIM(STR(m.ErrCode))
@ 7,2  SAY "            Message : " + m.ErrMess
@ 9,2  SAY "        Line Number : " + ALLTRIM(STR(m.ErrLineNo))
@ 11,2 SAY "Program/Module Name : " + m.ErrModule
@ 13,2 SAY "     FoxPro Command : " + LEFT(m.ErrCommand, 150) &&254 is original value
@ 18,1  SAY m.GuideUser2
@ 21,5  SAY "Press [ESC] to Continue"
SHOW WINDOW ErrWindow
DO WHILE LASTKEY() # 27
  m.TempKey = INKEY(0)
ENDDO
DO SysClose_ WITH "On Occurance of an Error !"

* End of Error Handle Procedure


* System Closure Procedure
PROCEDURE SysClose_
PARAMETER m.CloseMess_
DO DisableKey
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
DEACTIVATE MENU  ALL
DEACTIVATE POPUP ALL
*IF USED("TrailAudit")
*  DO UpdateTA WITH "System Closed at " + TIME() + "  " + m.CloseMess_
*ENDIF
CLOSE DATABASES
CLEAR WINDOWS
CLEAR GETS
* CLEAR ALL                  && Because it Clears the Variable 'CloseMess_'
CLOSE ALL
CLEAR READ ALL
ACTIVATE SCREEN
CLEAR
*

ACTIVATE SCREEN
@ 18,(80-LEN(m.CloseMess_))/2 SAY m.CloseMess_ COLOR SCHEME 1
m.TempVar = INKEY(3)
*CLEAR ALL
CLEAR
*QUIT
RETURN

* EoP()

* Procedure to Disable Function Keys
*
PROCEDURE DisableKey
ON KEY LABEL F1        KEYBOARD CHR(00)
ON KEY LABEL F2        KEYBOARD CHR(00)
ON KEY LABEL F3        KEYBOARD CHR(00)
ON KEY LABEL F4        KEYBOARD CHR(00)
ON KEY LABEL F5        KEYBOARD CHR(00)
ON KEY LABEL F6        KEYBOARD CHR(00)
ON KEY LABEL F7        KEYBOARD CHR(00)
ON KEY LABEL F8        KEYBOARD CHR(00)
ON KEY LABEL F9        KEYBOARD CHR(00)
ON KEY LABEL F10       KEYBOARD CHR(00)
ON KEY LABEL F11       KEYBOARD CHR(00)
* ON KEY LABEL F12       KEYBOARD CHR(00)
SET FUNCTION F12  TO   CHR(25) + ';'
ON KEY LABEL CTRL-F1   KEYBOARD CHR(00)
ON KEY LABEL CTRL-F2   KEYBOARD CHR(00)
ON KEY LABEL CTRL-F3   KEYBOARD CHR(00)
ON KEY LABEL CTRL-F4   KEYBOARD CHR(00)
ON KEY LABEL CTRL-F5   KEYBOARD CHR(00)
ON KEY LABEL CTRL-F6   KEYBOARD CHR(00)
ON KEY LABEL CTRL-F7   KEYBOARD CHR(00)
ON KEY LABEL CTRL-F8   KEYBOARD CHR(00)
ON KEY LABEL CTRL-F9   KEYBOARD CHR(00)
ON KEY LABEL CTRL-F10  KEYBOARD CHR(00)
ON KEY LABEL CTRL-F11  KEYBOARD CHR(00)
ON KEY LABEL CTRL-F12  KEYBOARD CHR(00)
ON KEY LABEL ALT-F1    KEYBOARD CHR(00)
ON KEY LABEL ALT-F2    KEYBOARD CHR(00)
ON KEY LABEL ALT-F3    KEYBOARD CHR(00)
ON KEY LABEL ALT-F4    KEYBOARD CHR(00)
ON KEY LABEL ALT-F5    KEYBOARD CHR(00)
ON KEY LABEL ALT-F6    KEYBOARD CHR(00)
ON KEY LABEL ALT-F7    KEYBOARD CHR(00)
ON KEY LABEL ALT-F8    KEYBOARD CHR(00)
ON KEY LABEL ALT-F9    KEYBOARD CHR(00)
ON KEY LABEL ALT-F10   KEYBOARD CHR(00)
ON KEY LABEL ALT-F11   KEYBOARD CHR(00)
ON KEY LABEL ALT-F12   KEYBOARD CHR(00)
ON KEY LABEL SHIFT-F1  KEYBOARD CHR(00)
ON KEY LABEL SHIFT-F2  KEYBOARD CHR(00)
ON KEY LABEL SHIFT-F3  KEYBOARD CHR(00)
ON KEY LABEL SHIFT-F4  KEYBOARD CHR(00)
ON KEY LABEL SHIFT-F5  KEYBOARD CHR(00)
ON KEY LABEL SHIFT-F6  KEYBOARD CHR(00)
ON KEY LABEL SHIFT-F7  KEYBOARD CHR(00)
ON KEY LABEL SHIFT-F8  KEYBOARD CHR(00)
ON KEY LABEL SHIFT-F9  KEYBOARD CHR(00)
ON KEY LABEL SHIFT-F10 KEYBOARD CHR(00)
ON KEY LABEL SHIFT-F11 KEYBOARD CHR(00)
ON KEY LABEL SHIFT-F12 KEYBOARD CHR(00)
RETURN


* Procedure to Set colour of Screen/Monitor as per the monitor type.
*
PROCEDURE SetColour
PARAMETER m.SetToColor
  SET COLOR OF SCHEME 1 TO ;
    W+/B, W+/BG, GR+/B, GR+/B, GR+/B, W+/GR, GR+/R, N+/N, GR+/B, R+/B, +
  SET COLOR OF SCHEME 2 TO ;
    GR+/B, GR+/B, N/W, B/W, GR+/B, N/BG, W+/W, N+/N, B/W, W/N, +
  SET COLOR OF SCHEME 3 TO ;
    BG/W, N/W, BG/N, BG/N, GR+/B, N/BG, W+/W, N+/N, BG/N, BG/N, +
  SET COLOR OF SCHEME 4 TO ;
    BG/W, N/W, N/W, B/W, GR+/B, N/BG, W+/W, N+/N, B/W, W/N, +
  SET COLOR OF SCHEME 5 TO ;
    W+/RB, W+/BG, W+/RB, W+/RB, GR+/B, W+/B, GR+/RB, N+/N, W+/RB, W/RB, +
  SET COLOR OF SCHEME 6 TO ;
    W+/BG, W+/BG, W+/RB, W+/RB, GR+/B, W+/B, BG+/BG, N+/N, W+/RB, W/RB, +
  SET COLOR OF SCHEME 7 TO ;
    GR+/R, W+/W, GR+/R, W+/R, GR+/B, W+/N, GR+/R, N+/N, W+/R, W/R, +
  SET COLOR OF SCHEME 8 TO ;
    W+/BG, W+/W, GR+/W, GR+/W, N+/W, W+/GR, BG+/BG, N+/N, B/BG, W/BG, +
  SET COLOR OF SCHEME 9 TO ;
    W+/BG, W+/BG, B/BG, GR+/W, GR+/B, W+/GR, W+/B, N+/N, GR+/W, N+/W, +
  SET COLOR OF SCHEME 10 TO ;
    W+/BG, GR+/B, GR+/W, GR+/W, N+/W, GR+/GR, W+/B, N+/N, GR+/W, N+/W, +
* We use only scheme 1 to 10, the rest is useless - so copy the scheme 10 to
* all the rest schemes
RETURN


* Function to Lock a Database File in Multiuser Environment. Maximum 25
* Database files (Alias Name) can be passed into the Function to lock them
* at a time. If any of the file couldnot be locked, it will return a FALSE
* value and UNLOCK the whole locked databases. But if all the databases is
* locked then the user has to issue UNLOCK ALL command from the calling
* program in order to release the lock.
*
* When the system tries to lock a database which is being locked by another
* user, it displays a message on the screen and permits user to press ESC
* if he/she does not wish to lock it.
*
* Input   : Upto 25 Databases that are needed to be Locked
*
* Output  : Logical TRUE or FALSE depending upton success/failure to lock
*           the passed databased.
*

FUNCTION FileLock
PARAMETER m.flAlias1, m.flAlias2, m.flAlias3, m.flAlias4, m.flAlias5, ;
  m.flAlias6, m.flAlias7, m.flAlias8, m.flAlias9, m.flAlias10, m.flAlias11, ;
  m.flAlias12, m.flAlias13, m.flAlias14, m.flAlias15, m.flAlias16, ;
  m.flAlias17, m.flAlias18, m.flAlias19, m.flAlias20, m.flAlias21, m.flAlias22, ;
  m.flAlias23, m.flAlias24, m.flAlias25
IF PARAMETERS() <= 0
  RETURN .F.
ENDIF
IF SET("REPROCESS") <= 1 .OR. SET("REPROCESS") >= 5
  SET REPROCESS TO   3 SECONDS
ENDIF
PRIVATE m.flCounter, m.flCurFile, m.flEscPress
m.flCounter  = 1
m.flEscPress = .F.
SET ESCAPE    ON
ON  ESCAPE    m.flEscPress = .T.
DO WHILE m.flCounter <= 25 .AND. (.NOT. m.flEscPress)
  m.flCurFile = "m.flAlias" + ALLTRIM(STR(m.flCounter))
  IF EMPTY(&flCurFile)
    EXIT
  ENDIF
  m.flCounter = m.flCounter + 1
ENDDO
ON  ESCAPE
SET ESCAPE     OFF
IF m.flEscPress
  ?? CHR(7)
  WAIT WINDOW "Could not Lock files ! User Cancelled the Locking Operation .." TIMEOUT 2
  UNLOCK ALL
  RETURN .F.
ENDIF
RETURN .T.


* Ask Confirmation by displaying user-sent parameters
*

FUNCTION Confirm_
PARAMETER m.cHeading_, m.cPrmpt1_, m.cMessPrm1_, m.cPrmpt2_, m.cMessPrm2_
SAVE SCREEN TO ConfirmScr_
PRIVATE m.cChoice_, m.cMaxLen, m.ConfColor_
m.cMaxLen = MAX(LEN(m.cPrmpt1_), LEN(m.cPrmpt2_), LEN(m.cHeading_)) + 7
DEFINE WINDOW ConfWin_ FROM 18,40-(m.cMaxLen/2) TO 23,40+(m.cMaxLen/2) ;
  IN SCREEN DOUBLE NOFLOAT NOGROW NOZOOM COLOR SCHEME 1
m.cPrmpt1_ = m.cPrmpt1_ + SPACE(m.cMaxLen - LEN(m.cPrmpt1_) - 7)
m.cPrmpt2_ = m.cPrmpt2_ + SPACE(m.cMaxLen - LEN(m.cPrmpt2_) - 7)
ACTIVATE WINDOW ConfWin_ NOSHOW
CLEAR
m.ConfColor_ = IIF(ISCOLOR(), "GR+/B", "W+/N")
@ 1,0 TO 1,WCOLS() DOUBLE COLOR (m.ConfColor_)
@ 2,2 TO 3,2 COLOR (m.ConfColor_)
m.ConfColor_ = IIF(ISCOLOR(), "W+/B", "W+/N")
@ 0,(WCOLS()-LEN(m.cHeading_))/2 SAY m.cHeading_ COLOR (m.ConfColor_)
SHOW WINDOW ConfWin_
@ 2,4 PROMPT " " + m.cPrmpt1_ MESSAGE m.cMessPrm1_
@ 3,4 PROMPT " " + m.cPrmpt2_ MESSAGE m.cMessPrm2_
MENU TO m.cChoice_
RELEASE WINDOW ConfWin_
RESTORE SCREEN FROM ConfirmScr_
IF m.cChoice_ > 0
  RETURN IIF(m.cChoice_ = 1, LEFT(m.cPrmpt1_, 1), LEFT(m.cPrmpt2_, 1))
ENDIF
RETURN "*"

* EoF()

* Function to ask a Simple Yes/No question and return the TRUE or FALSE !

FUNCTION YesNo
PARAMETER m.ynHeading, m.ynDefault, m.ynAddText, m.ynBeeps
PRIVATE m.ynString, m.ynLastKey, m.ynSetClr
m.ynSetClr = IIF(ISCOLOR(), "SCHEME 5", "N/W, N/W")
DEFINE WINDOW ynWindow FROM 25,5 TO 25,75 IN SCREEN NONE NOCLOSE NOFLOAT ;
  NOGROW NOZOOM COLOR &ynSetClr
m.ynAddText = IIF(EMPTY(m.ynAddText), "", ALLTRIM(m.ynAddText) + " ")
m.ynBeeps   = IIF(TYPE("m.ynBeeps") $ "NF", ABS(m.ynBeeps), 0)
m.ynHeading = m.ynAddText + m.ynHeading + " ? (Y/N):"
m.ynHeading = RIGHT(m.ynHeading, 65)
m.ynDefault = IIF(EMPTY(m.ynDefault), " ", UPPER(m.ynDefault))
ACTIVATE WINDOW ynWindow TOP
IF m.ynBeeps > 0
  SET BELL TO  1000, 5
  ?? REPLICATE(CHR(7), m.ynBeeps)
  SET BELL TO  250, 4
ENDIF
@ 0,0 SAY m.ynHeading Font "Ariel",9 Style "B" 
@ 0,LEN(m.ynHeading)+1 GET m.ynDefault PICTURE "!" Font "Ariel",9 Style "B"  MESSAGE "Enter Y/N or ESC" ;
  VALID m.ynDefault $ "YN" ERROR "Invalid ! Please [Y]es or [N]o !!"
READ VALID ReadExit() .AND. EnterF12()
m.ynLastKey  = LASTKEY()
RELEASE WINDOWS ynWindow
IF m.ynLastKey = 27
  RETURN .F.
ENDIF
RETURN (m.ynDefault = "Y")

* EoF()


* Function to Ask User Defined Yes/No with Manual Entered Parameter !!

FUNCTION UdfYesNo
PARAMETER m.uynHeader, m.uynOption, m.uynDefault, m.uynBeeps
IF EMPTY(m.uynOption)
  RETURN "*"
ENDIF
PRIVATE m.uynScrMess, m.uynErrMess, m.uynF12Key, m.uynScreen, m.uynSetClr
PRIVATE m.uynVar1, m.uynVar2, m.uynVar3, m.uynLastWin
m.uynF12Key = ON("KEY", "F12")
ON KEY LABEL F12   KEYBOARD CHR(00)
m.uynSetClr = IIF(ISCOLOR(), "SCHEME 5", "N/W, N/W")
DEFINE WINDOW uynWindow FROM 25,0 TO 25,79 IN SCREEN NONE NOCLOSE NOFLOAT ;
  NOGROW NOZOOM COLOR &uynSetClr
IF TYPE("m.uynDefault") = "C"
  m.uynDefault = IIF(LEFT(m.uynDefault, 1) $ m.uynOption, LEFT(m.uynDefault, 1), " ")
ELSE
  m.uynDefault = " "
ENDIF
* '(', '/' and ')' are to be added in Header as long as the "options" are
* required.
m.uynHeader = ALLTRIM(m.uynHeader) + " ("
m.uynVar2   = ""
FOR m.uynVar1 = 1 TO LEN(m.uynOption)
  m.uynHeader = m.uynHeader + SUBSTR(m.uynOption, m.uynVar1, 1) + "/"
  m.uynVar2   = m.uynVar2 + SUBSTR(m.uynOption, m.uynVar1, 1) + ", "
ENDFOR
m.uynHeader  = LEFT(m.uynHeader, LEN(m.uynHeader) - 1) + ") :"
m.uynHeader  = RIGHT(m.uynHeader, 77)
*
m.uynVar2    = LEFT(m.uynVar2, LEN(m.uynVar2) - 2) + " or ESC"
m.uynScrMess = "Please Enter " + m.uynVar2
m.uynErrMess = "Invalid Choice ! " + m.uynVar2
*
m.uynBeeps   = IIF(TYPE("m.uynBeeps") $ "NF", ABS(m.uynBeeps), 0)
ACTIVATE WINDOW uynWindow TOP
IF m.uynBeeps > 0
  SET BELL TO  1000, 5
  ?? REPLICATE(CHR(7), m.uynBeeps)
  SET BELL TO  250, 4
ENDIF
@ 0,0 SAY m.uynHeader Font "Ariel",10 Style "B"
DO WHILE .T.
  @ 0,LEN(m.uynHeader)+1 GET m.uynDefault PICTURE "!" Font "Ariel",9 Style "B" MESSAGE m.uynScrMess ;
    VALID m.uynDefault $ m.uynOption ERROR m.uynErrMess
  READ VALID EnterF12(1)
  m.uynVar1  = LASTKEY()
  * Do not allow PGUP/UP/LEFT/RIGHT Arrow Keys
  IF m.uynVar1 = 18 .OR. m.uynVar1 = 5 .OR. m.uynVar1 = 19 .OR. m.uynVar1 = 4
    ?? CHR(7)           && with BELL
    LOOP
  ENDIF
  EXIT
ENDDO
RELEASE WINDOWS uynWindow
ON KEY LABEL F12   &uynF12Key
IF m.uynVar1 = 27
  RETURN "*"
ENDIF
RETURN m.uynDefault

* EoF()

* Function to Display help (list) fro Database File if the user leaves the
* input variable empty or invalid. It sets the record pointer to the half
* input variable if it exists in the data file, otheriwse to the top of the
* file. Previously opened data files, index set and record pointer is not
* affected by this program. All fields are displayed in READ ONLY mode. The
* reading variable name is assumes as 'MEMORY' variable - and if it is not
* passed as 'm.', program will automatically add it. User can Pass some
* special fields - like Calculated Field etc. from the file. If No field is
* passed - it will always return a FALSE value.
*
* Input   : 1.  NAME of the current input field.
*           2.  Flag for Insert Mode - If it is True, program will always
*               pass a TRUE value.
*           3.  Alias name of Database to be used for display operation.
*           4.  Searching Order Name - It will Set Index to this Order for
*               displaying/listing.
*           5.  Title of the Help/List to be Displayed in the top of the
*               list. (different languages - will be processed here)
*           5.  Information of Field 1 to be Displayed - Field Name, Header
*               Text and Picture Format.
*           6.  Information of Field 2 to be Displayed - Field Name, Header
*               Text and Picture Format
*           7.  Information of Field 3 to be Displayed - Field Name, Header
*               Text and Picture Format
*           8.  FOR Condition - It will filter necessary records from the
*               file to show as per user's requirement.
*
* Output  : 1.  If user selects a choice pressing ENTER, the current value
*               will be returned. But if the file is empty, it will be like
*               pressing ESC and the same old value will be returned.
*           2.  If user ESCAPEs in the List/Help, the value of the input
*               variable remains same.
FUNCTION ShowList
PARAMETERS m.slVarName, m.slInsMode, m.slAlias, m.slSearchIn, m.slShowOrdr, ;
  m.slRetField, m.slTitle, m.slField1, m.slHeader1, m.slPict1, m.slField2, ;
  m.slHeader2, m.slPict2, m.slField3, m.slheader3, m.slPict3, m.slForCond
* If exited by any Invalid Key, Do not perform anything
IF LASTKEY() = 18 .OR. LASTKEY() = 19 .OR. LASTKEY() = 5 .OR. LASTKEY() = 15
  RETURN .T.
ENDIF
* Also if it is Exited by Page-Down (it will lead to another record afterwards),
* do not allow it - but showing a message!
IF LASTKEY() = 3
  ?? CHR(7)
  WAIT WINDOW "Please Press [F12] instead of [Page-Down] Key for List !" TIMEOUT 1
  RETURN .F.
ENDIF
m.slVarName = IIF(LOWER(LEFT(m.slVarName, 2)) # "m.", "m.", "") + m.slVarName
IF m.slInsMode .AND. (.NOT. EMPTY(&slVarName))
? m.slInsMode 
?&slVarName
  RETURN .T.
ENDIF

* SEEK is right here because index is in CODE now, later it can be in any
* field passed in the parameter.
* SKS: Always check the value in the "Index" key <- 14.10.1999, SKS.
PRIVATE m.slScreen, m.slCurAlias, m.slCurRecNo, m.slPrvRecNo, m.slPrvOrder,;
  m.slBrowCond, m.slLastKey, m.slTempVar, m.slNeededLen, m.sltVar1, m.sltVar2, ;
  m.sltVar3, m.sltVar4, m.sltxxxyyy
PRIVATE m.slTempVar
*
m.slCurAlias = ALIAS()
m.slCurRecNo = RECNO()
SELECT (m.slAlias)
m.slPrvRecNo = RECNO()
m.slPrvOrder = ORDER()
SET ORDER TO    &slSearchIn     && Index Key where it should be Searched !
*
? m.slInsMode 
?&slVarName
?m.slAlias
IF SEEK(&slVarName, m.slAlias)
  * Check for FOR Condition
  IF (.NOT. EMPTY(m.slForCond))
    SELECT (m.slAlias)
    m.slTempVar  = RECNO()
    IF &slForCond
      IF RECCOUNT() <= m.slTempVar
        GOTO m.slTempVar
      ENDIF
      IF (.NOT. EMPTY(m.slCurAlias))
        SELECT (m.slCurAlias)
        IF m.slCurRecNo <= RECCOUNT()
          GOTO m.slCurRecNo
        ENDIF
      ENDIF
      RETURN .T.
    ENDIF
    IF RECCOUNT() <= m.slTempVar
      GOTO m.slTempVar
    ENDIF
 
 ELSE
    SELECT (m.slAlias)
    SET ORDER TO (m.slPrvOrder)
    IF m.slPrvRecNo <= RECCOUNT()
      GOTO m.slPrvRecNo
    ENDIF
    IF (.NOT. EMPTY(m.slCurAlias))
      SELECT (m.slCurAlias)
      IF m.slCurRecNo <= RECCOUNT()
        GOTO m.slCurRecNo
      ENDIF
    ENDIF
    RETURN .T.
  ENDIF
ENDIF
*
*
IF EMPTY(m.slField1) 
 RETURN .F.
ENDIF
*
SAVE SCREEN TO m.slScreen
m.slNeededLen= 0
m.slHeader1  = IIF(EMPTY(m.slHeader1), "", m.slHeader1)
m.slHeader2  = IIF(EMPTY(m.slHeader2), "", m.slHeader2)
m.slHeader3  = IIF(EMPTY(m.slHeader3), "", m.slHeader3)
IF EMPTY(m.slPict1)
  m.slBrowCond = m.slField1 + ":H='" + m.slHeader1 + "':R"
ELSE
  m.slBrowCond = m.slField1 + ":H='" + m.slHeader1 + "':P='" + m.slPict1 + "':R"
ENDIF
IF (.NOT. EMPTY(m.slField2))
  IF EMPTY(m.slPict2)
    m.slBrowCond = m.slBrowCond + ", " + m.slField2 + ":H='" + m.slHeader2 + "':R"
  ELSE
    m.slBrowCond = m.slBrowCond + ", " + m.slField2 + ":H='" + m.slHeader2 + ;
      "':P='" + m.slPict2 + "':R"
  ENDIF
  IF (.NOT. EMPTY(m.slField3))
    IF EMPTY(m.slPict3)
      m.slBrowCond = m.slBrowCond + ", " + m.slField3 + ":H='" + m.slHeader3 + "':R"
    ELSE
      m.slBrowCond = m.slBrowCond + ", " + m.slField3 + ":H='" + m.slHeader3 + ;
        "':P='" + m.slPict3 + "':R"
    ENDIF
  ENDIF
ENDIF
*
* SKS: Calculate the Length of the Needed Fields to show taking "Header" or
* "Value", whichever is greater, plus two col. as separator.
*
m.slNeededLen = 0
m.sltxxxyyy   = LEN(m.slHeader1)
IF "=" $ m.slField1
  m.sltVar1 = AT("=", m.slField1)
  m.sltVar2 = RIGHT(m.slField1, LEN(m.slField1) - m.sltVar1)
  IF ":" $ RIGHT(m.sltVar2, 3) .AND. RIGHT(m.sltVar2, 1) $ "0123456789"
    m.sltVar3 = RIGHT(m.sltVar2, 2)
    IF ":" $ m.sltVar3
      m.sltVar3 = RIGHT(m.sltVar3, 1)
    ENDIF
    IF VAL(m.sltVar3) > 0
      m.sltVar1   = SPACE(VAL(m.sltVar3))
      m.sltxxxyyy = VAL(m.sltVar3)
    ENDIF
  ELSE
    m.sltVar1 = EVAL(m.sltVar2)
  ENDIF
ELSE
  m.sltVar2  = m.slField1
  IF ":" $ RIGHT(m.sltVar2, 3) .AND. RIGHT(m.sltVar2, 1) $ "0123456789"
    m.sltVar3 = RIGHT(m.sltVar2, 2)
    IF ":" $ m.sltVar3
      m.sltVar3 = RIGHT(m.sltVar3, 1)
    ENDIF
    IF VAL(m.sltVar3) > 0
      m.sltVar1   = SPACE(VAL(m.sltVar3))
      m.sltxxxyyy = VAL(m.sltVar3)
    ENDIF
  ELSE
    m.sltVar1 = EVAL(m.sltVar2)
  ENDIF
ENDIF
DO CASE
  CASE TYPE("m.sltVar1") = "C"
    m.sltVar2 = LEN(m.sltVar1)
  CASE TYPE("m.sltVar1") $ "NF"
    m.sltVar2 = IIF(EMPTY(m.slPict1), 7, LEN(m.slPict1))
  CASE TYPE("m.sltVar1") = "D"
    m.sltVar2 = 10
OTHERWISE
  m.sltVar2 = IIF(EMPTY(m.slPict1), 7, LEN(m.slPict1))
ENDCASE
m.slNeededLen = m.slNeededLen + MAX(m.sltVar2, m.sltxxxyyy)
*
IF (.NOT. EMPTY(m.slField2))
  m.sltxxxyyy = LEN(m.slHeader2)
  IF "=" $ m.slField2
    m.sltVar1 = AT("=", m.slField2)
    m.sltVar2 = RIGHT(m.slField2, LEN(m.slField2) - m.sltVar1)
    IF ":" $ RIGHT(m.sltVar2, 3) .AND. RIGHT(m.sltVar2, 1) $ "0123456789"
      m.sltVar3 = RIGHT(m.sltVar2, 2)
      IF ":" $ m.sltVar3
        m.sltVar3 = RIGHT(m.sltVar3, 1)
      ENDIF
      IF VAL(m.sltVar3) > 0
        m.sltVar1   = SPACE(VAL(m.sltVar3))
        m.sltxxxyyy = VAL(m.sltVar3)
      ENDIF
    ELSE
      m.sltVar1 = EVAL(m.sltVar2)
    ENDIF
  ELSE
    m.sltVar2  = m.slField2
    IF ":" $ RIGHT(m.sltVar2, 3) .AND. RIGHT(m.sltVar2, 1) $ "0123456789"
      m.sltVar3 = RIGHT(m.sltVar2, 2)
      IF ":" $ m.sltVar3
        m.sltVar3 = RIGHT(m.sltVar3, 1)
      ENDIF
      IF VAL(m.sltVar3) > 0
        m.sltVar1   = SPACE(VAL(m.sltVar3))
        m.sltxxxyyy = VAL(m.sltVar3)
      ENDIF
    ELSE
      m.sltVar1 = EVAL(m.sltVar2)
    ENDIF
  ENDIF
  DO CASE
    CASE TYPE("m.sltVar1") = "C"
      m.sltVar2 = LEN(m.sltVar1)
    CASE TYPE("m.sltVar1") $ "NF"
      m.sltVar2 = IIF(EMPTY(m.slPict2), 7, LEN(m.slPict2))
    CASE TYPE("m.sltVar1") = "D"
      m.sltVar2 = 10
  OTHERWISE
    m.sltVar2 = IIF(EMPTY(m.slPict2), 7, LEN(m.slPict2))
  ENDCASE
  m.slNeededLen = m.slNeededLen + 1 + MAX(m.sltVar2, m.sltxxxyyy)
ENDIF
*
IF (.NOT. EMPTY(m.slField3))
  m.sltxxxyyy = LEN(m.slHeader3)
  IF "=" $ m.slField3
    m.sltVar1 = AT("=", m.slField3)
    m.sltVar2 = RIGHT(m.slField3, LEN(m.slField3) - m.sltVar1)
    IF ":" $ RIGHT(m.sltVar2, 3) .AND. RIGHT(m.sltVar2, 1) $ "0123456789"
      m.sltVar3 = RIGHT(m.sltVar2, 2)
      IF ":" $ m.sltVar3
        m.sltVar3 = RIGHT(m.sltVar3, 1)
      ENDIF
      IF VAL(m.sltVar3) > 0
        m.sltVar1   = SPACE(VAL(m.sltVar3))
        m.sltxxxyyy = VAL(m.sltVar3)
      ENDIF
    ELSE
      m.sltVar1 = EVAL(m.sltVar2)
    ENDIF
  ELSE
    m.sltVar2  = m.slField3
    IF ":" $ RIGHT(m.sltVar2, 3) .AND. RIGHT(m.sltVar2, 1) $ "0123456789"
      m.sltVar3 = RIGHT(m.sltVar2, 2)
      IF ":" $ m.sltVar3
        m.sltVar3 = RIGHT(m.sltVar3, 1)
      ENDIF
      IF VAL(m.sltVar3) > 0
        m.sltVar1 = SPACE(VAL(m.sltVar3))
        m.sltxxxyyy = VAL(m.sltVar3)
      ENDIF
    ELSE
      m.sltVar1 = EVAL(m.sltVar2)
    ENDIF
  ENDIF
  DO CASE
    CASE TYPE("m.sltVar1") = "C"
      m.sltVar2 = LEN(m.sltVar1)
    CASE TYPE("m.sltVar1") $ "NF"
      m.sltVar2 = IIF(EMPTY(m.slPict3), 7, LEN(m.slPict3))
    CASE TYPE("m.sltVar1") = "D"
      m.sltVar2 = 10
  OTHERWISE
    m.sltVar2 = IIF(EMPTY(m.slPict3), 7, LEN(m.slPict3))
  ENDCASE
  m.slNeededLen = m.slNeededLen + 1 + MAX(m.sltVar2, m.sltxxxyyy)
ENDIF
*
m.slNeededLen = m.slNeededLen + 3      && for Left/Right Lines !
IF EMPTY(m.slTitle)
  m.slTitle   = " "
ELSE
  m.slTitle   = LEFT(m.slTitle, MAX(36, m.slNeededLen))
ENDIF
IF LEN(m.slTitle) >= m.slNeededLen
  m.slNeededLen = LEN(m.slTitle) + 3
ENDIF
m.slNeededLen = MAX(m.slNeededLen, 20)      && by SKS for Minimum Standard !
m.slNeededLen = MIN(76, m.slNeededLen)
*
*
DEFINE WINDOW slWindow FROM 8,(79-m.slNeededLen) TO 32,79 IN DESKTOP PANEL ;
  NOCLOSE NOFLOAT NOGROW NOZOOM
SELECT (m.slAlias)
IF (.NOT. EMPTY(&slVarName))
  * There will occur an error when we use ALLTRIM, actually this is for
  * character type data only. So, for character data we use ALLTRIM but
  * for other data type we will use the value of the variable.
  IF TYPE("&slVarName") = "C"
    = SEEK(ALLTRIM(&slVarName), ALIAS())
  ELSE
    = SEEK(&slVarName, ALIAS())
  ENDIF
  IF (.NOT. FOUND())
    IF RECNO(0) # 0                        && Soft SEEK
      GOTO RECNO(0)
    ELSE                                   && Value Greater than last Record
      GOTO BOTTOM
    ENDIF
    DO CASE
      CASE TYPE("&slVarName") = "C"
        ?? CHR(7)
        WAIT WINDOW "Nothing starts from " + ALLTRIM(&slVarName) + " !" NOWAIT
      CASE TYPE("&slVarName") = "N"
        ?? CHR(7)
        WAIT WINDOW "Nothing starts from " + ALLTRIM(STR(&slVarName)) + " !" NOWAIT
      CASE TYPE("&slVarName") = "D"
        ?? CHR(7)
        WAIT WINDOW "Nothing starts from " + DTOC(&slVarName) + " !" NOWAIT
    ENDCASE
  ENDIF
ENDIF
SET ORDER TO    &slShowOrdr     && Change the Index for Display !
IF EMPTY(&slVarName)
  GOTO TOP
ENDIF
*
*DO MessDisplay WITH "[ENTER]/[RETURN]  -  Selects the Current Option and Returns Back" && Removed by Ramesh
ON KEY LABEL ENTER   KEYBOARD CHR(23)       && Value of Ctrl-W / Ctrl-END
IF EMPTY(m.slForCond)
  BROWSE FIELDS &slBrowCond NOAPPEND NODELETE NOEDIT NOMENU REST TITLE ;
    m.slTitle WINDOW slWindow COLOR SCHEME 10
ELSE
  BROWSE FIELDS &slBrowCond FOR &slForCond NOAPPEND NODELETE NOEDIT NOMENU ;
    REST TITLE m.slTitle WINDOW slWindow COLOR SCHEME 10
ENDIF
m.slLastKey  = LASTKEY()
ON KEY LABEL ENTER
*IF m.slLastKey = 33 .AND. (RECNO() <= RECCOUNT()) && This is Original
*IF m.slLastKey = 23  && Change by Ramesh
IF m.slLastKey = 23 .AND. (RECNO() <= RECCOUNT())
  &slVarName  = &slRetField
  m.slLastKey = 999
ENDIF
SET ORDER TO  &slPrvOrder
IF m.slPrvRecNo <= RECCOUNT()
  GOTO m.slPrvRecNo
ENDIF
IF (.NOT. EMPTY(m.slCurAlias))
  SELECT (m.slCurAlias)
  *IF m.slCurRecNo <= RECCOUNT() && withdrawn by ramesh
     * GOTO m.slCurRecNo
  *ENDIF
ENDIF
RELEASE WINDOW slWindow
RESTORE SCREEN FROM m.slScreen
IF m.SlInsMode           && not to be changed if other than USI CanFind
 m.SecondBrow = .T.     && Variable for Basic (USI) Files
ENDIF
IF m.slInsMode
  IF EMPTY(&slVarName)
    RETURN .F.
  ENDIF
  RETURN (m.slLastKey # 27)
ENDIF
RETURN (m.slLastKey = 999)

* EoF()


* Procedure to display a message line at the bottom (centre) of the screen.

PROCEDURE MessDisplay
PARAMETER m.MessLine
PRIVATE m.mdCurrWind, mdDispCol
m.mdCurrWind = WOUTPUT()
m.mdDispCol  = "GR+/B"     && IIF(ISCOLOR(), "GR+/B", "W+/N")
m.MessLine   = IIF(EMPTY(m.MessLine), "  ", LEFT(m.MessLine, 101))
IF (.NOT. EMPTY(m.mdCurrWind)) .AND. WROWS(m.mdCurrWind) <= 34
  ACTIVATE SCREEN
ENDIF
@ 34,0 SAY SPACE(WCOLS()) COLOR (m.mdDispCol)
@ 34,(WCOLS()-LEN(m.MessLine))/2 SAY m.MessLine COLOR (m.mdDispCol)
IF (.NOT. EMPTY(m.mdCurrWind)) .AND. WROWS(m.mdCurrWind) <= 34
  ACTIVATE WINDOW (m.mdCurrWind) SAME
ENDIF
RETURN
* EoP()

* Procedure to 'Close' data files
PROCEDURE CloseFile
PRIVATE m.cfCounter, m.cfLastArea
m.cfCounter = 1
m.cfLastArea= IIF(SELECT(1) > 25, 225, 25)
FOR m.cfCounter = 7 TO m.cfLastArea
  USE IN m.cfCounter
ENDFOR
RETURN
* EoP()

* Function to Return 'CanFinds' for a certain USI Database.
FUNCTION SetCanFind
PARAMETER m.scfNumber, m.scfInsMode
DO CASE
  CASE m.scfNumber = 1       && Size Groups
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'SizeGroup', 'CODE', 'BrdLength', 'CODE', '[[ Size Groups ]]', ;
      'CODE', 'Size Group', '@!', '_SzInCm=RetRealSize(CODE,.F.,.T.):15', ;
      'Size (cm.)', '@X', '_SzInFt=RetRealSize(CODE,.T.,.T.):15', ;
      'Size (Feet)', '@X')"
  CASE m.scfNumber = 2       && Carpet Grades
    RETURN "ShowList(SYS(18), .F., 'Grade', 'CODE', 'CODE', 'CODE', ;
      '[[ Carpet Grades ]]', 'CODE', 'Grade', '@!', 'DESC', 'Description', '@X')"
  CASE m.scfNumber = 3       && Printer
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Printer', 'PRINTER', 'PRINTER', 'PRINTER', '[[ Printers ]]', ;
      'PRINTER', 'Printer Name', '@!', 'PAPERTYPE', 'Paper Capacity', '@!')"
  CASE m.scfNumber = 4       && System Users File
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'UserFile', 'USER_ID', 'USER_ID', 'USER_ID', '[[ Authorised System Users ]]', ;
      'USER_ID', 'User ID', '@!', 'NAME', 'Name', '@X')"
  CASE m.scfNumber = 5       && Buyers/Customer
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Buyer', 'CODE', 'CODE', 'CODE', '[[ Buyers (Importers) ]]', ;
      'CODE', 'Buyer Code', '@!', 'NAME', 'Buyer Name/Company', '@X')"
  CASE m.scfNumber = 6       && Designs
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Cadesign', 'CODE', 'CODE', 'CODE', '[Carpet Designs ]', 'CODE:18', ;
      'Design', '@!', 'QUALITY:10', 'Quality', '@!', 'FLDTYPE:8', 'Field Type', '@X')"
  CASE m.scfNumber = 7       && Qualities
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Quality', 'CODE', 'CODE', 'CODE', '[[ Qualities ]]', 'CODE', ;
      'Quality', '@!', 'DESC:15', 'Desc', '@X')"
  CASE m.scfNumber = 8       && Fields (Design)
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'DgnField', 'FIELDCODE', 'FIELDCODE', 'FIELDCODE', '[[ Design Fields ]]', ;
      'FIELDCODE', 'Field Code', '@!', 'FOR_QLTY', 'Of Qlty.', '@!', ;
      'DESC', 'Description', '@X')"
  CASE m.scfNumber = 9       && Suppliers/Sub-Contractors
   RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
    ", 'Supplier', 'CODE', 'CODE', 'CODE', '[[ Suppliers / Sub-Contractors ]]', ;
   'CODE', 'Supplier', '@!', 'NAME', 'Sub-Contractor Name/Company', '@X')"
  CASE m.scfNumber = 10      && Colours
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Cacolour', 'CODE', 'CODE', 'CODE', '[ Colours ]', 'CODE', ;
      'Code', '@!', 'DESC', 'Description', '@X')"
  CASE m.scfNumber = 11      && Washing Types
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'WashType', 'WASHTYPE', 'WASHTYPE', 'WASHTYPE', '[[ Washing Types ]]', ;
      'WASHTYPE', 'Wash Type', '@!', 'DESC', 'Description', '@X')"
  CASE m.scfNumber = 12       && Weaver Name/ Category
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'CaWeaver', 'WEAVER', 'WEAVER', 'WEAVER', '[[ Weaver/ Category ]]', ;
      'WEAVER', 'Weaver Name', '@!', 'SUPPLIER', 'Supplier.', '@!', ;
      'CATEGORY', 'Category', '@X')"
ENDCASE
RETURN ""
* EoF()

* Function to Check EXIT Validity from a READ Object
FUNCTION ReadExit
m.ReadExitKey = LASTKEY()
IF m.ReadExitKey = 18 .OR. m.ReadExitKey = 19 .OR. ReadExitKey = 5 .OR. ;
  m.ReadExitKey = 15
  RETURN .F.
ENDIF
RETURN .T.
* EoF()


* Function to check how the READ field was exited. If it was exited having
* LASTKEY value ENTER or F12, it will return TRUE otherwise FALSE.
FUNCTION EnterF12
PARAMETER m.AllowUp
IF EMPTY(m.AllowUp)     && Allow ENTER, F12, ESC and CTRL-W/CTRL-END
  RETURN (LASTKEY() = 13 .OR. LASTKEY() = 134 .OR. LASTKEY() = 27 .OR. ;
    LASTKEY() = 23)
ENDIF
RETURN (LASTKEY() = 13 .OR. LASTKEY() = 134 .OR. LASTKEY() = 5 .OR. ;
  LASTKEY() = 19 .OR. LASTKEY() = 18 .OR. LASTKEY() = 15 .OR. ;
  LASTKEY() = 27 .OR. LASTKEY() = 23)
* End of Function EnterF12


* Function to Show 'Description' or 'Name' or Anything from the Alias
* passed in the function.
*
FUNCTION ShowDesc
PARAMETER m.SeekCode, m.SeekAlias, m.SeekField, m.SeekRow, m.SeekCol, m.SeekDisp
PRIVATE m.TempVar1, m.TempVar2
m.TempVar1 = .F.
IF LASTKEY() = 5 .OR. LASTKEY() = 19 .OR. LASTKEY() = 15 .OR. LASTKEY() = 18
  m.TempVar1 = .T.
ENDIF
m.TempVar2 = m.SeekAlias + "." + m.SeekField
m.SeekDisp = IIF(EMPTY(m.SeekDisp), LEN(&TempVar2), m.SeekDisp)
IF SEEK(m.SeekCode, m.SeekAlias)
  @ m.SeekRow,m.SeekCol SAY LEFT(&TempVar2, m.SeekDisp)
  RETURN .T.
ELSE
  @ m.SeekRow,m.SeekCol SAY SPACE(m.SeekDisp)
  RETURN m.TempVar1
ENDIF

* EoF()


* Procedure to Show upto three lines (minimum is one) on the screen and
* return to the calling program normally

PROCEDURE ShowMess
PARAMETER m.ShowLine1, m.ShowLine2, m.ShowLine3, m.ShowLine4, m.ShowLine5
IF EMPTY(m.ShowLine1)
  RETURN
ENDIF
PRIVATE m.MaxLength, m.PassLines, m.TempVar1, m.TempVar2, m.TempVar3, ;
  m.TempVar4, m.TempVar5
m.ShowLine1 = LEFT(ALLTRIM(m.ShowLine1), 75)
m.ShowLine2 = LEFT(IIF(EMPTY(m.ShowLine2), "", ALLTRIM(m.ShowLine2)), 75)
m.ShowLine3 = LEFT(IIF(EMPTY(m.ShowLine3), "", ALLTRIM(m.ShowLine3)), 75)
m.ShowLine4 = LEFT(IIF(EMPTY(m.ShowLine4), "", ALLTRIM(m.ShowLine4)), 75)
m.ShowLine5 = LEFT(IIF(EMPTY(m.ShowLine5), "", ALLTRIM(m.ShowLine5)), 75)
m.MaxLength = MAX(LEN(m.ShowLine1), LEN(m.ShowLine2), LEN(m.ShowLine3), ;
  LEN(m.ShowLine4), LEN(m.ShowLine5))
m.PassLines = 0 + IIF(EMPTY(m.ShowLine2), 0, 1) + IIF(EMPTY(m.ShowLine3), 0, 1) + ;
  IIF(EMPTY(m.ShowLine4), 0, 1) + IIF(EMPTY(m.ShowLine5), 0, 1)
m.TempVar1  = ((80 - m.MaxLength) / 2) - 2
m.TempVar2  = ((80 - m.MaxLength) / 2) + m.MaxLength + 1
DEFINE WINDOW __TempWin FROM 18,m.TempVar1 TO 22+m.PassLines,m.TempVar2 ;
  IN SCREEN NOCLOSE NOFLOAT NOGROW NOZOOM COLOR SCHEME 7
ACTIVATE WINDOW __TempWin NOSHOW
@ 0,(WCOLS()-LEN(m.ShowLine1))/2 SAY m.ShowLine1
IF (.NOT. EMPTY(m.ShowLine2))
  @ 1,(WCOLS()-LEN(m.ShowLine2))/2 SAY m.ShowLine2
ENDIF
IF (.NOT. EMPTY(m.ShowLine3))
  @ 2,(WCOLS()-LEN(m.ShowLine3))/2 SAY m.ShowLine3
ENDIF
IF (.NOT. EMPTY(m.ShowLine4))
  @ 3,(WCOLS()-LEN(m.ShowLine4))/2 SAY m.ShowLine4
ENDIF
IF (.NOT. EMPTY(m.ShowLine5))
  @ 4,(WCOLS()-LEN(m.ShowLine5))/2 SAY m.ShowLine5
ENDIF
m.TempVar2 = 1
?? CHR(7)              && Bell for Attention
@ 2+m.PassLines,(WCOLS()-12)/2 GET m.TempVar2 PICTURE "@*TH \!\<Continue" ;
  MESSAGE " " SIZE 1, 12, 1 COLOR SCHEME 7
SHOW WINDOW __TempWin
READ TIMEOUT 30
RELEASE WINDOW __TempWin
RETURN

* EoP()


* Function to Encode or Decode the entered password.
FUNCTION PwCoding
PARAMETER m.WordToChng, m.EncOrDec
PRIVATE m.tVar1, m.tVar2, m.tVar3, m.tVar4, m.tVar5
m.tVar1  = ALLTRIM(m.WordToChng)
m.tVar2  = ""
FOR m.tVar3 = 1 TO LEN(m.tVar1) STEP 1
  m.tVar4  = ASC(SUBSTR(m.tVar1, m.tVar3, 1))
  m.tVar4  = IIF(m.EncOrDec = "E", m.tVar4 + LEN(m.tVar1), m.tVar4 - LEN(m.tVar1))
  m.tVar2  = m.tVar2 + CHR(m.tVar4)
ENDFOR
RETURN LEFT(m.tVar2 + SPACE(LEN(m.WordToChng)), LEN(m.WordToChng))
* EoF()


* Sub Function of Printing Choices and Browse Utility
* Checks the validity of the entered file
*
FUNCTION ValidFile
PARAMETER m.ToCheck_, m.ValidChars, m.vCounter
m.ToCheck_ = ALLTRIM(m.ToCheck_)
IF LEN(m.ToCheck_) <= 0
  RETURN .F.
ENDIF
m.ValidChrs = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890~!@#$%^&()_/'"
m.vCounter = 1
DO WHILE m.vCounter <= LEN(m.ToCheck_)
  IF (.NOT. (SUBSTR(m.ToCheck_, m.vCounter, 1) $ m.ValidChrs))
    RETURN .F.
  ENDIF
  m.vCounter = m.vCounter + 1
ENDDO
IF FILE(m.ToCheck_ + ".")
  RETURN .F.
ENDIF
RETURN .T.

* Procedure to Update Trail Audit File - with different "action"s.
*
* Espelkamp, Germany - 30th April, 1995.
*
PROCEDURE UpdateTA
PARAMETER m.utaText
IF (.NOT. EMPTY(m.CurrUserID))
  INSERT INTO TrailAudit (USER_ID, DATE, TIME, ACTION) VALUES ;
    (m.CurrUserID, DATE(), TIME(), m.utaText)
ENDIF
UNLOCK IN TrailAudit
RETURN
* End of Function "UpdateTA"


* Function to Allow to Move one Field up if appropriate Key is pressed.
*
FUNCTION AllowMove
RETURN (LASTKEY() = 5 .OR. LASTKEY() = 19 .OR. LASTKEY() = 18 .OR. ;
  LASTKEY() = 15)
* Eof()


* Function to Convert a Number to Text according to it's specified PICTURE
* Format and Length ! If the Number exceeds the length of the picture or if
* it cannot be displayed in that range, it will return all '*' !
*
* Created by SKS on 4th April 1997 at Espelkamp, Germany.
*     This function might be useful to convert a number to character format
*     and print it from PrintIt utilities !
*

FUNCTION NumbToChar
PARAMETER m.ConvNumber, m.ConvPicture, m.ConvRound, m.MustZeroBe
PRIVATE m.PointSign, m.SepaSign, m.LeftPicture, m.MinusSign
IF m.ConvNumber = 0 .AND. (.NOT. m.MustZeroBe)
  RETURN SPACE(LEN(m.ConvPicture))
ENDIF
m.ConvRound  = IIF(TYPE("m.ConvRound") $ "NF", m.ConvRound, 1)
m.MinusSign  = (m.ConvNumber < 0)
m.ConvNumber = ABS(m.ConvNumber)
m.PointSign  = SET("POINT")
m.SepaSign   = SET("SEPARATOR")
PRIVATE m.tVar1, m.tVar2, m.tVar3, m.tVar4, m.tVar5, m.tVar6, m.tVar7
PRIVATE m.DeciExist, m.AfterDeci, m.BeforeDeci
m.DeciExist  = ATC(".", m.ConvPicture)
m.AfterDeci  = ""
IF m.DeciExist > 0
  m.AfterDeci  = RIGHT(m.ConvPicture, LEN(m.ConvPicture) - m.DeciExist)
ENDIF
m.AfterDeci  = LEN(m.AfterDeci)
m.ConvNumber = ROUND(m.ConvNumber / m.ConvRound, m.AfterDeci)
IF m.DeciExist > 0
  m.LeftPicture= LEFT(m.ConvPicture, LEN(m.ConvPicture) - (m.AfterDeci + 1))
ELSE
  m.LeftPicture= m.ConvPicture
ENDIF
m.BeforeDeci = LEN(m.LeftPicture)
m.tVar1      = ALLTRIM(STR(m.ConvNumber, m.BeforeDeci + m.AfterDeci + ;
  IIF(m.AfterDeci > 0, 1, 0), m.AfterDeci))
m.tVar2      = ""       && Value Before Decimal
m.tVar3      = ""       && Value After Decimal
m.tVar4      = 1        && Now in Before Decimal !
FOR m.tVar5 = 1 TO LEN(m.tVar1) STEP 1
  m.tVar6  = SUBSTR(m.tVar1, m.tVar5, 1)
  IF EMPTY(m.tVar6)
    LOOP
  ENDIF
  IF m.tVar6 = m.PointSign   && STR converts to Current POINT !
    m.tVar4  = 2
    LOOP
  ENDIF
  IF m.tVar4 = 1
    m.tVar2  = m.tVar2 + m.tVar6
  ELSE
    m.tVar3  = m.tVar3 + m.tVar6
  ENDIF
ENDFOR
*
IF LEN(m.tVar2) + OCCURS(",", m.LeftPicture) > LEN(m.LeftPicture)
  RETURN REPLICATE("*", m.BeforeDeci) + IIF(m.DeciExist > 0, ;
    m.PointSign + REPLICATE("*", m.AfterDeci), "")
ENDIF
IF OCCURS(",", m.LeftPicture) > 0
  m.tVar2  = RIGHT(SPACE(20) + m.tVar2, LEN(m.LeftPicture))
  FOR m.tVar4 = LEN(m.tVar2) TO 1 STEP -1
    m.tVar5  = SUBSTR(m.tVar2, m.tVar4, 1)
    m.tVar6  = SUBSTR(m.LeftPicture, m.tVar4, 1)
    IF m.tVar6 = "," .AND. ((.NOT. EMPTY(m.tVar5)) .AND. m.tVar5 # m.SepaSign)
      m.tVar2  = LEFT(m.tVar2, m.tVar4) + m.SepaSign + RIGHT(m.tVar2, LEN(m.tVar2) - m.tVar4)
      m.tVar2  = RIGHT(m.tVar2, LEN(m.LeftPicture))
      m.tVar4  = LEN(m.tVar2)
      LOOP
    ENDIF
  ENDFOR
ENDIF
*
m.tVar1  = m.tVar2 + IIF(m.DeciExist > 0, m.PointSign + LEFT(m.tVar3 + ;
  REPLICATE("0", 10), m.AfterDeci), "")
m.tVar1  = IIF(m.MinusSign, "-", "") + ALLTRIM(m.tVar1)
IF LEN(m.tVar1) > LEN(m.ConvPicture)
  RETURN REPLICATE("*", m.BeforeDeci) + IIF(m.DeciExist > 0, m.PointSign + ;
    REPLICATE("*", m.AfterDeci), "")
ENDIF
RETURN RIGHT(SPACE(20) + m.tVar1, LEN(m.ConvPicture))

* Eof()


* Procedure to Lock the System from any point till the right password is not
* entered !
* Five wrong attempt will close all the environment and QUIT
* Also if the input is not made till one hour then it will QUIT

PROCEDURE SystemLock
IF SET("PRINTER") = "ON"
  RETURN
ENDIF
PRIVATE m.slEnterKey, m.slInsKey, m.slDelKey, m.slF2Key, m.slF5Key, ;
  m.slF8Key, m.slF10Key
m.slEnterKey = ON("KEY", "ENTER")
m.slInsKey   = ON("KEY", "INS")
m.slDelKey   = ON("KEY", "DEL")
m.slF2Key    = ON("KEY", "F2")
m.slF5Key    = ON("KEY", "F5")
m.slF8Key    = ON("KEY", "F8")
m.slF10Key   = ON("KEY", "F10")
ON KEY LABEL ENTER
ON KEY LABEL INS
ON KEY LABEL DEL
ON KEY LABEL F2      KEYBOARD CHR(00)
ON KEY LABEL F5      KEYBOARD CHR(00)
ON KEY LABEL F8      KEYBOARD CHR(00)
ON KEY LABEL F10     KEYBOARD CHR(00)
ON KEY LABEL CTRL+L  KEYBOARD CHR(00)
* Create Temporary Variables and Store UserFile's Current Record Pointer
PRIVATE m.slUserRec, m.slUserPWrd
m.slUserRec = RECNO("UserFile")
* If the User's ID is Just Deleted - No more Exists in the Data File
IF (.NOT. SEEK(m.CurrUserID, "UserFile"))
  IF m.slUserRec <= RECCOUNT("UserFile")
    GOTO m.slUserRec  IN UserFile
  ENDIF
  DO ShowMess WITH "Your Short Name no more Exists (JUST DELETED) !", ;
    "Contact Supervisor !!"
  ON KEY LABEL ENTER   &slEnterKey
  ON KEY LABEL INS     &slInsKey
  ON KEY LABEL DEL     &slDelKey
  ON KEY LABEL F2      &slF2Key
  ON KEY LABEL F5      &slF5Key
  ON KEY LABEL F8      &slF8Key
  ON KEY LABEL F10     &slF10Key
  RETURN
ENDIF
m.slUserPWrd = PwCoding(UserFile.PASSWD, "D")
IF m.slUserRec <= RECCOUNT("UserFile")
  GOTO m.slUserRec  IN UserFile
ENDIF
* Define Blank (Black) Window - as Screen saver, one moving-window for
* Asking Password, Activate them, Deactivate Clock.
SET CLOCK      OFF
DEFINE WINDOW slBlankScr FROM 0,0 TO 24,79 IN SCREEN NONE NOCLOSE NOFLOAT ;
  NOGROW NOZOOM COLOR N/N, N/N
DEFINE WINDOW slPwAskWin FROM 10,36 TO 16,78 IN WINDOW slBlankScr TITLE ;
  "[ User: " + ALLTRIM(m.CurrUserID) + " ]" PANEL NOCLOSE NOFLOAT NOGROW ;
  NOZOOM COLOR SCHEME IIF(ISCOLOR(), 5, 1)
WAIT CLEAR
ACTIVATE WINDOW slBlankScr
ACTIVATE WINDOW slPwAskWin TOP NOSHOW
MOVE WINDOW slPwAskWin CENTER
SHOW WINDOW slPwAskWin
CLEAR
PRIVATE m.slRow, m.slCol, m.slGetPw, m.slInvEntry, m.slLockMin
m.slRow = 09
m.slCol = 22
m.slGetPw    = SPACE(LEN(m.slUserPWrd))
m.slInvEntry = 0
m.slLockMin  = 0
@ 1,1  SAY "    To Continue,"
@ 3,1  SAY " Enter Password:"
*
DO WHILE m.slInvEntry < 5
  m.slGetPw  = SpecialPW(3, 18, LEN(m.slGetPw), 60)
  *
  IF m.slGetPw = m.slUserPWrd
    EXIT
  ENDIF
  *
  IF LEN(ALLTRIM(m.slGetPw)) = 1 .AND. ALLTRIM(m.slGetPw) = "á"
    m.slLockMin = m.slLockMin + 1
    IF m.slLockMin >= 60
      m.slInvEntry = m.slInvEntry + 99
      EXIT
    ENDIF
    m.slRow = IIF(m.slRow > 15, 0, m.slRow + (RAND() * 3))
    m.slCol = IIF(m.slCol > 25, 0, m.slCol + (RAND() * 4))
    MOVE WINDOW slPwAskWin TO m.slRow, m.slCol
    LOOP
  ENDIF
  *
  WAIT WINDOW "Invalid Password !!" TIMEOUT 0.5
  m.slInvEntry = m.slInvEntry + 1
  * Move the window in random position
  m.slRow = IIF(m.slRow > 15, 0, m.slRow + (RAND() * 3))
  m.slCol = IIF(m.slCol > 25, 0, m.slCol + (RAND() * 4))
  MOVE WINDOW slPwAskWin TO m.slRow, m.slCol
ENDDO
*
RELEASE WINDOWS slBlankScr, slPwAskWin
SET CLOCK     ON
IF m.slInvEntry >= 5
  m.slVar1  = IIF(m.slInvEntry >= 99, "No Response from Keyboard for more than 1 hour !", ;
    "Wrong Password Entered for 3 times !")
  DO ShowMess  WITH "Now the Program is being Shut because: ", m.slVar1
  DO SysClose_ WITH m.slVar1
ENDIF
*
ON KEY LABEL CTRL+L  DO SystemLock
ON KEY LABEL ENTER   &slEnterKey
ON KEY LABEL INS     &slInsKey
ON KEY LABEL DEL     &slDelKey
ON KEY LABEL F2      &slF2Key
ON KEY LABEL F5      &slF5Key
ON KEY LABEL F8      &slF8Key
ON KEY LABEL F10     &slF10Key
RETURN

* EoP()

* Function to Show Special Character for Password and allow to type anything
* till enter is not pressed. Only certain keys are allowed here !!
*
* Created by SKS on 18th April 1998 at Kathmandu, Nepal.

FUNCTION SpecialPW
PARAMETER m.spRow, m.spCol, m.spLen, m.spTimeOut
PRIVATE m.pwVar1, m.pwVar2, m.pwVar3, m.pwVar4, m.pwChar, m.pwString
m.pwVar1  = SPACE(m.spLen)
@ m.spRow,m.spCol  GET m.pwVar1
CLEAR GETS
@ m.spRow,m.spCol  SAY ""       && Put the Cursor there !
*
m.pwString = ""
m.pwVar1   = 1
m.spTimeOut= IIF(EMPTY(m.spTimeOut), 0, m.spTimeOut)
DO WHILE m.pwVar1 <= m.spLen
  m.pwChar = INKEY(m.spTimeOut)
  DO CASE
    CASE m.pwChar = 0         && by Timeout !
      m.pwString = "á"
      EXIT
    CASE m.pwChar = 134       && F12 Key Pressed
      EXIT
    CASE m.pwChar = 13        && ENTER Pressed
      EXIT
    CASE m.pwChar = 127       && BACKSPACE
      IF LEN(m.pwString) > 0
        m.pwString = LEFT(m.pwString, LEN(m.pwString) - 1)
        m.pwVar1   = m.pwVar1 - 1
        m.pwVar2   = REPLICATE("*", LEN(m.pwString))
        m.pwVar3   = SPACE(m.spLen)
        @ m.spRow,m.spCol  GET m.pwVar3
        CLEAR GETS
        @ m.spRow,m.spCol  GET m.pwVar2
        CLEAR GETS
      ELSE
        ?? CHR(7)
      ENDIF
    CASE m.pwChar = 27        && ESCAPE
      m.pwString = ""
      EXIT
    CASE m.pwChar = 5 .OR. m.pwChar = 19 .OR. m.pwChar = 4 .OR. ;
      m.pwChar = 3 .OR. m.pwChar = 18 .OR. m.pwChar = 9 .OR. ;
      m.pwChar = 15 .OR. m.pwChar = 7 .OR. m.pwChar = 24 .OR. ;
      m.pwChar = 1 .OR. m.pwChar = 6 .OR. m.pwChar = 22
      ?? CHR(7)
  OTHERWISE
    m.pwChar   = CHR(m.pwChar)
    m.pwString = m.pwString + m.pwChar
    m.pwVar1   = m.pwVar1 + 1
    m.pwVar2   = REPLICATE("*", LEN(m.pwString))
    @ m.spRow,m.spCol GET m.pwVar2
    CLEAR GETS
  ENDCASE
ENDDO
*
m.pwString  = LEFT(m.pwString + SPACE(m.spLen), m.spLen)
RETURN UPPER(m.pwString)

* EoF()


* Function to Return a Text with RTRIM !
FUNCTION RightText
PARAMETER m.rtVar
PRIVATE m.rtVar1, m.rtVar2, m.rtVar3
m.rtVar1  = IIF(LEFT(LOWER(m.rtVar), 2) = "m.", "", "m.") + m.rtVar
m.rtVar2  = EVAL(m.rtVar1)
m.rtVar3  = RIGHT(SPACE(LEN(m.rtVar2)) + ALLTRIM(m.rtVar2), LEN(m.rtVar2))
&rtVar    = m.rtVar3
SHOW GET (m.rtVar)
RETURN .T.
* EoF()

* Function to Nullify a list of variables If the related main variable is
* Null and Re-Display them (with SHOWGET).
FUNCTION NullIfNull
PARAMETER m.ninMainVar, m.ninVar1, m.ninVar2, m.ninVar3, m.ninVar4, ;
  m.ninVar5, m.ninVar6, m.ninVar7, m.ninVar8, m.ninVar9, m.ninVar10
IF (.NOT. EMPTY(&ninMainVar))
  RETURN .T.
ENDIF
IF LASTKEY() = 18 .OR. LASTKEY() = 19 .OR. LASTKEY() = 5 .OR. LASTKEY() = 15
  RETURN .T.
ENDIF
*
PRIVATE m.TempVar1, m.TempVar2, m.TempVar3
FOR m.TempVar1 = 1 TO 10
  m.TempVar2 = "m.ninVar" + ALLTRIM(STR(m.TempVar1))
  IF EMPTY(&TempVar2)
    LOOP
  ENDIF
  * Now Nullify all
  m.TempVar2 = &TempVar2
  DO CASE
    CASE TYPE(m.TempVar2) = "C"
      &TempVar2 = SPACE(LEN(&TempVar2))
    CASE TYPE(m.TempVar2) $ "NF"
      &TempVar2 = 0
    CASE TYPE(m.TempVar2) = "D"
      &TempVar2 = CTOD("")
    CASE TYPE(m.TempVar2) = "M"
      &TempVar2 = ""
  ENDCASE
ENDFOR
* Re-Display GET objects
IF TYPE("m.ninVar1") = "C"
  SHOW GET (m.ninVar1) LEVEL MAX(RDLEVEL() - 1, 1)
ENDIF
IF TYPE("m.ninVar2") = "C"
  SHOW GET (m.ninVar2) LEVEL MAX(RDLEVEL() - 1, 1)
ENDIF
IF TYPE("m.ninVar3") = "C"
  SHOW GET (m.ninVar3) LEVEL MAX(RDLEVEL() - 1, 1)
ENDIF
IF TYPE("m.ninVar4") = "C"
  SHOW GET (m.ninVar4) LEVEL MAX(RDLEVEL() - 1, 1)
ENDIF
IF TYPE("m.ninVar5") = "C"
  SHOW GET (m.ninVar5) LEVEL MAX(RDLEVEL() - 1, 1)
ENDIF
IF TYPE("m.ninVar6") = "C"
  SHOW GET (m.ninVar6) LEVEL MAX(RDLEVEL() - 1, 1)
ENDIF
IF TYPE("m.ninVar7") = "C"
  SHOW GET (m.ninVar7) LEVEL MAX(RDLEVEL() - 1, 1)
ENDIF
IF TYPE("m.ninVar8") = "C"
  SHOW GET (m.ninVar8) LEVEL MAX(RDLEVEL() - 1, 1)
ENDIF
IF TYPE("m.ninVar9") = "C"
  SHOW GET (m.ninVar9) LEVEL MAX(RDLEVEL() - 1, 1)
ENDIF
IF TYPE("m.ninVar10") = "C"
  SHOW GET (m.ninVar10) LEVEL MAX(RDLEVEL() - 1, 1)
ENDIF
RETURN .T.
* EoF()


* Function to Show Supplier's Category !
FUNCTION ShowSupCat
PARAMETER m.ForCode, m.AtRow, m.AtCol, m.MaxLen, m.auWeavVar
IF LASTKEY() = 5 .OR. LASTKEY() = 19 .OR. LASTKEY() = 18 .OR. LASTKEY() = 15
  RETURN .T.
ENDIF
IF (.NOT. SEEK(m.ForCode, "Supplier"))
  RETURN .F.
ENDIF
m.MaxLen  = IIF(TYPE("m.MaxLen") $ "NF", m.MaxLen, 10)
@ m.AtRow,AtCol SAY LEFT(Supplier.CATEGORY + SPACE(m.MaxLen), m.MaxLen)Font "Ariel",10 Style "B" COLOR SCHEME 5
IF (.NOT. EMPTY(m.auWeavVar))
  IF Supplier.CATEGORY # "INTERNAL  "
    &auWeavVar = m.ForCode
    SHOW GET (m.auWeavVar)
  ENDIF
ENDIF
RETURN .T.
* EoF()


* Help Function to Retrieve Records - checks Exact Match Case !
FUNCTION ccsMatch1
PARAMETER m.xyOrdType, m.xyCrpType
IF EMPTY(m.psOrdType) .AND. EMPTY(m.psCarpType)
  RETURN .T.
ENDIF
IF (.NOT. EMPTY(m.psOrdType)) .AND. ALLTRIM(m.psOrdType) # ALLTRIM(m.xyOrdType)
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psCarpType)) .AND. ALLTRIM(m.psCarpType) # ALLTRIM(m.xyCrpType)
  RETURN .F.
ENDIF
RETURN .T.
* EoF()


**Function to Retrieve Records - in Carpet Distribution SEARCH ENTRY
FUNCTION ccsMatch2
PARAMETER m.xyBcode, m.xyOrderNo, m.xyCtrlNo, m.xyOLNumber, m.xyQuality, m.xyDesign,  m.xyColour, m.xyOrdType,;
	  m.xyField, m.xySize, m.xyCarpType, m.xySpclInst, m.xyNotes, m.xyComment
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCtrlNo, m.psCtrlNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOLNumber, m.psOLNumber))
  RETURN .F.
ENDIF
*
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyColour, m.psColour))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyOrdType, m.psOrdType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyField, m.psField))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySize, m.psSize))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyCarpType, m.psCarpType))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psSpclInst)) .AND. (.NOT. ALLTRIM(m.psSpclInst) $ UPPER(m.xySpclInst))
  RETURN .F.
ENDIF
*IF (.NOT. csSpSrchT_(m.xySpclInst, m.psSpclInst)) && Temporarily suspended 2010.4.23
 * RETURN .F.
*ENDIF
IF (.NOT. EMPTY(m.psNotes)) .AND. (.NOT. ALLTRIM(m.psNotes) $ UPPER(m.xyNotes))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psComment)) .AND. (.NOT. ALLTRIM(m.psComment) $ UPPER(m.xyComment))
  RETURN .F.
ENDIF
*
RETURN .T.

* EoF()
*This function Retrieve Records by SEARCHALL (ALL PRODUCTION REPORT) Max 27 parameters can be passed in a fun (VFox6)
FUNCTION ccsMatch3
PARAMETER m.xyBcode, m.xyCardNo, m.xyCarpetNo, m.xyOrderNo, m.xyCtrlNo, m.xyOLNumber, m.xyQuality, m.xyDesign, m.xySize, m.xyColour, m.xyOrdType,;
m.xyField, m.xySupplier, m.xyWashType, m.xySpclInst, m.xyComment, m.xyQltComment, m.xyCStatus, m.xyLoomdt, m.xyCarpType,;
m.xyCategory, m.xyWeaver, m.xyNotes, m.xyPaLate, m.xyEstShip_Dt

IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCardNo, m.psCardNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCarpetNo, m.psCarpetNo))
  RETURN .F.
ENDIF
*Added for below (1) subsitute 15/08/2016
IF (.NOT. EMPTY(m.psOrderNo)) .AND. (.NOT. ALLTRIM(m.psOrderNo) $ UPPER(m.xyOrderNo))
  RETURN .F.
ENDIF
*(1)
*IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))                           && working ok for 7 char, changed in 15/08/2016 by Ramesh
 * RETURN .F.
*ENDIF
IF (.NOT. csSpSrchT_(m.xyCtrlNo, m.psCtrlNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOLNumber, m.psOLNumber))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySize, m.psSize))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyColour, m.psColour))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyOrdType, m.psOrdType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyField, m.psField))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySupplier, m.psSupplier))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyWashType, m.psWashType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySpclInst, m.psSpclInst)) && 17/6/2019 done for multiple scan
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psComment)) .AND. (.NOT. ALLTRIM(m.psComment) $ UPPER(m.xyComment))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psQltComment)) .AND. (.NOT. ALLTRIM(m.psQltComment) $ UPPER(m.xyQltComment))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_( m.xyCStatus, m.psCStatus))
  RETURN .F.
ENDIF
*IF (.NOT. EMPTY( m.psCStatus)) .AND. (.NOT. ALLTRIM( m.psCStatus) $ UPPER(m.xyCStatus))
 * RETURN .F.
*ENDIF
IF m.psLoomdt="..."   
	If !empty(m.xyLoomdt)
		RETURN .F.
	ENDIF
ENDIF
IF (.NOT. csSpSrch2T_(m.xyCarpType, m.psCarpType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCategory, m.psCategory))
  RETURN .F.
ENDIF
*IF (.NOT. csSpSrchT_(m.xyWeaver, m.psWeaver))
 * RETURN .F.
*ENDIF
IF (.NOT. EMPTY(m.psWeaver)) .AND. (.NOT. ALLTRIM(m.psWeaver) $ UPPER(m.xyWeaver))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psNotes)) .AND. (.NOT. ALLTRIM(m.psNotes) $ UPPER(m.xyNotes))
  RETURN .F.
ENDIF
IF m.psPaLate="..."   && Display all empty Packing Late
	If !empty(m.xyPaLate)
		RETURN .F.
	ENDIF
ELSE
	IF (.NOT. EMPTY(m.psPaLate)) .AND. (.NOT. ALLTRIM(m.psPaLate) $ UPPER(m.xyPaLate))
		 RETURN .F.
	ENDIF
ENDIF
IF (.NOT. EMPTY(m.psEstShip_Dt)) .AND. (.NOT. (m.psEstShip_Dt = m.xyEstShip_Dt))
  RETURN .F.
ENDIF
RETURN .T.
* EoF()

*This match csTrimInfo3a
FUNCTION ccsMatch3A
PARAMETER m.xyBcode, m.xyCarpetNo, m.xyOrderNo, m.xyCtrlNo, m.xyOLNumber, m.xyQuality, m.xyDesign, m.xyColour,m.xySpclInst,m.xyInvno
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCarpetNo, m.psCarpetNo))
  RETURN .F.
ENDIF
*Added for below (1) subsitute 15/08/2016
IF (.NOT. EMPTY(m.psOrderNo)) .AND. (.NOT. ALLTRIM(m.psOrderNo) $ UPPER(m.xyOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCtrlNo, m.psCtrlNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOLNumber, m.psOLNumber))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyColour, m.psColour))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psSpclInst)) .AND. (.NOT. ALLTRIM(m.psSpclInst) $ UPPER(m.xySpclInst))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyInvno, m.psInvno))
  RETURN .F.
ENDIF
*
RETURN .T.
* EoF()

* Help Function to Retrieve Weaver names Record for onloom, lateonloom report
FUNCTION ccsMatch4
PARAMETER m.xyWeaver
IF (.NOT. csSpSrchT_(m.xyWeaver, m.psWeaver))
  RETURN .F.
ENDIF
RETURN .T.
* EoF()

FUNCTION ccsMatch5
PARAMETER m.xyOrderNo
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
RETURN .T.
*EoF()

*This function Retrieve Records by Multiple Choice of NONDISTRIBUTED CARPETS
FUNCTION ccsMatch6
PARAMETER m.xyBcode, m.xyOrderNo, m.xyCtrlNo, m.xyOLNumber, m.xyQuality, m.xyDesign, m.xySize, m.xyColour, m.xyOrdType,;
		 m.xyField, m.xyWashType, m.xySpclInst, m.xyComment, m.xyCStatus, m.xyCarpType, m.xyNotes
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCtrlNo, m.psCtrlNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOLNumber, m.psOLNumber))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySize, m.psSize))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyColour, m.psColour))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyOrdType, m.psOrdType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyField, m.psField))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyWashType, m.psWashType))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psSpclInst)) .AND. (.NOT. ALLTRIM(m.psSpclInst) $ UPPER(m.xySpclInst))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psComment)) .AND. (.NOT. ALLTRIM(m.psComment) $ UPPER(m.xyComment))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_( m.xyCStatus, m.psCStatus))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyCarpType, m.psCarpType))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psNotes)) .AND. (.NOT. ALLTRIM(m.psNotes) $ UPPER(m.xyNotes))
  RETURN .F.
ENDIF
*
RETURN .T.
* EoF()

*This function Retrieve Records by Multiple Choice Order-> Progress Report (all 4 reports)
FUNCTION ccsMatch6a
PARAMETER m.xyBcode, m.xyOrderNo, m.xyQuality, m.xyDesign, m.xySize, m.xyColour
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySize, m.psSize))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyColour, m.psColour))
  RETURN .F.
ENDIF
*
RETURN .T.

* EoF()

*This function Retrieve Records by Multiple Choice of Search both
FUNCTION ccsMatch6B
PARAMETER m.xyBcode, m.xyCarpetNo, m.xyOrderNo, m.xyCtrlNo, m.xyOLNumber, m.xyQuality, m.xyDesign, m.xySize, m.xyColour, m.xySpclInst, m.xyCStatus, m.xyNotes
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCarpetNo, m.psCarpetNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCtrlNo, m.psCtrlNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOLNumber, m.psOLNumber))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySize, m.psSize))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyColour, m.psColour))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psSpclInst)) .AND. (.NOT. ALLTRIM(m.psSpclInst) $ UPPER(m.xySpclInst))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_( m.xyCStatus, m.psCStatus))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psNotes)) .AND. (.NOT. ALLTRIM(m.psNotes) $ UPPER(m.xyNotes))
  RETURN .F.
ENDIF
*
RETURN .T.
* EoF()

*Cadurnrep.prg Stage-wise Carpet production reports (days)
FUNCTION ccsMatch6c
PARAMETER m.xyBcode, m.xyOrderNo, m.xyQuality, m.xyDesign, m.xySize, m.xyColour, m.xyWashType
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySize, m.psSize))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyColour, m.psColour))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyWashType, m.psWashType))
  RETURN .F.
ENDIF
*
RETURN .T.
* EoF()


*This function Retrieve Records by Multiple Choice of Late OnLoom Report(PRC)
FUNCTION ccsMatch7
PARAMETER m.xyBcode, m.xyOrderNo, m.xyCtrlNo, m.xyOLNumber, m.xyQuality, m.xyDesign, m.xySize, m.xyColour, m.xyOrdType, m.xyWashType, m.xyCategory
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCtrlNo, m.psCtrlNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOLNumber, m.psOLNumber))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySize, m.psSize))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyColour, m.psColour))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyOrdType, m.psOrdType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyWashType, m.psWashType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyCategory, m.psCategory))
  RETURN .F.
ENDIF
*IF (.NOT. EMPTY(m.psCategory)) .AND. (.NOT. ALLTRIM(m.psCategory) $ UPPER(m.xyCategory))
 * RETURN .F.
*ENDIF
*
RETURN .T.
* EoF()

*This function Retrieve Records by Multiple Choice PO Report
FUNCTION ccsMatch8
PARAMETER m.xyBcode, m.xyOrderNo, m.xyQuality, m.xyOrdType
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyOrdType, m.psOrdType))
  RETURN .F.
ENDIF
*
RETURN .T.
* EoF()


FUNCTION ccsMatch9 && Category report for crosstab grade & quality
PARAMETER m.xyCategory
IF (.NOT. csSpSrchT_(m.xyCategory, m.psCategory))
  RETURN .F.
ENDIF
* EoF()

*This function Retrieve Records by Multiple Choice PRC-Finish Report,REstShipDt
FUNCTION ccsMatch10
PARAMETER m.xyBcode, m.xyQuality, m.xyWeaver, m.xyGrade,m.xyOrderNo, m.xyNotes,m.xyBillNo,m.xyCarpetNo
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyWeaver, m.psWeaver))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psGrade)) .AND. (.NOT. ALLTRIM(m.psGrade) $ UPPER(m.xyGrade))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psNotes)) .AND. (.NOT. ALLTRIM(m.psNotes) $ UPPER(m.xyNotes))
  RETURN .F.
ENDIF
 IF (.NOT. EMPTY(m.psBillNo)) .AND. (.NOT. ALLTRIM(m.psBillNo) $ UPPER(m.xyBillNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCarpetNo, m.psCarpetNo))
  RETURN .F.
ENDIF
*
RETURN .T.

* EoF()

*This function Retrieve Stock Report (rstksearch.prg) + Regulrar Carpet with multiple search/ view/ print / send excel
FUNCTION ccsMatch11
PARAMETER m.xyBcode, m.xyCardNo, m.xyCarpetNo, m.xyOrderNo, m.xyCtrlNo, m.xyOLNumber, m.xyQuality, m.xyDesign, m.xySize, m.xyColour, m.xyOrdType,;
m.xyField, m.xyWashType, m.xySpclInst, m.xyCStatus, m.xyCarpType, m.xyNotes, m.xyYrPhy,m.xySL_No,m.xyLocation
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCardNo, m.psCardNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCarpetNo, m.psCarpetNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCtrlNo, m.psCtrlNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOLNumber, m.psOLNumber))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySize, m.psSize))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyColour, m.psColour))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyOrdType, m.psOrdType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyField, m.psField))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyWashType, m.psWashType))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psSLNo)) .AND. (.NOT. ALLTRIM(m.psSLNo) $ UPPER(m.xySL_No))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY( m.psLocation)) .AND. (.NOT. ALLTRIM(m.psLocation) $ UPPER(m.xyLocation))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psSpclInst)) .AND. (.NOT. ALLTRIM(m.psSpclInst) $ UPPER(m.xySpclInst))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY( m.psCStatus)) .AND. (.NOT. ALLTRIM( m.psCStatus) $ UPPER(m.xyCStatus))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyCarpType, m.psCarpType))
  RETURN .F.
ENDIF
*IF (.NOT. csSpSrchT_(m.xyWeaver, m.psWeaver))
 * RETURN .F.
*ENDIF
IF (.NOT. EMPTY(m.psNotes)) .AND. (.NOT. ALLTRIM(m.psNotes) $ UPPER(m.xyNotes))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyYrPhy, m.psYrPhy))
 RETURN .F.
ENDIF
*IF (.NOT. EMPTY(m.psYrPhy)) .AND. (.NOT. ALLTRIM(m.psYrPhy) $ UPPER(m.xyYrPhy))
 *RETURN .F.
*ENDIF
*
RETURN .T.
*EOF()

*This function Retrieve Buyer Order Report (rbuyord.prg) with multiple search/ Edit/ View/ Print / Send excel
FUNCTION ccsMatch12
PARAMETER m.xyBcode, m.xyOrderNo, m.xyCtrlNo, m.xyOLNumber, m.xyQuality, m.xyDesign, m.xySize, m.xyColour, m.xyOrdType,;
m.xyField, m.xyWashType, m.xySpclInst, m.xyCStatus, m.xyCarpType, m.xyNotes
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCtrlNo, m.psCtrlNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOLNumber, m.psOLNumber))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySize, m.psSize))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyColour, m.psColour))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyOrdType, m.psOrdType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyField, m.psField))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyWashType, m.psWashType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySpclInst, m.psSpclInst)) && 17/6/2019 done for multiple scan
  RETURN .F.
ENDIF
*IF (.NOT. EMPTY(m.psSpclInst)) .AND. (.NOT. ALLTRIM(m.psSpclInst) $ UPPER(m.xySpclInst)) && 17/6/2019 Changed for TT Carpet Mr.Kapil, Ok for single scan
 * RETURN .F.
*ENDIF
IF (.NOT. csSpSrchT_( m.xyCStatus, m.psCStatus))
  RETURN .F.
ENDIF
*19/3/2022
*IF (.NOT. EMPTY( m.psCStatus)) .AND. (.NOT. ALLTRIM( m.psCStatus) $ UPPER(m.xyCStatus))
 * RETURN .F.
*ENDIF
IF (.NOT. csSpSrch2T_(m.xyCarpType, m.psCarpType))
  RETURN .F.
ENDIF
*IF (.NOT. csSpSrchT_(m.xyWeaver, m.psWeaver))
 * RETURN .F.
*ENDIF
IF (.NOT. EMPTY(m.psNotes)) .AND. (.NOT. ALLTRIM(m.psNotes) $ UPPER(m.xyNotes))
  RETURN .F.
ENDIF
*
RETURN .T.
*EOF()

*This function Retrieve Packinit.view,Packstkinit view for Initial packing with multiple search/ Edit/ View/ Print 
FUNCTION ccsMatch12A
PARAMETER m.xyBcode, m.xyOrderNo, m.xyCtrlNo, m.xyOLNumber, m.xyCarpetNo, m.xyQuality, m.xyDesign, m.xySize, m.xyColour, m.xyOrdType,;
m.xyField, m.xyWashType, m.xySpclInst, m.xyCStatus, m.xyCarpType, m.xyNotes, m.xyPackno
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCtrlNo, m.psCtrlNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOLNumber, m.psOLNumber))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCarpetNo, m.psCarpetNo))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySize, m.psSize))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyColour, m.psColour))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyOrdType, m.psOrdType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyField, m.psField))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyWashType, m.psWashType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySpclInst, m.psSpclInst)) 
  RETURN .F.
ENDIF
IF (.NOT. EMPTY( m.psCStatus)) .AND. (.NOT. ALLTRIM( m.psCStatus) $ UPPER(m.xyCStatus))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyCarpType, m.psCarpType))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psNotes)) .AND. (.NOT. ALLTRIM(m.psNotes) $ UPPER(m.xyNotes))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyPackno, m.psPackno))
  RETURN .F.
ENDIF
*
RETURN .T.
*EOF()

*This function Retrieve Delivery Due Report of Distributed order(rordelidprg) 
FUNCTION ccsMatch13
PARAMETER m.xyBcode, m.xyOrdType, m.xyWeaver

IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyOrdType, m.psOrdType))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyWeaver, m.psWeaver))
	RETURN .F.
ENDIF
*
RETURN .T.
*EOF()

* Help Function to Retrieve Card No for Order Form
FUNCTION ccsMatch14
PARAMETER m.xyCardNo
IF (.NOT. csSpSrchT_(m.xyCardNo, m.psCardNo))
  RETURN .F.
ENDIF
RETURN .T.
* EoF()

*m.xyIssdt, m.xyRetdt
FUNCTION ccsMatch15
PARAMETER m.xyBcode, m.xyDesign,  m.xySzcode, m.xyQuality, m.xyRooms, m.xyFullHalf, m.xyOrder_Type, m.xyRemark, m.xyMaster_nr, m.xyReg_nr, m.xyIR, m.xyOl_No
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySzcode, m.psSzcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyRooms, m.psRooms))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyFullHalf, m.psFullHalf))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrder_Type, m.psOrder_Type))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psRemark)) .AND. (.NOT. ALLTRIM(m.psRemark) $ UPPER(m.xyRemark))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psMaster_nr)) .AND. (.NOT. ALLTRIM(m.psMaster_nr) $ UPPER(m.xyMaster_nr))
 RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psReg_nr)) .AND. (.NOT. ALLTRIM(m.psReg_nr) $ UPPER(m.xyReg_nr))
 RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyIR, m.psIR))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOl_No, m.psOl_No))
  RETURN .F.
ENDIF
*IF m.psLostDamageDt="..."   && show only filled date
*	If empty(m.xyLostDamageDt)
*		RETURN .F.
*	ENDIF
*ENDIF
*
RETURN .T.
*EOF()

*This function Retrieve Master Graph  Report (grsearch.prg) with multiple search/ Edit/ View/ Print / Send to excel
FUNCTION ccsMatch16
PARAMETER m.xyBcode, m.xyDesign,  m.xySzcode, m.xyQuality, m.xyRooms, m.xyFullHalf, m.xyOrder_Type, m.xyRemark, m.xyMaster_nr
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySzcode, m.psSzcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyRooms, m.psRooms))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyFullHalf, m.psFullHalf))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrder_Type, m.psOrder_Type))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psRemark)) .AND. (.NOT. ALLTRIM(m.psRemark) $ UPPER(m.xyRemark))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psMaster_nr)) .AND. (.NOT. ALLTRIM(m.psMaster_nr) $ UPPER(m.xyMaster_nr))
 RETURN .F.
ENDIF
*
RETURN .T.
*EOF()

*This function Retrieve Supplier Transaction  Report 
FUNCTION ccsMatch17
PARAMETER m.xyBcode, m.xyDesign,  m.xySzcode, m.xyQuality, m.xyRooms, m.xyFullHalf, m.xyOrder_Type, m.xyRemark, m.xyMaster_nr, m.xyReg_nr, m.xyIR, m.xySupplier, m.xySupIr
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySzcode, m.psSzcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyRooms, m.psRooms))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyFullHalf, m.psFullHalf))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrder_Type, m.psOrder_Type))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psRemark)) .AND. (.NOT. ALLTRIM(m.psRemark) $ UPPER(m.xyRemark))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psMaster_nr)) .AND. (.NOT. ALLTRIM(m.psMaster_nr) $ UPPER(m.xyMaster_nr))
 RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psReg_nr)) .AND. (.NOT. ALLTRIM(m.psReg_nr) $ UPPER(m.xyReg_nr))
 RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyIR, m.psIR))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySupplier, m.psSupplier))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xySupIr, m.psSupIr))
  RETURN .F.
ENDIF
*IF m.psLostDamageDt="..."   && show only filled date
*	If empty(m.xyLostDamageDt)
*		RETURN .F.
*	ENDIF
*ENDIF
*
RETURN .T.
*EOF()

*This function Retrieve Records by Multiple Choice Carpet job works i.e. Cutting,Washing,Stretching,Binding, SL_No=Category
FUNCTION ccsMatch18
PARAMETER m.xyBcode, m.xyQuality, m.xyCutsupplier,m.xyWshsupplier,m.xyStrsupplier,m.xyBinsupplier,m.xyTrimsupplier,m.xyClipsupplier,m.xyDesign,m.xyOrderNo,m.xySL_No,m.xyCarpetNo
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCutsupplier, m.psCutsupplier))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyWshsupplier, m.psWshsupplier))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyStrsupplier, m.psStrsupplier))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyBinsupplier, m.psBinsupplier))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyTrimsupplier, m.psTrimsupplier))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyClipsupplier, m.psClipsupplier))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psSLNo)) .AND. (.NOT. ALLTRIM(m.psSLNo) $ UPPER(m.xySL_No))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCarpetNo, m.psCarpetNo))
  RETURN .F.
ENDIF
*
RETURN .T.

*Same as ccsMatch18, only location search is added in 18 for Paintaing
*This function Retrieve Records by Multiple Choice Carpet job works i.e. Cutting,Washing,Stretching,Binding, SL_No=Category
FUNCTION ccsMatch19
PARAMETER m.xyBcode, m.xyQuality, m.xyCutsupplier,m.xyWshsupplier,m.xyStrsupplier,m.xyBinsupplier,m.xyDesign,m.xyOrderNo,m.xySL_No,m.xyCarpetNo,m.xyLocation
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCutsupplier, m.psCutsupplier))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyWshsupplier, m.psWshsupplier))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyStrsupplier, m.psStrsupplier))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyBinsupplier, m.psBinsupplier))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOrderNo, m.psOrderNo))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psSLNo)) .AND. (.NOT. ALLTRIM(m.psSLNo) $ UPPER(m.xySL_No))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyCarpetNo, m.psCarpetNo))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psLOCATION)) .AND. (.NOT. ALLTRIM(m.psLOCATION) $ UPPER(m.xyLOCATION))
  RETURN .F.
ENDIF
*
RETURN .T.

* Help Function to Retrieve Weaver names Record for Order issue to Supplier
FUNCTION ccsMatch20
PARAMETER m.xyWeaver,m.xyDesign,m.xyColour
IF (.NOT. csSpSrchT_(m.xyWeaver, m.psWeaver))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyColour, m.psColour))
  RETURN .F.
ENDIF
RETURN .T.
* EoF()

*Graph Order Recvd from Graph Dept, grTrimInfo15A
FUNCTION ccsMatch21
PARAMETER m.xyBcode, m.xyDesign,  m.xySzcode, m.xyQuality, m.xyKnots, m.xyMastCopy, m.xyName, m.xyRemark, m.xyIsuSlip, m.xyRSlip,m.xyOl_No,m.xyWashType
IF (.NOT. csSpSrchT_(m.xyBcode, m.psBcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyDesign, m.psDesign))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xySzcode, m.psSzcode))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyQuality, m.psQuality))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrch2T_(m.xyKnots, m.psKnots))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyMastCopy, m.psMastCopy))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyName, m.psName))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psRemark)) .AND. (.NOT. ALLTRIM(m.psRemark) $ UPPER(m.xyRemark))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psIsuSlip)) .AND. (.NOT. ALLTRIM(m.psIsuSlip) $ UPPER(m.xyIsuSlip))
 RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.psRSlip)) .AND. (.NOT. ALLTRIM(m.psRSlip) $ UPPER(m.xyRSlip))
 RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyOl_No, m.psOl_No))
  RETURN .F.
ENDIF
IF (.NOT. csSpSrchT_(m.xyWashType, m.psWashType))
  RETURN .F.
ENDIF
*
RETURN .T.
*EOF()

*Trim SEARCHALL
* Procedure to "Trim" Entered Information for Faster Search !
* Three Dots [...] could be used for: 1. ONLY EMPTY or 2. Left Matching.
* So, we have a trick to separate it. If the length is more than 3 and
* last three are three dots [...], then its left matching. If the length
* is three is first three are three dots, then it is ONLY EMPTY !
* -> For multiple piece, its just checking adding semicolon in Check Proc.!

PROCEDURE csTrimInfo
m.psBcode     = ALLTRIM(m.psBcode)
IF LEN(m.psBcode) > 3 .AND. RIGHT(m.psBcode, 3) = "..."
  m.psBcode   = LEFT(m.psBcode, LEN(m.psBcode) - 3)
ENDIF
m.psCardNo     = ALLTRIM(m.psCardNo)
IF LEN(m.psCardNo) > 3 .AND. RIGHT(m.psCardNo, 3) = "..."
  m.psCardNo     = LEFT(m.psCardNo, LEN(m.psCardNo) - 3)
ENDIF
m.psCarpetNo   = ALLTRIM(m.psCarpetNo)
IF LEN(m.psCarpetNo) > 3 .AND. RIGHT(m.psCarpetNo, 3) = "..."
  m.psCarpetNo   = LEFT(m.psCarpetNo, LEN(m.psCarpetNo) - 3)
ENDIF
m.psOrderNo    = ALLTRIM(m.psOrderNo)
IF LEN(m.psOrderNo) > 3 .AND. RIGHT(m.psOrderNo, 3) = "..."
  m.psOrderNo    = LEFT(m.psOrderNo, LEN(m.psOrderNo) - 3)
ENDIF
*m.psSupOrdNo   = ALLTRIM(m.psSupOrdNo)
*IF LEN(m.psSupOrdNo) > 3 .AND. RIGHT(m.psSupOrdNo, 3) = "..."
*  m.psSupOrdNo   = LEFT(m.psSupOrdNo, LEN(m.psSupOrdNo) - 3)
*ENDIF
m.psCtrlNo     = ALLTRIM(m.psCtrlNo)
IF LEN(m.psCtrlNo) > 3 .AND. RIGHT(m.psCtrlNo, 3) = "..."
  m.psCtrlNo     = LEFT(m.psCtrlNo, LEN(m.psCtrlNo) - 3)
ENDIF
m.psOLNumber   = ALLTRIM(m.psOLNumber)
IF LEN(m.psOLNumber) > 3 .AND. RIGHT(m.psOLNumber, 3) = "..."
  m.psOLNumber   = LEFT(m.psOLNumber, LEN(m.psOLNumber) - 3)
ENDIF
m.psQuality    = ALLTRIM(m.psQuality)
IF LEN(m.psQuality) > 3 .AND. RIGHT(m.psQuality, 3) = "..."
  m.psQuality    = LEFT(m.psQuality, LEN(m.psQuality) - 3)
ENDIF
m.psDesign     = ALLTRIM(m.psDesign)
IF LEN(m.psDesign) > 3 .AND. RIGHT(m.psDesign, 3) = "..."
  m.psDesign     = LEFT(m.psDesign, LEN(m.psDesign) - 3)
ENDIF
m.psColour     = ALLTRIM(m.psColour)
IF LEN(m.psColour) > 3 .AND. RIGHT(m.psColour, 3) = "..."
  m.psColour     = LEFT(m.psColour, LEN(m.psColour) - 3)
ENDIF
m.psOrdType   = ALLTRIM(m.psOrdType)
IF LEN(m.psOrdType) > 3 .AND. RIGHT(m.psOrdType, 3) = "..."
  m.psOrdType   = LEFT(m.psOrdType, LEN(m.psOrdType) - 3)
ENDIF
m.psField      = ALLTRIM(m.psField)
IF LEN(m.psField) > 3 .AND. RIGHT(m.psField, 3) = "..."
  m.psField      = LEFT(m.psField, LEN(m.psField) - 3)
ENDIF
m.psSize       = ALLTRIM(m.psSize)
IF LEN(m.psSize) > 3 .AND. RIGHT(m.psSize, 3) = "..."
  m.psSize       = LEFT(m.psSize, LEN(m.psSize) - 3)
ENDIF
m.psCarpType   = ALLTRIM(m.psCarpType)
IF LEN(m.psCarpType) > 3 .AND. RIGHT(m.psCarpType, 3) = "..."
  m.psCarpType   = LEFT(m.psCarpType, LEN(m.psCarpType) - 3)
ENDIF
m.psSupplier   = ALLTRIM(m.psSupplier)
IF LEN(m.psSupplier) > 3 .AND. RIGHT(m.psSupplier, 3) = "..."
  m.psSupplier   = LEFT(m.psSupplier, LEN(m.psSupplier) - 3)
ENDIF
m.psWashType   = ALLTRIM(m.psWashType)
IF LEN(m.psWashType) > 3 .AND. RIGHT(m.psWashType, 3) = "..."
  m.psWashType   = LEFT(m.psWashType, LEN(m.psWashType) - 3)
ENDIF
m.psCStatus   = ALLTRIM(m.psCStatus)
IF LEN(m.psCStatus) > 3 .AND. RIGHT(m.psCStatus, 3) = "..."
  m.psCStatus  = LEFT(m.psCStatus, LEN(m.psCStatus) - 3)
ENDIF
m.psCategory     = ALLTRIM(m.psCategory)
IF LEN(m.psCategory) > 3 .AND. RIGHT(m.psCategory, 3) = "..."
  m.psCategory     = LEFT(m.psCategory, LEN(m.psCategory) - 3)
ENDIF
*m.psWeaver     = ALLTRIM(m.psWeaver) 
*IF LEN(m.psWeaver) > 3 .AND. RIGHT(m.psWeaver, 3) = "..."
 * m.psWeaver     = LEFT(m.psWeaver, LEN(m.psWeaver) - 3)
*ENDIF
* For the rest of here, since "Text Match" (at any position) and "Start
* With" (left match) will be same when we reduce last three dots, we just
* leave it and let the Check-Routine do the rest of the job !
m.psLoomdt     = m.psLoomdt
m.psEstShip_Dt = m.psEstShip_Dt
m.psWeaver	   = ALLTRIM(m.psWeaver)
m.psNotes	   = ALLTRIM(m.psNotes)
m.psComment    = ALLTRIM(m.psComment)
m.psQltComment = ALLTRIM(m.psQltComment)
m.psSpclInst   = ALLTRIM(m.psSpclInst)
m.psWashInst   = ALLTRIM(m.psWashInst)
m.psSLNO       = ALLTRIM(m.psSLNO)
m.psLocation   = ALLTRIM(m.psLocation)
RETURN
* EoP()

PROCEDURE csTrimInfo3a
m.psBcode     = ALLTRIM(m.psBcode)
IF LEN(m.psBcode) > 3 .AND. RIGHT(m.psBcode, 3) = "..."
  m.psBcode   = LEFT(m.psBcode, LEN(m.psBcode) - 3)
ENDIF
m.psCarpetNo   = ALLTRIM(m.psCarpetNo)
IF LEN(m.psCarpetNo) > 3 .AND. RIGHT(m.psCarpetNo, 3) = "..."
  m.psCarpetNo   = LEFT(m.psCarpetNo, LEN(m.psCarpetNo) - 3)
ENDIF
m.psOrderNo    = ALLTRIM(m.psOrderNo)
IF LEN(m.psOrderNo) > 3 .AND. RIGHT(m.psOrderNo, 3) = "..."
  m.psOrderNo    = LEFT(m.psOrderNo, LEN(m.psOrderNo) - 3)
ENDIF
m.psCtrlNo     = ALLTRIM(m.psCtrlNo)
IF LEN(m.psCtrlNo) > 3 .AND. RIGHT(m.psCtrlNo, 3) = "..."
  m.psCtrlNo     = LEFT(m.psCtrlNo, LEN(m.psCtrlNo) - 3)
ENDIF
m.psOLNumber   = ALLTRIM(m.psOLNumber)
IF LEN(m.psOLNumber) > 3 .AND. RIGHT(m.psOLNumber, 3) = "..."
  m.psOLNumber   = LEFT(m.psOLNumber, LEN(m.psOLNumber) - 3)
ENDIF
m.psQuality    = ALLTRIM(m.psQuality)
IF LEN(m.psQuality) > 3 .AND. RIGHT(m.psQuality, 3) = "..."
  m.psQuality    = LEFT(m.psQuality, LEN(m.psQuality) - 3)
ENDIF
m.psDesign     = ALLTRIM(m.psDesign)
IF LEN(m.psDesign) > 3 .AND. RIGHT(m.psDesign, 3) = "..."
  m.psDesign     = LEFT(m.psDesign, LEN(m.psDesign) - 3)
ENDIF
m.psColour     = ALLTRIM(m.psColour)
IF LEN(m.psColour) > 3 .AND. RIGHT(m.psColour, 3) = "..."
  m.psColour     = LEFT(m.psColour, LEN(m.psColour) - 3)
ENDIF
m.psSpclInst     = ALLTRIM(m.psSpclInst)
IF LEN(m.psSpclInst) > 3 .AND. RIGHT(m.psSpclInst, 3) = "..."
  m.psSpclInst     = LEFT(m.psSpclInst, LEN(m.psSpclInst) - 3)
ENDIF
m.psInvno     = ALLTRIM(m.psInvno)
IF LEN(m.psInvno) > 3 .AND. RIGHT(m.psInvno, 3) = "..."
  m.psInvno     = LEFT(m.psInvno, LEN(m.psInvno) - 3)
ENDIF
RETURN
* EoP()


*Trim Procedure for Stock Carpet
PROCEDURE csTrimInfos
m.psBcode     = ALLTRIM(m.psBcode)
IF LEN(m.psBcode) > 3 .AND. RIGHT(m.psBcode, 3) = "..."
  m.psBcode   = LEFT(m.psBcode, LEN(m.psBcode) - 3)
ENDIF
m.psCardNo     = ALLTRIM(m.psCardNo)
IF LEN(m.psCardNo) > 3 .AND. RIGHT(m.psCardNo, 3) = "..."
  m.psCardNo     = LEFT(m.psCardNo, LEN(m.psCardNo) - 3)
ENDIF
m.psCarpetNo   = ALLTRIM(m.psCarpetNo)
IF LEN(m.psCarpetNo) > 3 .AND. RIGHT(m.psCarpetNo, 3) = "..."
  m.psCarpetNo   = LEFT(m.psCarpetNo, LEN(m.psCarpetNo) - 3)
ENDIF
m.psOrderNo    = ALLTRIM(m.psOrderNo)
IF LEN(m.psOrderNo) > 3 .AND. RIGHT(m.psOrderNo, 3) = "..."
  m.psOrderNo    = LEFT(m.psOrderNo, LEN(m.psOrderNo) - 3)
ENDIF
*m.psSupOrdNo   = ALLTRIM(m.psSupOrdNo)
*IF LEN(m.psSupOrdNo) > 3 .AND. RIGHT(m.psSupOrdNo, 3) = "..."
*  m.psSupOrdNo   = LEFT(m.psSupOrdNo, LEN(m.psSupOrdNo) - 3)
*ENDIF
m.psCtrlNo     = ALLTRIM(m.psCtrlNo)
IF LEN(m.psCtrlNo) > 3 .AND. RIGHT(m.psCtrlNo, 3) = "..."
  m.psCtrlNo     = LEFT(m.psCtrlNo, LEN(m.psCtrlNo) - 3)
ENDIF
m.psOLNumber   = ALLTRIM(m.psOLNumber)
IF LEN(m.psOLNumber) > 3 .AND. RIGHT(m.psOLNumber, 3) = "..."
  m.psOLNumber   = LEFT(m.psOLNumber, LEN(m.psOLNumber) - 3)
ENDIF
m.psQuality    = ALLTRIM(m.psQuality)
IF LEN(m.psQuality) > 3 .AND. RIGHT(m.psQuality, 3) = "..."
  m.psQuality    = LEFT(m.psQuality, LEN(m.psQuality) - 3)
ENDIF
m.psDesign     = ALLTRIM(m.psDesign)
IF LEN(m.psDesign) > 3 .AND. RIGHT(m.psDesign, 3) = "..."
  m.psDesign     = LEFT(m.psDesign, LEN(m.psDesign) - 3)
ENDIF
m.psColour     = ALLTRIM(m.psColour)
IF LEN(m.psColour) > 3 .AND. RIGHT(m.psColour, 3) = "..."
  m.psColour     = LEFT(m.psColour, LEN(m.psColour) - 3)
ENDIF
m.psOrdType   = ALLTRIM(m.psOrdType)
IF LEN(m.psOrdType) > 3 .AND. RIGHT(m.psOrdType, 3) = "..."
  m.psOrdType   = LEFT(m.psOrdType, LEN(m.psOrdType) - 3)
ENDIF
m.psField      = ALLTRIM(m.psField)
IF LEN(m.psField) > 3 .AND. RIGHT(m.psField, 3) = "..."
  m.psField      = LEFT(m.psField, LEN(m.psField) - 3)
ENDIF
m.psSize       = ALLTRIM(m.psSize)
IF LEN(m.psSize) > 3 .AND. RIGHT(m.psSize, 3) = "..."
  m.psSize       = LEFT(m.psSize, LEN(m.psSize) - 3)
ENDIF
m.psCarpType   = ALLTRIM(m.psCarpType)
IF LEN(m.psCarpType) > 3 .AND. RIGHT(m.psCarpType, 3) = "..."
  m.psCarpType   = LEFT(m.psCarpType, LEN(m.psCarpType) - 3)
ENDIF
m.psSupplier   = ALLTRIM(m.psSupplier)
IF LEN(m.psSupplier) > 3 .AND. RIGHT(m.psSupplier, 3) = "..."
  m.psSupplier   = LEFT(m.psSupplier, LEN(m.psSupplier) - 3)
ENDIF
m.psWashType   = ALLTRIM(m.psWashType)
IF LEN(m.psWashType) > 3 .AND. RIGHT(m.psWashType, 3) = "..."
  m.psWashType   = LEFT(m.psWashType, LEN(m.psWashType) - 3)
ENDIF
m.psCStatus   = ALLTRIM(m.psCStatus)
IF LEN(m.psCStatus) > 3 .AND. RIGHT(m.psCStatus, 3) = "..."
  m.psCStatus  = LEFT(m.psCStatus, LEN(m.psCStatus) - 3)
ENDIF
m.psCategory     = ALLTRIM(m.psCategory)
IF LEN(m.psCategory) > 3 .AND. RIGHT(m.psCategory, 3) = "..."
  m.psCategory     = LEFT(m.psCategory, LEN(m.psCategory) - 3)
ENDIF
*m.psWeaver     = ALLTRIM(m.psWeaver) 
*IF LEN(m.psWeaver) > 3 .AND. RIGHT(m.psWeaver, 3) = "..."
 * m.psWeaver     = LEFT(m.psWeaver, LEN(m.psWeaver) - 3)
*ENDIF
* For the rest of here, since "Text Match" (at any position) and "Start
* With" (left match) will be same when we reduce last three dots, we just
* leave it and let the Check-Routine do the rest of the job !
m.psPackno     = ALLTRIM(m.psPackno)
IF LEN(m.psPackno) > 3 .AND. RIGHT(m.psPackno, 3) = "..."
  m.psPackno   = LEFT(m.psPackno, LEN(m.psPackno) - 3)
ENDIF
m.psLoomdt     = m.psLoomdt
m.psEstShip_Dt = m.psEstShip_Dt
m.psWeaver	   = ALLTRIM(m.psWeaver)
m.psNotes	   = ALLTRIM(m.psNotes)
m.psComment    = ALLTRIM(m.psComment)
m.psQltComment = ALLTRIM(m.psQltComment)
m.psSpclInst   = ALLTRIM(m.psSpclInst)
m.psWashInst   = ALLTRIM(m.psWashInst)
m.psYrPhy      = ALLTRIM(m.psYrPhy)
*m.psPackno	   = ALLTRIM(m.psPackno)
RETURN
*EoP()

*Trim GRAPHSEARCH
* Procedure to "Trim" Entered Information for Faster Search !
* Three Dots [...] could be used for: 1. ONLY EMPTY or 2. Left Matching.
* So, we have a trick to separate it. If the length is more than 3 and
* last three are three dots [...], then its left matching. If the length
* is three is first three are three dots, then it is ONLY EMPTY !
* -> For multiple piece, its just checking adding semicolon in Check Proc.!

PROCEDURE grTrimInfo && graph register
m.psBcode     = ALLTRIM(m.psBcode)
IF LEN(m.psBcode) > 3 .AND. RIGHT(m.psBcode, 3) = "..."
  m.psBcode   = LEFT(m.psBcode, LEN(m.psBcode) - 3)
ENDIF
m.psQuality    = ALLTRIM(m.psQuality)
IF LEN(m.psQuality) > 3 .AND. RIGHT(m.psQuality, 3) = "..."
  m.psQuality    = LEFT(m.psQuality, LEN(m.psQuality) - 3)
ENDIF
m.psDesign     = ALLTRIM(m.psDesign)
IF LEN(m.psDesign) > 3 .AND. RIGHT(m.psDesign, 3) = "..."
  m.psDesign     = LEFT(m.psDesign, LEN(m.psDesign) - 3)
ENDIF
m.psSzcode       = ALLTRIM(m.psSzcode)
IF LEN(m.psSzcode) > 3 .AND. RIGHT(m.psSzcode, 3) = "..."
  m.psSzcode       = LEFT(m.psSize, LEN(m.psSzcode) - 3)
ENDIF
m.psOrder_Type   = ALLTRIM(m.psOrder_Type)
IF LEN(m.psOrder_Type) > 3 .AND. RIGHT(m.psOrder_Type, 3) = "..."
  m.psOrder_Type   = LEFT(m.psOrder_Type, LEN(m.psOrder_Type) - 3)
ENDIF
m.psRooms   = ALLTRIM(m.psRooms)
IF LEN(m.psRooms) > 3 .AND. RIGHT(m.psRooms, 3) = "..."
  m.psRooms   = LEFT(m.psRooms, LEN(m.psRooms) - 3)
ENDIF
m.psFullHalf   = ALLTRIM(m.psFullHalf)
IF LEN(m.psFullHalf) > 3 .AND. RIGHT(m.psFullHalf, 3) = "..."
  m.psFullHalf   = LEFT(m.psFullHalf, LEN(m.psFullHalf) - 3)
ENDIF
m.psIR   = ALLTRIM(m.psIR)
IF LEN(m.psIR) > 3 .AND. RIGHT(m.psIR, 3) = "..."
  m.psIR  = LEFT(m.psIR, LEN(m.psIR) - 3)
ENDIF
m.psOl_No   = ALLTRIM(m.psOl_No)
IF LEN(m.psOl_No) > 3 .AND. RIGHT(m.psOl_No, 3) = "..."
  m.psOl_No  = LEFT(m.psOl_No, LEN(m.psOl_No) - 3)
ENDIF
m.psRemark	  = m.psRemark
RETURN
* EoP()

PROCEDURE grmTrimInfo && master graph
m.psBcode     = ALLTRIM(m.psBcode)
IF LEN(m.psBcode) > 3 .AND. RIGHT(m.psBcode, 3) = "..."
  m.psBcode   = LEFT(m.psBcode, LEN(m.psBcode) - 3)
ENDIF
m.psQuality    = ALLTRIM(m.psQuality)
IF LEN(m.psQuality) > 3 .AND. RIGHT(m.psQuality, 3) = "..."
  m.psQuality    = LEFT(m.psQuality, LEN(m.psQuality) - 3)
ENDIF
m.psDesign     = ALLTRIM(m.psDesign)
IF LEN(m.psDesign) > 3 .AND. RIGHT(m.psDesign, 3) = "..."
  m.psDesign     = LEFT(m.psDesign, LEN(m.psDesign) - 3)
ENDIF
m.psSzcode       = ALLTRIM(m.psSzcode)
IF LEN(m.psSzcode) > 3 .AND. RIGHT(m.psSzcode, 3) = "..."
  m.psSzcode       = LEFT(m.psSize, LEN(m.psSzcode) - 3)
ENDIF
m.psOrder_Type   = ALLTRIM(m.psOrder_Type)
IF LEN(m.psOrder_Type) > 3 .AND. RIGHT(m.psOrder_Type, 3) = "..."
  m.psOrder_Type   = LEFT(m.psOrder_Type, LEN(m.psOrder_Type) - 3)
ENDIF
m.psRooms   = ALLTRIM(m.psRooms)
IF LEN(m.psRooms) > 3 .AND. RIGHT(m.psRooms, 3) = "..."
  m.psRooms   = LEFT(m.psRooms, LEN(m.psRooms) - 3)
ENDIF
m.psFullHalf   = ALLTRIM(m.psFullHalf)
IF LEN(m.psFullHalf) > 3 .AND. RIGHT(m.psFullHalf, 3) = "..."
  m.psFullHalf   = LEFT(m.psFullHalf, LEN(m.psFullHalf) - 3)
ENDIF
m.psRemark	  = m.psRemark
RETURN
* EoP()

PROCEDURE grSTrimInfo && Supplier register
m.psBcode     = ALLTRIM(m.psBcode)
IF LEN(m.psBcode) > 3 .AND. RIGHT(m.psBcode, 3) = "..."
  m.psBcode   = LEFT(m.psBcode, LEN(m.psBcode) - 3)
ENDIF
m.psQuality    = ALLTRIM(m.psQuality)
IF LEN(m.psQuality) > 3 .AND. RIGHT(m.psQuality, 3) = "..."
  m.psQuality    = LEFT(m.psQuality, LEN(m.psQuality) - 3)
ENDIF
m.psDesign     = ALLTRIM(m.psDesign)
IF LEN(m.psDesign) > 3 .AND. RIGHT(m.psDesign, 3) = "..."
  m.psDesign     = LEFT(m.psDesign, LEN(m.psDesign) - 3)
ENDIF
m.psSzcode       = ALLTRIM(m.psSzcode)
IF LEN(m.psSzcode) > 3 .AND. RIGHT(m.psSzcode, 3) = "..."
  m.psSzcode       = LEFT(m.psSize, LEN(m.psSzcode) - 3)
ENDIF
m.psOrder_Type   = ALLTRIM(m.psOrder_Type)
IF LEN(m.psOrder_Type) > 3 .AND. RIGHT(m.psOrder_Type, 3) = "..."
  m.psOrder_Type   = LEFT(m.psOrder_Type, LEN(m.psOrder_Type) - 3)
ENDIF
m.psRooms   = ALLTRIM(m.psRooms)
IF LEN(m.psRooms) > 3 .AND. RIGHT(m.psRooms, 3) = "..."
  m.psRooms   = LEFT(m.psRooms, LEN(m.psRooms) - 3)
ENDIF
m.psFullHalf   = ALLTRIM(m.psFullHalf)
IF LEN(m.psFullHalf) > 3 .AND. RIGHT(m.psFullHalf, 3) = "..."
  m.psFullHalf   = LEFT(m.psFullHalf, LEN(m.psFullHalf) - 3)
ENDIF
m.psIR   = ALLTRIM(m.psIR)
IF LEN(m.psIR) > 3 .AND. RIGHT(m.psIR, 3) = "..."
  m.psIR  = LEFT(m.psIR, LEN(m.psIR) - 3)
ENDIF
m.psSupplier = ALLTRIM(m.psSupplier)
IF LEN(m.psSupplier) > 3 .AND. RIGHT(m.psSupplier, 3) = "..."
  m.psSupplier  = LEFT(m.psSupplier, LEN(m.psSupplier) - 3)
ENDIF
m.psSupIR   = ALLTRIM(m.psSupIR)
IF LEN(m.psSupIR) > 3 .AND. RIGHT(m.psSupIR, 3) = "..."
  m.psSupIR  = LEFT(m.psSUPIR, LEN(m.psSupIR) - 3)
ENDIF
m.psRemark	  = m.psRemark
RETURN


PROCEDURE grTrimInfo15A && Ggraph Order & Receive Graph Dept ccsmatch15A
m.psBcode     = ALLTRIM(m.psBcode)
IF LEN(m.psBcode) > 3 .AND. RIGHT(m.psBcode, 3) = "..."
  m.psBcode   = LEFT(m.psBcode, LEN(m.psBcode) - 3)
ENDIF
m.psQuality    = ALLTRIM(m.psQuality)
IF LEN(m.psQuality) > 3 .AND. RIGHT(m.psQuality, 3) = "..."
  m.psQuality    = LEFT(m.psQuality, LEN(m.psQuality) - 3)
ENDIF
m.psDesign     = ALLTRIM(m.psDesign)
IF LEN(m.psDesign) > 3 .AND. RIGHT(m.psDesign, 3) = "..."
  m.psDesign     = LEFT(m.psDesign, LEN(m.psDesign) - 3)
ENDIF
m.psSzcode       = ALLTRIM(m.psSzcode)
IF LEN(m.psSzcode) > 3 .AND. RIGHT(m.psSzcode, 3) = "..."
  m.psSzcode       = LEFT(m.psSize, LEN(m.psSzcode) - 3)
ENDIF
m.psName  = ALLTRIM(m.psName)
IF LEN(m.psName) > 3 .AND. RIGHT(m.psName, 3) = "..."
  m.psName   = LEFT(m.psName, LEN(m.psName) - 3)
ENDIF
m.psKnots   = ALLTRIM(m.psKnots)
IF LEN(m.psKnots) > 3 .AND. RIGHT(m.psKnots, 3) = "..."
  m.psKnots   = LEFT(m.psKnots, LEN(m.psRooms) - 3)
ENDIF
m.psMastCopy   = ALLTRIM(m.psMastCopy)
IF LEN(m.psMastCopy) > 3 .AND. RIGHT(m.psMastCopy, 3) = "..."
  m.psMastCopy   = LEFT(m.psMastCopy, LEN(m.psMastCopy) - 3)
ENDIF
m.psIsuSlip   = ALLTRIM(m.psIsuSlip)
IF LEN(m.psIsuSlip) > 3 .AND. RIGHT(m.psIsuSlip, 3) = "..."
  m.psIsuSlip  = LEFT(m.psIsuSlip, LEN(m.psIsuSlip) - 3)
ENDIF
m.psRSlip   = ALLTRIM(m.psRSlip)
IF LEN(m.psRSlip) > 3 .AND. RIGHT(m.psRSlip, 3) = "..."
  m.psRSlip  = LEFT(m.psRSlip, LEN(m.psRSlip) - 3)
ENDIF
m.psWashType   = ALLTRIM(m.psWashType)
IF LEN(m.psWashType) > 3 .AND. RIGHT(m.psWashType, 3) = "..."
  m.psWashType   = LEFT(m.psWashType, LEN(m.psWashType) - 3)
ENDIF
m.psRemark	  = m.psRemark
RETURN

*For Triming Weaver name for retrieving data of Many weavers in onloom report
PROCEDURE csTrimInfo2
m.psWeaver     = ALLTRIM(m.psWeaver)
IF LEN(m.psWeaver) > 3 .AND. RIGHT(m.psWeaver, 3) = "..."
  m.psWeaver     = LEFT(m.psWeaver, LEN(m.psWeaver) - 3)
ENDIF
RETURN
*EoP()

*For Triming po_no retrieving data of Many POs in PO Report
PROCEDURE csTrimInfo3
m.psOrderNo    = ALLTRIM(m.psOrderNo)
IF LEN(m.psOrderNo) > 3 .AND. RIGHT(m.psOrderNo, 3) = "..."
  m.psOrderNo    = LEFT(m.psOrderNo, LEN(m.psOrderNo) - 3)
ENDIF
RETURN
*EoP()

*For Triming po_no retrieving data of Many Category in Crosstab CrossGrade Report
PROCEDURE csTrimInfo4
m.psCategory     = ALLTRIM(m.psCategory)
IF LEN(m.psCategory) > 3 .AND. RIGHT(m.psCategory, 3) = "..."
  m.psCategory     = LEFT(m.psCategory, LEN(m.psCategory) - 3)
ENDIF
RETURN
*EoP()

*For Triming PRC-Finish, EstShipDt Report
PROCEDURE csTrimInfo5
m.psBcode     = ALLTRIM(m.psBcode)
IF LEN(m.psBcode) > 3 .AND. RIGHT(m.psBcode, 3) = "..."
  m.psBcode   = LEFT(m.psBcode, LEN(m.psBcode) - 3)
ENDIF
m.psQuality    = ALLTRIM(m.psQuality)
IF LEN(m.psQuality) > 3 .AND. RIGHT(m.psQuality, 3) = "..."
  m.psQuality    = LEFT(m.psQuality, LEN(m.psQuality) - 3)
ENDIF
m.psWeaver     = ALLTRIM(m.psWeaver)
IF LEN(m.psWeaver) > 3 .AND. RIGHT(m.psWeaver, 3) = "..."
  m.psWeaver     = LEFT(m.psWeaver, LEN(m.psWeaver) - 3)
ENDIF
m.psGrade     = ALLTRIM(m.psGrade)
IF LEN(m.psGrade) > 3 .AND. RIGHT(m.psGrade, 3) = "..."
  m.psWeaver     = LEFT(m.psWeaver, LEN(m.psWeaver) - 3)
ENDIF
m.psOrder_Type   = ALLTRIM(m.psOrder_Type)
IF LEN(m.psOrder_Type) > 3 .AND. RIGHT(m.psOrder_Type, 3) = "..."
  m.psOrder_Type   = LEFT(m.psOrder_Type, LEN(m.psOrder_Type) - 3)
ENDIF
m.psBillNo   = ALLTRIM(m.psBillNo)
IF LEN(m.psBillNo) > 3 .AND. RIGHT(m.psBillNo, 3) = "..."
  m.psBillNo   = LEFT(m.psBillNo, LEN(m.psBillNo) - 3)
ENDIF
m.psCarpetNo   = ALLTRIM(m.psCarpetNo)
IF LEN(m.psCarpetNo) > 3 .AND. RIGHT(m.psCarpetNo, 3) = "..."
  m.psCarpetNo   = LEFT(m.psCarpetNo, LEN(m.psCarpetNo) - 3)
ENDIF
RETURN
* EoP()

*For Triming Card No for retrieving data of Many Card No for Order Form
PROCEDURE csTrimInfo6
m.psCardNo     = ALLTRIM(m.psCardNo)
IF LEN(m.psCardNo) > 3 .AND. RIGHT(m.psCardNo, 3) = "..."
  m.psCardNo     = LEFT(m.psCardNo, LEN(m.psCardNo) - 3)
ENDIF
RETURN
*EoP()

*For Triming ccMatch18, Carpet Job Works,Cutting,Washing,Strteching,binding
PROCEDURE csTrimInfo7
m.psBcode     = ALLTRIM(m.psBcode)
IF LEN(m.psBcode) > 3 .AND. RIGHT(m.psBcode, 3) = "..."
  m.psBcode   = LEFT(m.psBcode, LEN(m.psBcode) - 3)
ENDIF
m.psQuality    = ALLTRIM(m.psQuality)
IF LEN(m.psQuality) > 3 .AND. RIGHT(m.psQuality, 3) = "..."
  m.psQuality    = LEFT(m.psQuality, LEN(m.psQuality) - 3)
ENDIF
m.psCutsupplier     = ALLTRIM(m.psCutsupplier)
IF LEN(m.psCutsupplier) > 3 .AND. RIGHT(m.psCutsupplier, 3) = "..."
  m.psCutsupplier     = LEFT(m.psCutsupplier, LEN(m.psCutsupplier) - 3)
ENDIF
m.psWshSupplier     = ALLTRIM(m.psWshSupplier)
IF LEN(m.psWshSupplier) > 3 .AND. RIGHT(m.psWshSupplier, 3) = "..."
  m.psWshSupplier     = LEFT(m.psWshSupplier, LEN(m.psWshSupplier) - 3)
ENDIF
m.psStrSupplier     = ALLTRIM(m.psStrSupplier)
IF LEN(m.psStrSupplier) > 3 .AND. RIGHT(m.psStrSupplier, 3) = "..."
  m.psStrSupplier     = LEFT(m.psStrSupplier, LEN(m.psStrSupplier) - 3)
ENDIF
m.psBinSupplier     = ALLTRIM(m.psBinSupplier)
IF LEN(m.psBinSupplier) > 3 .AND. RIGHT(m.psBinSupplier, 3) = "..."
  m.psBinSupplier     = LEFT(m.psBinSupplier, LEN(m.psBinSupplier) - 3)
ENDIF
m.psTrimSupplier     = ALLTRIM(m.psTrimSupplier)
IF LEN(m.psTrimSupplier) > 3 .AND. RIGHT(m.psTrimSupplier, 3) = "..."
  m.psTrimSupplier     = LEFT(m.psTrimSupplier, LEN(m.psTrimSupplier) - 3)
ENDIF
m.psClipSupplier     = ALLTRIM(m.psClipSupplier)
IF LEN(m.psClipSupplier) > 3 .AND. RIGHT(m.psClipSupplier, 3) = "..."
  m.psClipSupplier     = LEFT(m.psClipSupplier, LEN(m.psClipSupplier) - 3)
ENDIF
m.psDesign     = ALLTRIM(m.psDesign)
IF LEN(m.psDesign) > 3 .AND. RIGHT(m.psDesign, 3) = "..."
  m.psDesign     = LEFT(m.psDesign, LEN(m.psDesign) - 3)
ENDIF
m.psCarpetNo   = ALLTRIM(m.psCarpetNo)
IF LEN(m.psCarpetNo) > 3 .AND. RIGHT(m.psCarpetNo, 3) = "..."
  m.psCarpetNo   = LEFT(m.psCarpetNo, LEN(m.psCarpetNo) - 3)
ENDIF
m.psSLNO  = ALLTRIM(m.psSLNO)
RETURN
* EoP()


*For Triming ccMatch19, Carpet Job Works,Painting
PROCEDURE csTrimInfo8
m.psBcode     = ALLTRIM(m.psBcode)
IF LEN(m.psBcode) > 3 .AND. RIGHT(m.psBcode, 3) = "..."
  m.psBcode   = LEFT(m.psBcode, LEN(m.psBcode) - 3)
ENDIF
m.psQuality    = ALLTRIM(m.psQuality)
IF LEN(m.psQuality) > 3 .AND. RIGHT(m.psQuality, 3) = "..."
  m.psQuality    = LEFT(m.psQuality, LEN(m.psQuality) - 3)
ENDIF
m.psCutsupplier     = ALLTRIM(m.psCutsupplier)
IF LEN(m.psCutsupplier) > 3 .AND. RIGHT(m.psCutsupplier, 3) = "..."
  m.psCutsupplier     = LEFT(m.psCutsupplier, LEN(m.psCutsupplier) - 3)
ENDIF
m.psWshSupplier     = ALLTRIM(m.psWshSupplier)
IF LEN(m.psWshSupplier) > 3 .AND. RIGHT(m.psWshSupplier, 3) = "..."
  m.psWshSupplier     = LEFT(m.psWshSupplier, LEN(m.psWshSupplier) - 3)
ENDIF
m.psStrSupplier     = ALLTRIM(m.psStrSupplier)
IF LEN(m.psStrSupplier) > 3 .AND. RIGHT(m.psStrSupplier, 3) = "..."
  m.psStrSupplier     = LEFT(m.psStrSupplier, LEN(m.psStrSupplier) - 3)
ENDIF
m.psBinSupplier     = ALLTRIM(m.psBinSupplier)
IF LEN(m.psBinSupplier) > 3 .AND. RIGHT(m.psBinSupplier, 3) = "..."
  m.psBinSupplier     = LEFT(m.psBinSupplier, LEN(m.psBinSupplier) - 3)
ENDIF
m.psDesign     = ALLTRIM(m.psDesign)
IF LEN(m.psDesign) > 3 .AND. RIGHT(m.psDesign, 3) = "..."
  m.psDesign     = LEFT(m.psDesign, LEN(m.psDesign) - 3)
ENDIF
m.psCarpetNo   = ALLTRIM(m.psCarpetNo)
IF LEN(m.psCarpetNo) > 3 .AND. RIGHT(m.psCarpetNo, 3) = "..."
  m.psCarpetNo   = LEFT(m.psCarpetNo, LEN(m.psCarpetNo) - 3)
ENDIF
m.psSLNO  = ALLTRIM(m.psSLNO)
m.psLOCATION  = ALLTRIM(m.psLOCATION)
RETURN
* EoP()

*For Triming Weaver, Desing, Colour for ccMatch20
PROCEDURE csTrimInfo9
m.psWeaver     = ALLTRIM(m.psWeaver)
IF LEN(m.psWeaver) > 3 .AND. RIGHT(m.psWeaver, 3) = "..."
  m.psWeaver     = LEFT(m.psWeaver, LEN(m.psWeaver) - 3)
ENDIF
m.psDesign     = ALLTRIM(m.psDesign)
IF LEN(m.psDesign) > 3 .AND. RIGHT(m.psDesign, 3) = "..."
  m.psDesign     = LEFT(m.psDesign, LEN(m.psDesign) - 3)
ENDIF
m.psColour     = ALLTRIM(m.psColour)
IF LEN(m.psColour) > 3 .AND. RIGHT(m.psColour, 3) = "..."
  m.psColour     = LEFT(m.psColour, LEN(m.psColour) - 3)
ENDIF
RETURN
*EoP()

* Function for Special Search Routines !
* -> In case of "Multi-Search", "Left-Match" and "Must-Empty" !
FUNCTION csSpSrchT_
PARAMETER m.csSrchDVal, m.csSrchTxt
DO CASE
  CASE EMPTY(m.csSrchTxt)
    RETURN .T.
  CASE LEFT(m.csSrchTxt, 3) = "..."
    IF EMPTY(m.csSrchDVal)
      RETURN .T.
    ENDIF
  CASE ";" $ m.csSrchTxt
    IF EMPTY(m.csSrchDVal)
      RETURN .F.
    ENDIF
    IF ";" + ALLTRIM(m.csSrchDVal) + ";" $ ";" + m.csSrchTxt + ";"
      RETURN .T.
    ENDIF
OTHERWISE
  IF LEN(m.csSrchDVal) > LEN(m.csSrchTxt)
    IF LEFT(UPPER(m.csSrchDVal), LEN(m.csSrchTxt)) = m.csSrchTxt
      RETURN .T.
    Else
    	*Wait Window "Invalid Input, Please enter correct data!!" Nowait   && Temporarily withdrawn by ramesh because in weaver report error message displayed.
		RETURN .F.
    ENDIF
  ENDIF
ENDCASE
RETURN .F.

* EoF()



* Second Function for Special Search Routines !
* -> In case of "Left-Match", "Must-Empty" and "Text-Match-Any-Position" !

FUNCTION csSpSrch2T_
PARAMETER m.csSrchDVal, m.csSrchTxt
DO CASE
  CASE EMPTY(m.csSrchTxt)
    RETURN .T.
  CASE LEFT(m.csSrchTxt, 3) = "..." .AND. EMPTY(m.csSrchDVal)
    RETURN .T.
  CASE LEN(m.csSrchTxt) > 3 .AND. RIGHT(m.csSrchTxt, 3) = "..."
    IF LEFT(UPPER(m.csSrchDVal), LEN(m.csSrchTxt) - 3) = ;
      LEFT(m.csSrchTxt, LEN(m.csSrchTxt) - 3)
      RETURN .T.
    ENDIF
OTHERWISE
  IF m.csSrchTxt $ m.csSrchDVal
    RETURN .T.
  ENDIF
ENDCASE
RETURN .F.

* EoF()

**Search Date
FUNCTION csSpSrch3T_
PARAMETER m.csSrchDVal, m.csSrchTxt
DO CASE
  CASE EMPTY(m.csSrchTxt)
    RETURN .T.
  CASE !EMPTY(m.csSrchTxt)
   	IF m.csSrchDVal=m.csSrchTxt
   		RETURN .T.
   	ENDIF
ENDCASE
RETURN .F.
* EoF()

* Function to Check Card Number ! It must be Unique - or EMPTY (0) but with
* a warning.
* -> If it is EMPTY (0), Loom Date should also be EMPTY !

** Remarks:by Ramesh Little Problem with this function, Can Not Return 0

FUNCTION csoCrdNrCh
PARAMETER m.csoCardNo, m.csoSrInCur, m.csoOldCNo
IF LASTKEY() = 5 .OR. LASTKEY() = 19 .OR. LASTKEY() = 15 .OR. LASTKEY() = 18
  RETURN .T.
ENDIF
IF m.csoCardNo < 0 
 ?? CHR(7)
	WAIT WINDOW "Please Enter a Positive Number or Zero (0) !" NOWAIT
	RETURN 0
ENDIF
IF m.csoCardNo = 0
  IF YesNo("Are you sure to leave Card Number EMPTY (0) now", " ", "", 1)
    * Mr. Choedak told that Loom Date is not related to Card-Number !!
    * m.LoomDate_  = CTOD("")
    * SHOW GET m.LoomDate_
    RETURN .T.
  ENDIF
  ?? CHR(7)
  WAIT WINDOW "Please Enter Right Card Number !" NOWAIT
*  RETURN 0 &&Original Defination
  RETURN .T.
ENDIF
*
PRIVATE m.ccncVar1, m.ccncVar2, m.ccncVar3, m.ccncVar4, m.ccncVar5
m.csoOldCNo = IIF(EMPTY(m.csoOldCNo), -999, m.csoOldCNo) 
m.ccncVar1  = ORDER("Casupord")
m.ccncVar3  = RECNO("Casupord")
SET ORDER TO CARD_NO   IN Casupord
*IF m.csoCardNo # m.csoOldCNo .AND. SEEK(m.csoCardNo, "Casupord") && ORGIGINAL CODE
IF m.csoCardNo # m.csoOldCNo .AND. SEEK(STR(m.csoCardNo), "Casupord") && MODIFIED BY RAMESH
  ?? CHR(7)
  WAIT WINDOW "Card Number: " + ALLTRIM(STR(m.csoCardNo)) + " Already Exists, Not Allowed !" NOWAIT
  SET ORDER TO (m.ccncVar1)  IN Casupord
  IF m.ccncVar3 <= RECCOUNT("Casupord")
 	  GOTO m.ccncVar3 IN Casupord
  ENDIF
 * RETURN 0 && Original Definition
  RETURN .T.
ENDIF
 SET ORDER TO (m.ccncVar1)  IN Casupord
  IF m.ccncVar3 <= RECCOUNT("Casupord")
     GOTO m.ccncVar3 IN Casupord
  ENDIF
  RETURN .T.
  
*** Deleted by Ramesh
* EoF()

* Function to Show the Amount in Word (It will show only upto 999,999,999.99)!
FUNCTION NumbInWord
PARAMETER m.ConvNumber, m.TxtForCent
IF EMPTY(m.TxtForCent)
  m.TxtForCent = "CENT"
ENDIF
PRIVATE m.xNegative, m.xMillion, m.xThousand, m.xRest, m.xCent, ;
  m.xVar1, m.xVar2, m.xVar3, m.xVar4, m.xVar5
STORE 0 TO m.xMillion, m.xThousand, m.xRest, m.xCent
*
m.xNegative  = IIF(m.ConvNumber < 0, .T., .F.)
m.ConvNumber = ABS(m.ConvNumber)
IF m.ConvNumber = 0
  RETURN "ZERO"
ENDIF
IF m.ConvNumber > 999999.99
  m.xVar1     = ALLTRIM(STR(m.ConvNumber, 12, 2))
  m.xMillion  = VAL(LEFT(m.xVar1, LEN(m.xVar1) - 9))
  m.ConvNumber= VAL(RIGHT(m.xVar1, 9))
ENDIF
IF m.ConvNumber > 999.99
  m.xVar1     = ALLTRIM(STR(m.ConvNumber, 12, 2))
  m.xThousand = VAL(LEFT(m.xVar1, LEN(m.xVar1) - 6))
  m.ConvNumber= VAL(RIGHT(m.xVar1, 6))
ENDIF
m.xVar1  = ALLTRIM(STR(m.ConvNumber, 12, 2))
m.xRest  = VAL(LEFT(m.xVar1, LEN(m.xVar1) - 3))
m.xCent  = VAL(RIGHT(m.xVar1, 2))
*
m.xVar5  = ""    && Return Variable !
IF m.xMillion > 0
  m.xVar1  = ALLTRIM(STR(m.xMillion))
  m.xVar2  = LEFT(m.xVar1, 1)
  m.xVar3  = IIF(LEN(m.xVar1) > 1, SUBSTR(m.xVar1, 2, 1), "")
  m.xVar4  = IIF(LEN(m.xVar1) > 2, SUBSTR(m.xVar1, 3, 1), "")
  m.xVar5  = m.xVar5 + " " + ThrNumInWrd(m.xVar2, m.xVar3, m.xVar4) + " MILLION"
ENDIF
IF m.xThousand > 0
  m.xVar1  = ALLTRIM(STR(m.xThousand))
  m.xVar2  = LEFT(m.xVar1, 1)
  m.xVar3  = IIF(LEN(m.xVar1) > 1, SUBSTR(m.xVar1, 2, 1), "")
  m.xVar4  = IIF(LEN(m.xVar1) > 2, SUBSTR(m.xVar1, 3, 1), "")
  m.xVar5  = m.xVar5 + " " + ThrNumInWrd(m.xVar2, m.xVar3, m.xVar4) + " THOUSAND"
ENDIF
IF m.xRest > 0
  m.xVar1  = ALLTRIM(STR(m.xRest))
  m.xVar2  = LEFT(m.xVar1, 1)
  m.xVar3  = IIF(LEN(m.xVar1) > 1, SUBSTR(m.xVar1, 2, 1), "")
  m.xVar4  = IIF(LEN(m.xVar1) > 2, SUBSTR(m.xVar1, 3, 1), "")
  m.xVar5  = m.xVar5 + " " + ThrNumInWrd(m.xVar2, m.xVar3, m.xVar4)
ENDIF
IF m.xCent > 0
  m.xVar1  = ALLTRIM(STR(m.xCent))
  m.xVar2  = LEFT(m.xVar1, 1)
  m.xVar3  = IIF(LEN(m.xVar1) > 1, SUBSTR(m.xVar1, 2, 1), "")
  m.xVar4  = IIF(LEN(m.xVar1) > 2, SUBSTR(m.xVar1, 3, 1), "")
  m.xVar5  = m.xVar5 + " AND " + m.TxtForCent + " " + ThrNumInWrd(m.xVar2, m.xVar3, m.xVar4)
ENDIF
m.xVar5  = IIF(m.xNegative, "(MINUS) ", "") + m.xVar5 + " ONLY"
RETURN m.xVar5

* EoF()


* Function to Return the Value of upto Three Numbers in Word !
FUNCTION ThrNumInWrd
PARAMETER m.tnNumbOne, m.tnNumbTwo, m.tnNumbThree
PRIVATE m.yVar1, m.yVar2, m.yVar3, m.yVar4, m.yVar5, m.yVar6, m.yVar7
m.tnNumbOne   = IIF(EMPTY(m.tnNumbOne), "", m.tnNumbOne)
m.tnNumbTwo   = IIF(EMPTY(m.tnNumbTwo), "", m.tnNumbTwo)
m.tnNumbThree = IIF(EMPTY(m.tnNumbThree), "", m.tnNumbThree)
m.yVar1  = IIF(m.tnNumbOne = "1", "One", IIF(m.tnNumbOne = "2", ;
  "Two", IIF(m.tnNumbOne = "3", "Three", IIF(m.tnNumbOne = "4", ;
  "Four", IIF(m.tnNumbOne = "5", "Five", IIF(m.tnNumbOne = "6", ;
  "Six", IIF(m.tnNumbOne = "7", "Seven", IIF(m.tnNumbOne = "8", ;
  "Eight", IIF(m.tnNumbOne = "9", "Nine", "")))))))))
m.yVar2  = IIF(m.tnNumbTwo = "1", "One", IIF(m.tnNumbTwo = "2", ;
  "Two", IIF(m.tnNumbTwo = "3", "Three", IIF(m.tnNumbTwo = "4", ;
  "Four", IIF(m.tnNumbTwo = "5", "Five", IIF(m.tnNumbTwo = "6", ;
  "Six", IIF(m.tnNumbTwo = "7", "Seven", IIF(m.tnNumbTwo = "8", ;
  "Eight", IIF(m.tnNumbTwo = "9", "Nine", "")))))))))
m.yVar3  = IIF(m.tnNumbThree = "1", "One", IIF(m.tnNumbThree = "2", ;
  "Two", IIF(m.tnNumbThree = "3", "Three", IIF(m.tnNumbThree = "4", ;
  "Four", IIF(m.tnNumbThree = "5", "Five", IIF(m.tnNumbThree = "6", ;
  "Six", IIF(m.tnNumbThree = "7", "Seven", IIF(m.tnNumbThree = "8", ;
  "Eight", IIF(m.tnNumbThree = "9", "Nine", "")))))))))
m.yVar7  = ""    && Return Variable !
DO CASE
  CASE (.NOT. EMPTY(m.tnNumbTwo)) .AND. (.NOT. EMPTY(m.tnNumbThree))
    m.yVar7  = m.yVar1 + " Hundred"
    IF m.tnNumbTwo = "1"
      m.yVar5  = IIF(m.tnNumbThree = "0", "Ten", IIF(m.tnNumbThree = "1", ;
       "Eleven", IIF(m.tnNumbThree = "2", "Twelve", IIF(m.tnNumbThree = "3", ;
       "Thirteen", IIF(m.tnNumbThree = "4", "Fourteen", IIF(m.tnNumbThree = "5", ;
       "Fifteen", IIF(m.tnNumbThree = "6", "Sixteen", IIF(m.tnNumbThree = "7", ;
       "Seventeen", IIF(m.tnNumbThree = "8", "Eighteen", "Nineteen")))))))))
      m.yVar7  = m.yVar7 + " " + m.yVar5
    ELSE
      IF m.tnNumbTwo = "0"
        m.yVar7  = m.yVar7 + " " + m.yVar3
      ELSE
        m.yVar5  = IIF(m.tnNumbTwo = "2", "Twenty", IIF(m.tnNumbTwo = "3", ;
          "Thirty", IIF(m.tnNumbTwo = "4", "Forty", IIF(m.tnNumbTwo = "5", ;
          "Fifty", IIF(m.tnNumbTwo = "6", "Sixty", IIF(m.tnNumbTwo = "7", ;
          "Seventy", IIF(m.tnNumbTwo = "8", "Eighty", "Ninety")))))))
        m.yVar7  = m.yVar7 + " " + m.yVar5 + " " + m.yVar3
      ENDIF
    ENDIF
    *
  CASE (.NOT. EMPTY(m.tnNumbTwo)) .AND. EMPTY(m.tnNumbThree)
    IF m.tnNumbOne = "1"
      m.yVar5  = IIF(m.tnNumbTwo = "0", "Ten", IIF(m.tnNumbTwo = "1", ;
       "Eleven", IIF(m.tnNumbTwo = "2", "Twelve", IIF(m.tnNumbTwo = "3", ;
       "Thirteen", IIF(m.tnNumbTwo = "4", "Fourteen", IIF(m.tnNumbTwo = "5", ;
       "Fifteen", IIF(m.tnNumbTwo = "6", "Sixteen", IIF(m.tnNumbTwo = "7", ;
       "Seventeen", IIF(m.tnNumbTwo = "8", "Eighteen", "Nineteen")))))))))
      m.yVar7  = m.yVar7 + " " + m.yVar5
    ELSE
      m.yVar5  = IIF(m.tnNumbOne = "2", "Twenty", IIF(m.tnNumbOne = "3", ;
        "Thirty", IIF(m.tnNumbOne = "4", "Forty", IIF(m.tnNumbOne = "5", ;
        "Fifty", IIF(m.tnNumbOne = "6", "Sixty", IIF(m.tnNumbOne = "7", ;
        "Seventy", IIF(m.tnNumbOne = "8", "Eighty", "Ninety")))))))
      m.yVar7  = m.yVar7 + " " + m.yVar5 + " " + m.yVar2
    ENDIF
    *
  CASE EMPTY(m.tnNumbTwo) .AND. EMPTY(m.tnNumbThree)
    m.yVar7  = m.yVar1
ENDCASE
RETURN ALLTRIM(m.yVar7)
* EoF()
******************

&& at present this function is not required and not been used 15/Nov/2014 Ramesh
FUNCTION FunWevlastdt
PARAMETERS m.order_type, m.zscode, m.sdate_, m.wevday

Select casize
set order to szcode
go top
Locate for alltrim(szcode)=alltrim(m.szcode)

*Combo8 is ordertype

If alltrim(m.Order_type)=alltrim(casize.ordtype1)
	Do Case
		Case m.Qlty=Qlty1a .or. m.Qlty=Qlty1b .or. m.Qlty=Qlty1c .or. m.Qlty=Qlty1d .or. m.Qlty=Qlty1e
			m.wevday=casize.wevday1
		Case m.Qlty=Qlty2a .or. m.Qlty=Qlty2b .or. m.Qlty=Qlty2c .or. m.Qlty=Qlty2d .or. m.Qlty=Qlty2e
			m.wevday=casize.wevday2
	Endcase
Endif

If alltrim(m.Order_type)=alltrim(casize.ordtype2)
	Do Case
		Case m.Qlty=Qlty3a .or. m.Qlty=Qlty3b .or. m.Qlty=Qlty3c .or. m.Qlty=Qlty3d .or. m.Qlty=Qlty3e
			m.wevday=casize.wevday3
		Case m.Qlty=Qlty4a .or. m.Qlty=Qlty4b .or. m.Qlty=Qlty4c .or. m.Qlty=Qlty4d .or. m.Qlty=Qlty4e
			m.wevday=casize.wevday4
	Endcase
Endif

If alltrim(m.Order_type)=alltrim(casize.ordtype3)
	Do Case
		Case m.Qlty=Qlty5a .or. m.Qlty=Qlty5b .or. m.Qlty=Qlty5c .or. m.Qlty=Qlty5d .or. m.Qlty=Qlty5e
			m.wevday=casize.wevday5
		Case m.Qlty=Qlty6a .or. m.Qlty=Qlty6b .or. m.Qlty=Qlty6c .or. m.Qlty=Qlty6d .or. m.Qlty=Qlty6e
			m.wevday=casize.wevday6
	Endcase
Endif

If !empty(m.SDate_) .and. !empty(m.wevday)
	m.Wev_last_dt=m.SDate_+m.wevday
	Return m.Wev_last_dt
Else	
	Messagebox("Either Start Date is Empty OR Define this Quality,Weaving Days in [Size Desc, Setup] to get Weave Date",16)
ENDIF
RETURN
*eof()


*Function to Encode Entered Password and Match entered Password by Encoding
FUNCTION PwCoding
PARAMETER m.WordToChng, m.EncOrDec
PRIVATE m.tVar1, m.tVar2, m.tVar3, m.tVar4, m.tVar5
m.tVar1  = ALLTRIM(m.WordToChng)
m.tVar2  = ""
FOR m.tVar3 = 1 TO LEN(m.tVar1) STEP 1
  m.tVar4  = ASC(SUBSTR(m.tVar1, m.tVar3, 1))
  m.tVar4  = IIF(m.EncOrDec = "E", m.tVar4 + LEN(m.tVar1), m.tVar4 - LEN(m.tVar1))
  m.tVar2  = m.tVar2 + CHR(m.tVar4)
ENDFOR
RETURN LEFT(m.tVar2 + SPACE(LEN(m.WordToChng)), LEN(m.WordToChng))
*eof()