*=====================================================================
* closewatch.prg   -   "close all" signal for every terminal running carpet.app
*
* close_all.prg writes the signal file CLOSEALL.FLG into the program folder (the
* folder of CARPET.DBC, shared on the LAN).  Every running copy of the program
* checks for it every few seconds; when it appears a notice counts down
* ("Carpetnew software closing in 1 minute - save your work") and at zero the
* program closes its forms and tables and quits.  While the file is there only
* the supervisor (LEVEL5) can log in (main.prg).  close_all [Open again] deletes
* it: a countdown that is still running is then cancelled on every terminal.
*
* Used from main.prg:
*     closewatch("ISON")    -> .T. while the signal is on
*     closewatch("INFO")    -> message + who sent it, for a message box
*     =closewatch("START")  -> starts the watcher (PUBLIC goCloseWatch).  A signal
*                              that is already on at start is not counted down:
*                              the supervisor who logs in while closed keeps working.
* close_all.prg uses closewatch("FILE") / closewatch("INFO").
*=====================================================================
LPARAMETERS tcWhat
LOCAL lcWhat, lcFile
lcWhat = UPPER(ALLTRIM(IIF(TYPE("tcWhat") = "C", tcWhat, "START")))
lcFile = CwFlagFile()
DO CASE
CASE lcWhat == "FILE"
	RETURN lcFile
CASE lcWhat == "READ"
	RETURN CwRead(lcFile)
CASE lcWhat == "INFO"
	RETURN CwRead(lcFile, "INFO")
CASE lcWhat == "ISON"
	RETURN FILE(lcFile)
CASE lcWhat == "START"
	IF TYPE("goCloseWatch") = "O" .AND. !ISNULL(goCloseWatch)
		RETURN .T.
	ENDIF
	PUBLIC goCloseWatch
	goCloseWatch = CREATEOBJECT("cwTimer", lcFile)
	RETURN .T.
CASE lcWhat == "STOP"
	IF TYPE("goCloseWatch") = "O" .AND. !ISNULL(goCloseWatch)
		goCloseWatch.Enabled = .F.
		goCloseWatch.HideNotice()
	ENDIF
	goCloseWatch = .NULL.
	RETURN .T.
ENDCASE
RETURN .F.

* the signal file: in the folder of CARPET.DBC (the shared program folder)
FUNCTION CwFlagFile
LOCAL lcDir
lcDir = ""
IF FILE("carpet.dbc")
	lcDir = JUSTPATH(FULLPATH("carpet.dbc"))
ENDIF
IF EMPTY(lcDir) .AND. !EMPTY(DBC())
	lcDir = JUSTPATH(DBC())
ENDIF
IF EMPTY(lcDir)
	lcDir = SYS(5) + SYS(2003)
ENDIF
RETURN ADDBS(lcDir) + "closeall.flg"
ENDFUNC

* the signal file has 4 lines: id / minutes / sent by / message
* tcPart: "ID", "MIN", "BY", "MSG", "INFO" (by + message for a message box); "" = ID
FUNCTION CwRead
LPARAMETERS tcFile, tcPart
LOCAL lcTxt, laL[1], lnN, lcPart, lnI
lcPart = UPPER(IIF(TYPE("tcPart") = "C", tcPart, "ID"))
lcTxt = ""
IF FILE(tcFile)
	lcTxt = FILETOSTR(tcFile)
ENDIF
lnN = ALINES(laL, lcTxt)
DIMENSION laL[MAX(lnN, 4)]
FOR lnI = lnN + 1 TO 4
	laL[lnI] = ""
ENDFOR
DO CASE
CASE lcPart == "MIN"
	RETURN MAX(VAL(laL[2]), 0)
CASE lcPart == "BY"
	RETURN ALLTRIM(laL[3])
CASE lcPart == "MSG"
	RETURN ALLTRIM(laL[4])
CASE lcPart == "INFO"
	RETURN IIF(EMPTY(laL[4]), "", ALLTRIM(laL[4]) + CHR(13)) + "Sent by: " + ALLTRIM(laL[3])
ENDCASE
RETURN ALLTRIM(laL[1])
ENDFUNC


*---------------------------------------------------------------------
* the watcher: ticks every second, looks at the signal file every 5 seconds
DEFINE CLASS cwTimer AS Timer
	Interval = 1000
	Enabled = .T.
	cFile = ""
	cId = ""
	cIgnore = ""
	tDeadline = {}
	nTick = 4
	oNotice = .NULL.

	PROCEDURE Init
	LPARAMETERS tcFile
	THIS.cFile = tcFile
	* already on when this copy started (the supervisor logged in while closed)
	IF FILE(tcFile)
		THIS.cIgnore = THIS.Part("ID")
	ENDIF
	ENDPROC

	* same as CwRead(), as a method: when the timer fires, closewatch.prg is not
	* running any more and its functions may not be found
	FUNCTION Part
	LPARAMETERS tcPart
	LOCAL lcTxt, laL[1], lnN, lnI
	lcTxt = ""
	IF FILE(THIS.cFile)
		lcTxt = FILETOSTR(THIS.cFile)
	ENDIF
	lnN = ALINES(laL, lcTxt)
	DIMENSION laL[MAX(lnN, 4)]
	FOR lnI = lnN + 1 TO 4
		laL[lnI] = ""
	ENDFOR
	DO CASE
	CASE tcPart == "MIN"
		RETURN MAX(VAL(laL[2]), 0)
	CASE tcPart == "BY"
		RETURN ALLTRIM(laL[3])
	CASE tcPart == "MSG"
		RETURN ALLTRIM(laL[4])
	ENDCASE
	RETURN ALLTRIM(laL[1])
	ENDFUNC

	PROCEDURE Timer
	LOCAL lcOldErr, llOn, lcId, lnLeft
	lcOldErr = ON("ERROR")
	ON ERROR *
	THIS.nTick = THIS.nTick + 1
	* the LAN file only every 5 seconds
	IF THIS.nTick >= 5
		THIS.nTick = 0
		llOn = FILE(THIS.cFile)
		lcId = IIF(llOn, THIS.Part("ID"), "")
		IF !llOn
			THIS.cIgnore = ""
		ENDIF
		DO CASE
		CASE !llOn .AND. !EMPTY(THIS.cId)
			* signal taken back: cancel the countdown
			THIS.cId = ""
			THIS.HideNotice()
			WAIT WINDOW "Closing of Carpetnew software was cancelled." NOWAIT
		CASE llOn .AND. !EMPTY(lcId) .AND. !(lcId == THIS.cId) .AND. !(lcId == THIS.cIgnore)
			* a new signal: count down from now (each terminal by its own clock)
			THIS.cId = lcId
			THIS.tDeadline = DATETIME() + MAX(THIS.Part("MIN"), 0.25) * 60
			THIS.ShowNotice(THIS.Part("MSG"), THIS.Part("BY"))
		ENDCASE
	ENDIF
	IF !EMPTY(THIS.cId)
		lnLeft = MAX(INT(THIS.tDeadline - DATETIME()), 0)
		IF TYPE("THIS.oNotice") = "O" .AND. !ISNULL(THIS.oNotice)
			THIS.oNotice.SetLeft(lnLeft)
		ENDIF
		IF lnLeft <= 0
			ON ERROR &lcOldErr
			THIS.CloseAll()
			RETURN
		ENDIF
	ENDIF
	ON ERROR &lcOldErr
	ENDPROC

	PROCEDURE ShowNotice
	LPARAMETERS tcMsg, tcBy
	IF TYPE("THIS.oNotice") # "O" .OR. ISNULL(THIS.oNotice)
		THIS.oNotice = CREATEOBJECT("cwNotice")
	ENDIF
	THIS.oNotice.SetText(tcMsg, tcBy)
	THIS.oNotice.SetLeft(MAX(INT(THIS.tDeadline - DATETIME()), 0))
	THIS.oNotice.Show()
	ENDPROC

	PROCEDURE HideNotice
	IF TYPE("THIS.oNotice") = "O" .AND. !ISNULL(THIS.oNotice)
		THIS.oNotice.Release()
	ENDIF
	THIS.oNotice = .NULL.
	ENDPROC

	* time is up: close every form and table and quit this copy of the program.
	* VFP ignores QUIT while a modal form is open, so the forms are released first;
	* the timer stays on, so if something still holds the program (a message box
	* waiting for OK) this runs again on the next tick.
	PROCEDURE CloseAll
	LOCAL lnI
	ON ERROR *
	THIS.HideNotice()
	FOR lnI = _SCREEN.FormCount TO 1 STEP -1
		_SCREEN.Forms(lnI).Release()
	ENDFOR
	CLEAR EVENTS
	ROLLBACK
	CLOSE DATABASES ALL
	CLOSE ALL
	QUIT
	ENDPROC
ENDDEFINE


*---------------------------------------------------------------------
* the notice on every terminal
DEFINE CLASS cwNotice AS Form
	Caption = "Carpetnew"
	Width = 460
	Height = 190
	AutoCenter = .T.
	AlwaysOnTop = .T.
	BorderStyle = 2
	Closable = .F.
	MaxButton = .F.
	MinButton = .F.
	BackColor = RGB(255, 236, 160)
	WindowType = 0

	ADD OBJECT lblHead AS Label WITH ;
		Caption = "Carpetnew software closing", FontName = "Arial", FontSize = 16, FontBold = .T., ;
		ForeColor = RGB(160, 0, 0), BackStyle = 0, Alignment = 2, Left = 10, Top = 14, Width = 440, Height = 28
	ADD OBJECT lblLeft AS Label WITH ;
		Caption = "", FontName = "Arial", FontSize = 14, FontBold = .T., ;
		BackStyle = 0, Alignment = 2, Left = 10, Top = 50, Width = 440, Height = 26
	ADD OBJECT lblSave AS Label WITH ;
		Caption = "Save your work now.", FontName = "Arial", FontSize = 12, FontBold = .T., ;
		BackStyle = 0, Alignment = 2, Left = 10, Top = 84, Width = 440, Height = 22
	ADD OBJECT lblMsg AS Label WITH ;
		Caption = "", FontName = "Arial", FontSize = 9, WordWrap = .T., ;
		BackStyle = 0, Alignment = 2, Left = 10, Top = 116, Width = 440, Height = 64

	PROCEDURE SetText
	LPARAMETERS tcMsg, tcBy
	THIS.lblMsg.Caption = IIF(EMPTY(tcMsg), "", tcMsg + CHR(13)) + IIF(EMPTY(tcBy), "", "Sent by: " + tcBy)
	ENDPROC

	PROCEDURE SetLeft
	LPARAMETERS tnSec
	THIS.lblLeft.Caption = "in " + IIF(tnSec >= 60, ALLTRIM(STR(INT(tnSec / 60))) + " min ", "") + ;
		PADL(ALLTRIM(STR(MOD(tnSec, 60))), 2, "0") + " sec"
	ENDPROC
ENDDEFINE
