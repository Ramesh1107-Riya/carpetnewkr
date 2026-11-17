*=====================================================================
* close_all.prg   -   close Carpetnew software on every terminal (T0 ... T4)
*
*   DO close_all          window: minutes + message, [Close all] [Open again] [Cancel]
*   DO close_all WITH "CLOSE", 1, "message"     no window (for scripts)
*   DO close_all WITH "OPEN"                    no window: let people log in again
*
* [Close all] writes CLOSEALL.FLG into the program folder.  Every running copy of
* carpet.app shows "Carpetnew software closing in 1 minute - save your work" and
* quits when the time is up (closewatch.prg).  While the file is there nobody can
* log in, so the tables can be used exclusively (reindex, structure changes, ...).
* [Open again] deletes the file: people can log in again, and a countdown that is
* still running is cancelled on every terminal.
*
* Run it from the program (menu), from the VFP command window of any terminal
* (DO \\<main computer>\<share>\close_all), or from a shortcut to VFP6.EXE with
* this program as its parameter.  The terminal that sends it closes too, when it
* runs carpet.app.
*=====================================================================
LPARAMETERS tcWhat, tnMin, tcMsg
LOCAL lcFile, loF, lcOldDir, lcHere, luRet
* run from another folder (DO \\T0\carpetnew\close_all): work in this program's
* folder, so the signal goes next to CARPET.DBC and closewatch.prg is found
lcOldDir = SYS(5) + SYS(2003)
lcHere = JUSTPATH(SYS(16))
IF !FILE("carpet.dbc") .AND. !EMPTY(lcHere) .AND. FILE(ADDBS(lcHere) + "carpet.dbc")
	SET DEFAULT TO (lcHere)
ENDIF
lcFile = closewatch("FILE")
DO CASE
CASE TYPE("tcWhat") = "C" .AND. UPPER(ALLTRIM(tcWhat)) == "CLOSE"
	luRet = CaSend(lcFile, IIF(TYPE("tnMin") = "N", tnMin, 1), IIF(TYPE("tcMsg") = "C", tcMsg, ""))
CASE TYPE("tcWhat") = "C" .AND. UPPER(ALLTRIM(tcWhat)) == "OPEN"
	luRet = CaOpen(lcFile)
OTHERWISE
	luRet = .T.
	loF = CREATEOBJECT("frmCloseAll", lcFile)
	IF TYPE("loF") = "O" .AND. !ISNULL(loF)
		loF.Show(1)
	ENDIF
ENDCASE
SET DEFAULT TO (lcOldDir)
RETURN luRet

* write the signal: id / minutes / sent by / message
FUNCTION CaSend
LPARAMETERS tcFile, tnMin, tcMsg
LOCAL lcId, lcBy, lcTxt
lcId = DTOS(DATE()) + STRTRAN(TIME(), ":", "") + SYS(2015)
lcBy = ALLTRIM(SYS(0)) + IIF(TYPE("pname") = "C" .AND. !EMPTY(pname), " (" + ALLTRIM(pname) + ")", "") + ;
	"  at " + TIME()
lcTxt = lcId + CHR(13) + CHR(10) + ;
	ALLTRIM(STR(MAX(tnMin, 0.25), 6, 2)) + CHR(13) + CHR(10) + ;
	lcBy + CHR(13) + CHR(10) + ;
	ALLTRIM(CHRTRAN(tcMsg, CHR(13) + CHR(10), "  ")) + CHR(13) + CHR(10)
RETURN (STRTOFILE(lcTxt, tcFile) > 0)
ENDFUNC

FUNCTION CaOpen
LPARAMETERS tcFile
IF FILE(tcFile)
	ERASE (tcFile)
ENDIF
RETURN !FILE(tcFile)
ENDFUNC


*---------------------------------------------------------------------
DEFINE CLASS frmCloseAll AS Form
	Caption = "Close Carpetnew software on all terminals"
	Width = 520
	Height = 304
	AutoCenter = .T.
	BorderStyle = 2
	MaxButton = .F.
	MinButton = .F.
	WindowType = 1
	ShowTips = .T.
	BackColor = RGB(0, 153, 255)
	cFile = ""

	* status panel: a light box with the state, a hint and who sent the signal
	ADD OBJECT shpState AS Shape WITH ;
		Left = 12, Top = 12, Width = 496, Height = 94, BackStyle = 1, ;
		BackColor = RGB(255, 255, 255), BorderColor = RGB(0, 70, 140)
	ADD OBJECT lblState AS Label WITH ;
		Caption = "", FontName = "Arial", FontSize = 11, FontBold = .T., ;
		BackStyle = 0, Left = 24, Top = 20, Width = 472, Height = 20
	ADD OBJECT lblHint AS Label WITH ;
		Caption = "", FontName = "Arial", FontSize = 9, ;
		ForeColor = RGB(40, 40, 40), BackStyle = 0, Left = 24, Top = 43, Width = 472, Height = 16
	ADD OBJECT lblInfo1 AS Label WITH ;
		Caption = "", FontName = "Arial", FontSize = 9, ;
		ForeColor = RGB(40, 40, 40), BackStyle = 0, Left = 24, Top = 62, Width = 472, Height = 16
	ADD OBJECT lblInfo2 AS Label WITH ;
		Caption = "", FontName = "Arial", FontSize = 9, ;
		ForeColor = RGB(40, 40, 40), BackStyle = 0, Left = 24, Top = 81, Width = 472, Height = 16

	ADD OBJECT lblMin AS Label WITH ;
		Caption = "Close after (minutes):", FontName = "Arial", FontSize = 10, FontBold = .T., ;
		ForeColor = RGB(255, 255, 255), BackStyle = 0, Left = 12, Top = 124, Width = 160, Height = 18
	ADD OBJECT spnMin AS Spinner WITH ;
		Left = 176, Top = 120, Width = 64, Height = 24, FontName = "Arial", FontSize = 10, ;
		KeyboardLowValue = 1, KeyboardHighValue = 60, SpinnerLowValue = 1, SpinnerHighValue = 60, Value = 1
	ADD OBJECT lblMsg AS Label WITH ;
		Caption = "Message to show on every terminal:", FontName = "Arial", FontSize = 10, FontBold = .T., ;
		ForeColor = RGB(255, 255, 255), BackStyle = 0, Left = 12, Top = 156, Width = 300, Height = 18
	ADD OBJECT edtMsg AS EditBox WITH ;
		Left = 12, Top = 177, Width = 496, Height = 54, FontName = "Arial", FontSize = 10, ;
		ScrollBars = 0, Value = "Carpetnew software is closing. Save your work."
	ADD OBJECT cmdClose AS CommandButton WITH ;
		Caption = "Close all", Left = 12, Top = 251, Width = 150, Height = 34, FontName = "Arial", FontSize = 10, FontBold = .T.
	ADD OBJECT cmdOpen AS CommandButton WITH ;
		Caption = "Open again", Left = 185, Top = 251, Width = 150, Height = 34, FontName = "Arial", FontSize = 10, FontBold = .T.
	ADD OBJECT cmdCancel AS CommandButton WITH ;
		Caption = "Cancel", Left = 358, Top = 251, Width = 150, Height = 34, FontName = "Arial", FontSize = 10, FontBold = .T., Cancel = .T.

	PROCEDURE Init
	LPARAMETERS tcFile
	THIS.cFile = tcFile
	THIS.ShowState()
	ENDPROC

	PROCEDURE ShowState
	LOCAL laL[1], lnN
	IF FILE(THIS.cFile)
		* closewatch("INFO") = [message + CR] + "Sent by: ..."
		lnN = ALINES(laL, closewatch("INFO"))
		THIS.shpState.BackColor = RGB(255, 236, 236)
		THIS.shpState.BorderColor = RGB(190, 0, 0)
		THIS.lblState.ForeColor = RGB(190, 0, 0)
		THIS.lblState.Caption = "CLOSED NOW - nobody can log in."
		THIS.lblHint.Caption = "Press [Open again] when the work is done."
		THIS.lblInfo1.Caption = IIF(lnN >= 2, "Message: " + ALLTRIM(laL[1]), "")
		THIS.lblInfo2.Caption = IIF(lnN >= 1, ALLTRIM(laL[lnN]), "")
		THIS.cmdOpen.Enabled = .T.
	ELSE
		THIS.shpState.BackColor = RGB(232, 248, 232)
		THIS.shpState.BorderColor = RGB(0, 120, 0)
		THIS.lblState.ForeColor = RGB(0, 120, 0)
		THIS.lblState.Caption = "OPEN - people can work."
		THIS.lblHint.Caption = "Press [Close all] to close the software on every terminal."
		THIS.lblInfo1.Caption = "Signal file:"
		THIS.lblInfo2.Caption = THIS.cFile
		THIS.cmdOpen.Enabled = .F.
	ENDIF
	THIS.lblInfo1.ToolTipText = THIS.lblInfo1.Caption
	THIS.lblInfo2.ToolTipText = THIS.lblInfo2.Caption
	ENDPROC

	PROCEDURE cmdClose.Click
	LOCAL lnMin
	lnMin = THISFORM.spnMin.Value
	IF MESSAGEBOX("Close Carpetnew software on ALL terminals in " + ALLTRIM(STR(lnMin)) + " minute(s)?" + CHR(13) + ;
			"Nobody can log in until you press [Open again].", 36 + 256, THISFORM.Caption) # 6
		RETURN
	ENDIF
	IF CaSend(THISFORM.cFile, lnMin, ALLTRIM(THISFORM.edtMsg.Value))
		=MESSAGEBOX("Sent.  Every terminal closes in " + ALLTRIM(STR(lnMin)) + " minute(s)." + CHR(13) + ;
			"When your work is done, run  DO close_all  again and press [Open again].", 64, THISFORM.Caption)
		THISFORM.Release()
	ELSE
		=MESSAGEBOX("Could not write " + THISFORM.cFile + ".", 16, THISFORM.Caption)
	ENDIF
	ENDPROC

	PROCEDURE cmdOpen.Click
	IF CaOpen(THISFORM.cFile)
		=MESSAGEBOX("Carpetnew software is open again: people can log in.", 64, THISFORM.Caption)
		THISFORM.Release()
	ELSE
		=MESSAGEBOX("Could not delete " + THISFORM.cFile + "." + CHR(13) + "Is it read-only or open?", 16, THISFORM.Caption)
	ENDIF
	ENDPROC

	PROCEDURE cmdCancel.Click
	THISFORM.Release()
	ENDPROC
ENDDEFINE
