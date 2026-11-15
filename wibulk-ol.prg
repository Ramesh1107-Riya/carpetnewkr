*=====================================================================
* wibulk.prg   -   BULK ISSUE of yarn to SUPPLIER, divided by SqMt        (DO wibulk)
*
* Data entry for WIISSUE_BULK: one line per bulk issue (total kg, one OL No of the
* Order Form, bill, date, quality, colour ...).  Total SqMt and number of OLs are read
* from Casupord / Cabuyord.
*
*   Save    keeps the bulk line in WIISSUE_BULK (nothing goes to Wiissue yet)
*   Edit    change the bulk line shown, then Save
*   Search  find a bulk line by OL No (any OL of the issue) or Bill No
*   Commit  divides the line over the OLs of its Order Form by SqMt and writes the
*           divided rows into WIISSUE (same GRPID).  Commit again after an Edit to
*           bring Wiissue up to date.
*   New     blank entry
*
* Order Form group = same Casupord.Issdt and Supplier, same Cabuyord Design, Colour and
* Quality, Cstatus On-Loom / Distri (the rule of rordformyarn.prg).  An OL that is not
* On-Loom / Distri is issued on its own (one row).
*
* Needs (once):  DO wiissue_addgrp   and   DO wiissue_bulk_create
*=====================================================================
IF TYPE("goWiBulk") = "O" .AND. !ISNULL(goWiBulk)
	goWiBulk.Show()
	RETURN
ENDIF
PUBLIC goWiBulk
goWiBulk = CREATEOBJECT("frmWiBulk")
IF TYPE("goWiBulk") = "O" .AND. !ISNULL(goWiBulk)
	goWiBulk.Show()
ELSE
	goWiBulk = .NULL.
ENDIF
RETURN


*---------------------------------------------------------------------
DEFINE CLASS wbText AS TextBox
	FontName = "Arial"
	FontSize = 10
	Height = 24
	PROCEDURE LostFocus
		THISFORM.CtlLost(THIS.Name)
	ENDPROC
ENDDEFINE

DEFINE CLASS wbBtn AS CommandButton
	FontName = "Arial"
	FontSize = 10
	FontBold = .T.
	Height = 32
	Width = 105
	PROCEDURE Click
		THISFORM.BtnClick(THIS.Name)
	ENDPROC
ENDDEFINE


*---------------------------------------------------------------------
DEFINE CLASS frmWiBulk AS Form
	Caption = "Bulk Issue of Yarn to SUPPLIER - divided by SqMt"
	Height = 520
	Width = 790
	AutoCenter = .T.
	DataSession = 2
	BorderStyle = 2
	MaxButton = .F.
	BackColor = RGB(0, 153, 255)
	cMode = "V"
	cGrp = ""
	cOldOl = ""
	cSupplier = ""
	cDesign = ""
	nTotSq = 0
	nNol = 0
	nOldQty = 0
	cOldQlty = ""
	cOldColour = ""
	cDyewht = "D"
	cComment = "Dyed Yarn Issue"
	lSilent = .F.
	lCheckStock = .T.
	cMsg = ""

	*-----------------------------------------------------------------
	PROCEDURE Init
	SET TALK OFF
	SET DATE TO BRITISH
	SET CENTURY ON
	SET DELETED ON
	SET MULTILOCKS ON
	IF !DBUSED("carpet")
		OPEN DATABASE carpet SHARED
	ENDIF
	SET DATABASE TO carpet
	IF !THIS.OpenTables()
		RETURN .F.
	ENDIF
	THIS.BuildScreen()
	SELECT wbk
	THIS.AddEntry()
	ENDPROC

	PROCEDURE Destroy
	IF TYPE("goWiBulk") = "O"
		goWiBulk = .NULL.
	ENDIF
	ENDPROC

	*-----------------------------------------------------------------
	FUNCTION OpenTables
	IF !INDBC("wiissue_bulk", "TABLE")
		THIS.Msg("Table WIISSUE_BULK does not exist." + CHR(13) + "Run  DO wiissue_bulk_create  once (all users out of the program).", 16)
		RETURN .F.
	ENDIF
	USE wiissue_bulk IN 0 SHARED ALIAS wbk
	USE wiissue AGAIN SHARED IN 0 ALIAS wi_w
	IF TYPE("wi_w.grpid") = "U"
		THIS.Msg("Wiissue has no GRPID column." + CHR(13) + "Run  DO wiissue_addgrp  once (all users out of the program).", 16)
		RETURN .F.
	ENDIF
	RETURN .T.
	ENDFUNC

	* message box that can be switched off (lSilent) for scripts; returns the button
	FUNCTION Msg
	LPARAMETERS tcText, tnType
	THIS.cMsg = tcText
	IF THIS.lSilent
		RETURN 6
	ENDIF
	RETURN MESSAGEBOX(tcText, tnType, THIS.Caption)
	ENDFUNC

	*-----------------------------------------------------------------
	PROCEDURE BuildScreen
	THIS.AddLbl("lblTitle", "Bulk Issue of Yarn to SUPPLIER  (divided by SqMt over the OLs of the Order Form)", 12, 20, 740, 14)
	THIS.AddLbl("l1", "OL No", 52, 20, 100, 10)
	THIS.AddTxt("txtOl", 48, 135, 150, "", .F.)
	THIS.AddLbl("l2", "Supplier", 52, 310, 80, 10)
	THIS.AddTxt("txtParty", 48, 395, 200, "", .T.)
	THIS.AddLbl("l3", "Design", 92, 20, 100, 10)
	THIS.AddTxt("txtDesign", 88, 135, 250, "", .T.)
	THIS.AddLbl("l4", "Total SqMt", 92, 405, 90, 10)
	THIS.AddTxt("txtTotSq", 88, 495, 90, 0, .T.)
	THIS.AddLbl("l5", "No. of OL", 92, 610, 70, 10)
	THIS.AddTxt("txtNol", 88, 685, 50, 0, .T.)
	THIS.AddLbl("l6", "Bill No", 132, 20, 100, 10)
	THIS.AddTxt("txtBill", 128, 135, 100, "", .F.)
	THIS.AddLbl("l7", "Issue Date", 132, 310, 80, 10)
	THIS.AddTxt("txtDate", 128, 395, 100, {}, .F.)
	THIS.AddLbl("l8", "Ball [B] / Lachhi [L]", 132, 520, 140, 10)
	THIS.AddTxt("txtBL", 128, 685, 30, "", .F.)
	THIS.AddLbl("l9", "Yarn Quality", 172, 20, 100, 10)
	THIS.AddTxt("txtQlty", 168, 135, 120, "", .F.)
	THIS.AddLbl("l10", "Yarn Colour", 172, 310, 80, 10)
	THIS.AddTxt("txtColour", 168, 395, 120, "", .F.)
	THIS.AddLbl("l11", "Type", 172, 540, 40, 10)
	THIS.AddTxt("txtYtype", 168, 585, 70, "", .T.)
	THIS.AddLbl("l12", "Net Wt (Kg) TOTAL", 212, 20, 115, 10)
	THIS.AddTxt("txtQty", 208, 135, 100, 0, .F.)
	THIS.AddLbl("l13", "Rate", 212, 310, 80, 10)
	THIS.AddTxt("txtRate", 208, 395, 90, 0, .T.)
	THIS.AddLbl("l14", "Amount", 212, 520, 60, 10)
	THIS.AddTxt("txtAmt", 208, 585, 120, 0, .T.)
	THIS.AddLbl("l15", "Stock balance", 252, 20, 100, 10)
	THIS.AddTxt("txtBal", 248, 135, 100, 0, .T.)
	THIS.AddLbl("l16", "Comment", 252, 310, 80, 10)
	THIS.AddTxt("txtComment", 248, 395, 200, "", .T.)
	THIS.AddTxt("txtStatus", 248, 610, 160, "", .T.)
	THIS.AddLbl("l17", "Division over the OLs   (OL No   /   SqMt   /   Kg)", 292, 20, 500, 10)
	THIS.txtQty.InputMask = "999999.999"
	THIS.txtRate.InputMask = "99999.99"
	THIS.txtAmt.InputMask = "999999999.99"
	THIS.txtTotSq.InputMask = "99999.99"
	THIS.txtBal.InputMask = "999999.999"
	THIS.txtDate.Format = "D"
	THIS.txtBL.MaxLength = 1
	THIS.txtStatus.FontBold = .T.
	THIS.AddObject("lstSh", "ListBox")
	WITH THIS.lstSh
		.Left = 20
		.Top = 312
		.Width = 750
		.Height = 120
		.FontName = "Courier New"
		.FontSize = 10
		.ColumnCount = 3
		.ColumnWidths = "300,200,200"
		.RowSourceType = 6
		.Visible = .T.
	ENDWITH
	THIS.AddBtn("cmdSave", "Save", 20, 450)
	THIS.AddBtn("cmdEdit", "Edit", 135, 450)
	THIS.AddBtn("cmdSearch", "Search", 250, 450)
	THIS.AddBtn("cmdCommit", "Commit", 365, 450)
	THIS.AddBtn("cmdNew", "New", 480, 450)
	THIS.AddBtn("cmdExit", "Exit", 665, 450)
	ENDPROC

	PROCEDURE AddLbl
	LPARAMETERS tcName, tcCap, tnTop, tnLeft, tnWidth, tnSize
	THIS.AddObject(tcName, "Label")
	WITH THIS.&tcName
		.Caption = tcCap
		.Top = tnTop
		.Left = tnLeft
		.Width = tnWidth
		.Height = 20
		.FontName = "Arial"
		.FontSize = tnSize
		.FontBold = .T.
		.BackStyle = 0
		.ForeColor = IIF(tnSize > 10, RGB(0, 0, 128), RGB(255, 255, 255))
		.Visible = .T.
	ENDWITH
	ENDPROC

	PROCEDURE AddTxt
	LPARAMETERS tcName, tnTop, tnLeft, tnWidth, tuInit, tlRo
	THIS.AddObject(tcName, "wbText")
	WITH THIS.&tcName
		.Top = tnTop
		.Left = tnLeft
		.Width = tnWidth
		.Value = tuInit
		.Visible = .T.
	ENDWITH
	IF tlRo
		THIS.&tcName..ReadOnly = .T.
		THIS.&tcName..TabStop = .F.
		THIS.&tcName..BackColor = RGB(220, 220, 220)
	ENDIF
	ENDPROC

	PROCEDURE AddBtn
	LPARAMETERS tcName, tcCap, tnLeft, tnTop
	THIS.AddObject(tcName, "wbBtn")
	WITH THIS.&tcName
		.Caption = tcCap
		.Left = tnLeft
		.Top = tnTop
		.Visible = .T.
	ENDWITH
	ENDPROC

	*-----------------------------------------------------------------
	* V = viewing a saved line, A = new entry, E = editing a saved line
	PROCEDURE SetMode
	LPARAMETERS tcMode
	LOCAL llEntry, llLine
	THIS.cMode = tcMode
	llEntry = (tcMode $ "AE")
	SELECT wbk
	llLine = (!EOF() .AND. RECCOUNT() > 0)
	THIS.txtOl.ReadOnly = !llEntry
	THIS.txtBill.ReadOnly = !llEntry
	THIS.txtDate.ReadOnly = !llEntry
	THIS.txtBL.ReadOnly = !llEntry
	THIS.txtQlty.ReadOnly = !llEntry
	THIS.txtColour.ReadOnly = !llEntry
	THIS.txtQty.ReadOnly = !llEntry
	THIS.cmdSave.Enabled = llEntry
	THIS.cmdEdit.Enabled = (tcMode == "V" .AND. llLine)
	THIS.cmdCommit.Enabled = (llLine .AND. tcMode # "A")
	ENDPROC

	PROCEDURE BtnClick
	LPARAMETERS tcName
	DO CASE
	CASE tcName == "cmdSave"
		THIS.SaveEntry()
	CASE tcName == "cmdEdit"
		THIS.EditEntry()
	CASE tcName == "cmdSearch"
		THIS.FindEntry("")
	CASE tcName == "cmdCommit"
		THIS.CommitEntry()
	CASE tcName == "cmdNew"
		THIS.AddEntry()
	CASE tcName == "cmdExit"
		THIS.Release()
	ENDCASE
	ENDPROC

	* LostFocus of the entry boxes
	PROCEDURE CtlLost
	LPARAMETERS tcName
	IF !(THIS.cMode $ "AE")
		RETURN
	ENDIF
	DO CASE
	CASE tcName == "txtOl"
		THIS.Recalc()
	CASE tcName == "txtQlty" .OR. tcName == "txtBL"
		THIS.QualityInfo()
		THIS.Recalc()
	CASE tcName == "txtQty"
		THIS.Recalc()
	ENDCASE
	ENDPROC

	*-----------------------------------------------------------------
	* ---------- order file (Casupord / Cabuyord) ----------
	* Fills cursor cWbSib (OL, SqMt) with the OLs of the Order Form of tcOl and sets
	* cSupplier, cDesign, nTotSq, nNol.  Returns the number of OLs (0 = OL not found).
	FUNCTION LoadOrder
	LPARAMETERS tcOl
	LOCAL lcAnsi, ldIss, lcSup, lcDes, lcCol, lcQlt
	lcAnsi = SET("ANSI")
	SET ANSI ON
	tcOl = ALLTRIM(tcOl)
	THIS.NewShareCursor()
	THIS.cSupplier = ""
	THIS.cDesign = ""
	SELECT s.issdt, s.supplier, b.design, b.colour, b.quality, b.sqmt ;
		FROM casupord s, cabuyord b ;
		WHERE b.ol_no = s.ol_no AND s.ol_no = tcOl ;
		INTO CURSOR cWbKey
	IF RECCOUNT("cWbKey") > 0
		ldIss = cWbKey.issdt
		lcSup = cWbKey.supplier
		lcDes = cWbKey.design
		lcCol = cWbKey.colour
		lcQlt = cWbKey.quality
		THIS.cSupplier = ALLTRIM(lcSup)
		THIS.cDesign = ALLTRIM(lcDes)
		IF !EMPTY(ldIss) .AND. !EMPTY(lcSup)
			SELECT s.ol_no, b.sqmt ;
				FROM casupord s, cabuyord b ;
				WHERE b.ol_no = s.ol_no AND s.issdt = ldIss AND s.supplier = lcSup ;
				AND b.design = lcDes AND b.colour = lcCol AND b.quality = lcQlt ;
				AND (b.cstatus = "On-Loom" OR b.cstatus = "Distri") ;
				ORDER BY s.ol_no ;
				INTO CURSOR cWbSib0
			SELECT cWbSib0
			SCAN
				INSERT INTO cWbSib (ol_no, sqmt) VALUES (cWbSib0.ol_no, cWbSib0.sqmt)
			ENDSCAN
			USE IN cWbSib0
		ENDIF
		SELECT cWbSib
		LOCATE FOR ALLTRIM(ol_no) == tcOl
		IF !FOUND()
			* the OL itself is not On-Loom / Distri: it is issued on its own
			THIS.NewShareCursor()
			INSERT INTO cWbSib (ol_no, sqmt) VALUES (tcOl, cWbKey.sqmt)
		ENDIF
	ENDIF
	IF USED("cWbKey")
		USE IN cWbKey
	ENDIF
	SET ANSI &lcAnsi
	THIS.TotalsFromCursor()
	RETURN RECCOUNT("cWbSib")
	ENDFUNC

	* An issue that is already committed: the OLs it already has (+ tcOl).  The Order Form
	* status is not looked at again, so an old issue keeps its OLs.
	FUNCTION LoadMembers
	LPARAMETERS tcGrp, tcOl
	LOCAL laS[1]
	tcOl = ALLTRIM(tcOl)
	THIS.NewShareCursor()
	SELECT DISTINCT w.ol_no, b.sqmt ;
		FROM wi_w w LEFT JOIN cabuyord b ON b.ol_no = w.ol_no ;
		WHERE w.grpid = tcGrp ;
		INTO CURSOR cWbM
	SELECT cWbM
	SCAN
		INSERT INTO cWbSib (ol_no, sqmt) VALUES (cWbM.ol_no, IIF(ISNULL(cWbM.sqmt), 0, cWbM.sqmt))
	ENDSCAN
	USE IN cWbM
	SELECT cWbSib
	LOCATE FOR ALLTRIM(ol_no) == tcOl
	IF !FOUND()
		SELECT sqmt FROM cabuyord WHERE ol_no = tcOl INTO ARRAY laS
		INSERT INTO cWbSib (ol_no, sqmt) VALUES (tcOl, IIF(_TALLY > 0, laS[1], 0))
	ENDIF
	THIS.TotalsFromCursor()
	RETURN RECCOUNT("cWbSib")
	ENDFUNC

	PROCEDURE NewShareCursor
	IF USED("cWbSib")
		USE IN cWbSib
	ENDIF
	CREATE CURSOR cWbSib (ol_no C(15), sqmt N(8,2), share N(11,3), taken L)
	ENDPROC

	PROCEDURE TotalsFromCursor
	LOCAL lnS
	SELECT cWbSib
	CALCULATE SUM(sqmt) TO lnS
	THIS.nTotSq = lnS
	THIS.nNol = RECCOUNT("cWbSib")
	GO TOP
	ENDPROC

	* share tnTotal over cWbSib by SqMt, 3 decimals; the rounding difference goes to
	* the biggest share so the shares add up to tnTotal exactly
	PROCEDURE SetShares
	LPARAMETERS tnTotal
	LOCAL lnSq, lnN, lnSum, lnMax
	SELECT cWbSib
	lnN = RECCOUNT()
	CALCULATE SUM(sqmt) TO lnSq
	SCAN
		IF lnSq > 0
			REPLACE share WITH ROUND(tnTotal * sqmt / lnSq, 3), taken WITH .F.
		ELSE
			REPLACE share WITH ROUND(tnTotal / lnN, 3), taken WITH .F.
		ENDIF
	ENDSCAN
	CALCULATE SUM(share) TO lnSum
	IF lnN > 0 .AND. ROUND(tnTotal - lnSum, 3) # 0
		CALCULATE MAX(share) TO lnMax
		LOCATE FOR share = lnMax
		REPLACE share WITH ROUND(share + (tnTotal - lnSum), 3)
	ENDIF
	GO TOP
	ENDPROC

	* OL / quantity changed on screen: order info + division preview
	PROCEDURE Recalc
	LOCAL lcOl, lnQty
	lcOl = ALLTRIM(THIS.txtOl.Value)
	lnQty = THIS.txtQty.Value
	IF EMPTY(lcOl)
		THIS.NewShareCursor()
		THIS.cSupplier = ""
		THIS.cDesign = ""
		THIS.nTotSq = 0
		THIS.nNol = 0
	ELSE
		IF !EMPTY(THIS.cGrp) .AND. THIS.HasRows(THIS.cGrp, lcOl)
			=THIS.LoadMembers(THIS.cGrp, lcOl)
		ELSE
			=THIS.LoadOrder(lcOl)
		ENDIF
	ENDIF
	THIS.txtParty.Value = THIS.cSupplier
	THIS.txtDesign.Value = THIS.cDesign
	THIS.txtTotSq.Value = THIS.nTotSq
	THIS.txtNol.Value = THIS.nNol
	THIS.SetShares(lnQty)
	THIS.txtAmt.Value = ROUND(THIS.txtRate.Value * lnQty, 2)
	THIS.ShowShares()
	ENDPROC

	* .T. when the entry tcGrp is committed and one of its Wiissue rows is OL tcOl
	FUNCTION HasRows
	LPARAMETERS tcGrp, tcOl
	LOCAL laC[1]
	tcOl = ALLTRIM(tcOl)
	SELECT COUNT(*) FROM wi_w WHERE grpid = tcGrp AND ALLTRIM(ol_no) == tcOl INTO ARRAY laC
	RETURN (laC[1] > 0)
	ENDFUNC

	PROCEDURE ShowShares
	SELECT cWbSib
	GO TOP
	THIS.lstSh.RowSource = "cWbSib.ol_no,sqmt,share"
	THIS.lstSh.Refresh()
	ENDPROC

	* ---------- yarn quality: type and rate ----------
	FUNCTION QualityInfo
	LOCAL lcQ, llOk
	lcQ = ALLTRIM(THIS.txtQlty.Value)
	llOk = .F.
	SELECT ytype, srate, srateb FROM wiqlty WHERE quality = lcQ INTO CURSOR cWbQ
	IF RECCOUNT("cWbQ") > 0
		llOk = .T.
		THIS.txtYtype.Value = cWbQ.ytype
		THIS.txtRate.Value = IIF(UPPER(ALLTRIM(THIS.txtBL.Value)) == "L", cWbQ.srate, cWbQ.srateb)
	ELSE
		THIS.txtYtype.Value = ""
		THIS.txtRate.Value = 0
	ENDIF
	USE IN cWbQ
	THIS.txtAmt.Value = ROUND(THIS.txtRate.Value * THIS.txtQty.Value, 2)
	RETURN llOk
	ENDFUNC

	* stock balance of this quality / colour (wistockdata.prg, as the old issue form);
	* returns the balance, sets cDyewht / cComment
	FUNCTION StockBalance
	LOCAL lcProc
	PUBLIC Psquality, Pscolour, Pbalance, Pcomment, Pdyewht
	Psquality = ALLTRIM(THIS.txtQlty.Value)
	Pscolour = ALLTRIM(THIS.txtColour.Value)
	Pbalance = 0
	Pcomment = "Dyed Yarn Issue"
	Pdyewht = "D"
	lcProc = SET("PROCEDURE")
	DO wistockdata
	IF EMPTY(lcProc)
		SET PROCEDURE TO
	ELSE
		SET PROCEDURE TO (lcProc)
	ENDIF
	THIS.cDyewht = Pdyewht
	THIS.cComment = Pcomment
	THIS.txtComment.Value = Pcomment
	THIS.txtBal.Value = Pbalance
	RETURN Pbalance
	ENDFUNC

	*-----------------------------------------------------------------
	* ---------- screen <-> table ----------
	PROCEDURE ToScreen
	SELECT wbk
	IF EOF() .OR. RECCOUNT() = 0
		THIS.cGrp = ""
		THIS.cOldOl = ""
		THIS.ClearScreen()
		THIS.ShowStatus("")
		RETURN
	ENDIF
	THIS.cGrp = ALLTRIM(wbk.grpid)
	THIS.cOldOl = ALLTRIM(wbk.ol_no)
	THIS.txtOl.Value = ALLTRIM(wbk.ol_no)
	THIS.txtParty.Value = ALLTRIM(wbk.party)
	THIS.txtBill.Value = ALLTRIM(wbk.billno)
	THIS.txtDate.Value = wbk.date
	THIS.txtBL.Value = wbk.optionbl
	THIS.txtQlty.Value = ALLTRIM(wbk.quality)
	THIS.txtColour.Value = ALLTRIM(wbk.colour)
	THIS.txtYtype.Value = ALLTRIM(wbk.ytype)
	THIS.txtQty.Value = wbk.quantity
	THIS.txtRate.Value = wbk.rate
	THIS.txtAmt.Value = wbk.amt
	THIS.txtComment.Value = ALLTRIM(wbk.comment)
	THIS.txtTotSq.Value = wbk.totsqmt
	THIS.txtNol.Value = wbk.nol
	THIS.txtBal.Value = 0
	THIS.cDyewht = IIF(EMPTY(wbk.dyewht), "D", wbk.dyewht)
	THIS.cComment = ALLTRIM(wbk.comment)
	THIS.txtDesign.Value = THIS.DesignOf(THIS.cOldOl)
	DO CASE
	CASE THIS.GroupInfo(THIS.cGrp, 0, 0) > 0
		THIS.LoadSaved()
	OTHERWISE
		* saved but not committed: show how Commit would divide it
		THIS.Recalc()
	ENDCASE
	THIS.ShowStatus(THIS.StatusOf())
	ENDPROC

	PROCEDURE ClearScreen
	THIS.txtOl.Value = ""
	THIS.txtParty.Value = ""
	THIS.txtDesign.Value = ""
	THIS.txtTotSq.Value = 0
	THIS.txtNol.Value = 0
	THIS.txtBill.Value = ""
	THIS.txtDate.Value = {}
	THIS.txtBL.Value = ""
	THIS.txtQlty.Value = ""
	THIS.txtColour.Value = ""
	THIS.txtYtype.Value = ""
	THIS.txtQty.Value = 0
	THIS.txtRate.Value = 0
	THIS.txtAmt.Value = 0
	THIS.txtBal.Value = 0
	THIS.txtComment.Value = ""
	THIS.NewShareCursor()
	THIS.ShowShares()
	ENDPROC

	* division of a committed line = the Wiissue rows that carry its GRPID
	PROCEDURE LoadSaved
	LOCAL lcG
	lcG = THIS.cGrp
	THIS.NewShareCursor()
	SELECT w.ol_no, b.sqmt, w.quantity ;
		FROM wi_w w LEFT JOIN cabuyord b ON b.ol_no = w.ol_no ;
		WHERE w.grpid = lcG ;
		ORDER BY w.ol_no ;
		INTO CURSOR cWbL
	SELECT cWbL
	SCAN
		INSERT INTO cWbSib (ol_no, sqmt, share) VALUES (cWbL.ol_no, IIF(ISNULL(cWbL.sqmt), 0, cWbL.sqmt), cWbL.quantity)
	ENDSCAN
	USE IN cWbL
	THIS.ShowShares()
	ENDPROC

	FUNCTION DesignOf
	LPARAMETERS tcOl
	LOCAL lcD
	lcD = ""
	SELECT design FROM cabuyord WHERE ol_no = tcOl INTO CURSOR cWbDs
	IF RECCOUNT("cWbDs") > 0
		lcD = ALLTRIM(cWbDs.design)
	ENDIF
	USE IN cWbDs
	RETURN lcD
	ENDFUNC

	* NOT COMMITTED / COMMITTED / CHANGED - COMMIT AGAIN  (saved line against its Wiissue rows)
	FUNCTION StatusOf
	LOCAL lnN, lnTot, lnPrn, laM[1]
	SELECT wbk
	lnN = THIS.GroupInfo(THIS.cGrp, @lnTot, @lnPrn)
	IF lnN = 0
		RETURN "NOT COMMITTED"
	ENDIF
	SELECT COUNT(*) FROM wi_w ;
		WHERE grpid = THIS.cGrp AND ALLTRIM(billno) == ALLTRIM(wbk.billno) AND ALLTRIM(quality) == ALLTRIM(wbk.quality) ;
		AND ALLTRIM(colour) == ALLTRIM(wbk.colour) AND date = wbk.date AND ALLTRIM(party) == ALLTRIM(wbk.party) ;
		AND UPPER(optionbl) == UPPER(wbk.optionbl) INTO ARRAY laM
	IF laM[1] = lnN .AND. ROUND(lnTot - wbk.quantity, 3) = 0
		RETURN "COMMITTED"
	ENDIF
	RETURN "CHANGED - COMMIT AGAIN"
	ENDFUNC

	PROCEDURE ShowStatus
	LPARAMETERS tcText
	THIS.txtStatus.Value = tcText
	DO CASE
	CASE tcText == "COMMITTED"
		THIS.txtStatus.BackColor = RGB(153, 255, 153)
	CASE EMPTY(tcText)
		THIS.txtStatus.BackColor = RGB(220, 220, 220)
	OTHERWISE
		THIS.txtStatus.BackColor = RGB(255, 204, 153)
	ENDCASE
	ENDPROC

	*-----------------------------------------------------------------
	* ---------- buttons ----------
	PROCEDURE AddEntry
	SELECT wbk
	THIS.cGrp = ""
	THIS.cOldOl = ""
	THIS.ClearScreen()
	THIS.txtDate.Value = DATE()
	THIS.txtBL.Value = "L"
	THIS.cDyewht = "D"
	THIS.cComment = "Dyed Yarn Issue"
	THIS.txtComment.Value = THIS.cComment
	THIS.nOldQty = 0
	THIS.cOldQlty = ""
	THIS.cOldColour = ""
	THIS.ShowStatus("NEW ENTRY")
	THIS.SetMode("A")
	THIS.txtOl.SetFocus()
	ENDPROC

	PROCEDURE EditEntry
	LOCAL lnN, lnTot, lnPrn
	SELECT wbk
	IF EOF() .OR. RECCOUNT() = 0
		RETURN
	ENDIF
	lnN = THIS.GroupInfo(THIS.cGrp, @lnTot, @lnPrn)
	IF lnPrn > 0
		THIS.Msg("Cannot edit: the bill/slip of this issue is already printed.", 48)
		RETURN
	ENDIF
	THIS.nOldQty = wbk.quantity
	THIS.cOldQlty = ALLTRIM(wbk.quality)
	THIS.cOldColour = ALLTRIM(wbk.colour)
	THIS.ShowStatus("EDITING")
	THIS.SetMode("E")
	THIS.txtOl.SetFocus()
	ENDPROC

	* rows / total kg / printed slips of the Wiissue rows of one bulk line
	FUNCTION GroupInfo
	LPARAMETERS tcGrp, tnTot, tnPrn
	LOCAL laI[3], lnN
	tnTot = 0
	tnPrn = 0
	lnN = 0
	IF !EMPTY(tcGrp)
		SELECT COUNT(*), SUM(quantity), SUM(IIF(EMPTY(slipno), 0, 1)) FROM wi_w WHERE grpid = tcGrp INTO ARRAY laI
		lnN = laI[1]
		tnTot = IIF(lnN > 0, laI[2], 0)
		tnPrn = IIF(lnN > 0, laI[3], 0)
	ENDIF
	RETURN lnN
	ENDFUNC

	FUNCTION FindEntry
	LPARAMETERS tcKey
	LOCAL lcKey, lnRec, laG[1]
	lcKey = UPPER(ALLTRIM(tcKey))
	IF EMPTY(lcKey) .AND. !THIS.lSilent
		lcKey = UPPER(ALLTRIM(INPUTBOX("OL No or Bill No to find:", THIS.Caption, "")))
	ENDIF
	IF EMPTY(lcKey)
		RETURN .F.
	ENDIF
	SELECT wbk
	lnRec = RECNO()
	LOCATE FOR UPPER(ALLTRIM(ol_no)) == lcKey .OR. UPPER(ALLTRIM(billno)) == lcKey
	IF !FOUND()
		* any OL of a committed issue
		SELECT grpid FROM wi_w WHERE UPPER(ALLTRIM(ol_no)) == lcKey AND !EMPTY(grpid) INTO ARRAY laG
		IF _TALLY > 0
			SELECT wbk
			LOCATE FOR ALLTRIM(grpid) == ALLTRIM(laG[1])
		ENDIF
	ENDIF
	IF FOUND()
		THIS.SetMode("V")
		THIS.ToScreen()
		RETURN .T.
	ENDIF
	SELECT wbk
	IF lnRec > 0 .AND. lnRec <= RECCOUNT()
		GO lnRec
	ENDIF
	THIS.Msg(lcKey + " not found.", 48)
	RETURN .F.
	ENDFUNC

	*-----------------------------------------------------------------
	* ---------- validate, save, commit ----------
	* returns "" when ok, else the text of the first problem
	FUNCTION Validate
	LOCAL lcOl, lcQ, lcC, lnQty, ldDate, lcAnsi, lnAllowed, laD[1], lcMyGrp
	lcOl = ALLTRIM(THIS.txtOl.Value)
	lcQ = ALLTRIM(THIS.txtQlty.Value)
	lcC = ALLTRIM(THIS.txtColour.Value)
	lnQty = THIS.txtQty.Value
	ldDate = THIS.txtDate.Value
	IF EMPTY(lcOl)
		RETURN "OL No must be entered."
	ENDIF
	IF THIS.LoadOrder(lcOl) = 0 .OR. EMPTY(THIS.cSupplier)
		RETURN "OL No " + lcOl + " is not in the order file (Casupord / Cabuyord)."
	ENDIF
	IF EMPTY(ALLTRIM(THIS.txtBill.Value))
		RETURN "Bill No must be entered."
	ENDIF
	IF EMPTY(ldDate)
		RETURN "Issue Date must be entered."
	ENDIF
	IF ldDate > DATE()
		RETURN "Future date entry is not allowed."
	ENDIF
	IF !(UPPER(ALLTRIM(THIS.txtBL.Value)) $ "BL") .OR. EMPTY(THIS.txtBL.Value)
		RETURN "Type B for Ball yarn or L for Lachhi yarn."
	ENDIF
	IF !THIS.QualityInfo()
		RETURN "Yarn Quality " + lcQ + " is not in the yarn quality list."
	ENDIF
	lcAnsi = SET("ANSI")
	SET ANSI ON
	SELECT code FROM cacolour WHERE code = lcC INTO CURSOR cWbC
	SET ANSI &lcAnsi
	lnAllowed = RECCOUNT("cWbC")
	USE IN cWbC
	IF EMPTY(lcC) .OR. lnAllowed = 0
		RETURN "Yarn Colour " + lcC + " is not in the colour list."
	ENDIF
	IF lnQty <= 0
		RETURN "Net Wt must be more than zero."
	ENDIF
	lcMyGrp = IIF(THIS.cMode == "E", THIS.cGrp, "#none#")
	SELECT COUNT(*) FROM wbk ;
		WHERE ALLTRIM(ol_no) == lcOl AND ALLTRIM(quality) == lcQ AND ALLTRIM(colour) == lcC ;
		AND date = ldDate AND UPPER(optionbl) == UPPER(ALLTRIM(THIS.txtBL.Value)) AND !(ALLTRIM(grpid) == lcMyGrp) ;
		INTO ARRAY laD
	IF laD[1] > 0
		RETURN "Same OL, quality, colour, date and Ball/Lachhi is already entered."
	ENDIF
	IF THIS.lCheckStock
		lnAllowed = THIS.StockBalance()
		IF THIS.cMode == "E" .AND. lcQ == THIS.cOldQlty .AND. lcC == THIS.cOldColour
			lnAllowed = lnAllowed + THIS.nOldQty
		ENDIF
		IF lnQty > lnAllowed
			RETURN "Cannot issue more than the stock balance (" + ALLTRIM(STR(lnAllowed, 12, 3)) + " kg)."
		ENDIF
	ENDIF
	RETURN ""
	ENDFUNC

	* Save: the bulk line only (Wiissue is not touched - that is Commit)
	FUNCTION SaveEntry
	LOCAL lcErr, llOk
	IF !(THIS.cMode $ "AE")
		RETURN .F.
	ENDIF
	lcErr = THIS.Validate()
	IF !EMPTY(lcErr)
		THIS.Msg(lcErr, 48)
		RETURN .F.
	ENDIF
	* a committed line keeps its OLs: total SqMt / number of OLs from them
	IF THIS.cMode == "E" .AND. THIS.HasRows(THIS.cGrp, THIS.txtOl.Value)
		=THIS.LoadMembers(THIS.cGrp, THIS.txtOl.Value)
	ENDIF
	llOk = THIS.Guarded("SAVE")
	IF llOk
		THIS.SetMode("V")
		THIS.ToScreen()
		THIS.SetMode("V")
	ENDIF
	RETURN llOk
	ENDFUNC

	* Commit: divide the saved line by SqMt and write the rows into Wiissue
	FUNCTION CommitEntry
	LOCAL lnN, lnTot, lnPrn, llOk, lcG, lnSum, lcOl
	IF THIS.cMode $ "AE"
		IF !THIS.SaveEntry()
			RETURN .F.
		ENDIF
	ENDIF
	SELECT wbk
	IF EOF() .OR. RECCOUNT() = 0
		THIS.Msg("Nothing to commit: Save an entry first.", 48)
		RETURN .F.
	ENDIF
	lcG = ALLTRIM(wbk.grpid)
	lcOl = ALLTRIM(wbk.ol_no)
	lnN = THIS.GroupInfo(lcG, @lnTot, @lnPrn)
	IF lnPrn > 0
		THIS.Msg("Cannot commit again: the bill/slip of this issue is already printed.", 48)
		RETURN .F.
	ENDIF
	IF THIS.StatusOf() == "COMMITTED"
		THIS.Msg("Already committed and up to date.", 64)
		RETURN .F.
	ENDIF
	* committed before: keep its OLs (unless the OL No was changed to another Order Form)
	IF lnN > 0 .AND. THIS.HasRows(lcG, lcOl)
		=THIS.LoadMembers(lcG, lcOl)
	ELSE
		=THIS.LoadOrder(lcOl)
	ENDIF
	THIS.SetShares(wbk.quantity)
	SELECT cWbSib
	CALCULATE SUM(share) TO lnSum
	IF lnSum <= 0
		THIS.Msg("Nothing to divide: the OLs of the Order Form have no SqMt / quantity.", 48)
		RETURN .F.
	ENDIF
	IF THIS.Msg("Send " + ALLTRIM(STR(wbk.quantity, 12, 3)) + " kg divided by SqMt over " + ALLTRIM(STR(THIS.nNol)) + " OL to Wiissue?", 36) # 6
		RETURN .F.
	ENDIF
	llOk = THIS.Guarded("COMMIT")
	IF llOk
		THIS.SetMode("V")
		THIS.ToScreen()
		THIS.SetMode("V")
	ENDIF
	RETURN llOk
	ENDFUNC

	* the database work in one transaction: all or nothing
	FUNCTION Guarded
	LPARAMETERS tcWhat
	LOCAL lcOldErr, llOk
	PRIVATE pcWbErr
	pcWbErr = ""
	lcOldErr = ON("ERROR")
	ON ERROR pcWbErr = MESSAGE()
	BEGIN TRANSACTION
	IF tcWhat == "SAVE"
		THIS.WriteLine()
	ELSE
		THIS.WriteRows()
	ENDIF
	IF EMPTY(pcWbErr)
		END TRANSACTION
		llOk = .T.
	ELSE
		ROLLBACK
		llOk = .F.
	ENDIF
	ON ERROR &lcOldErr
	IF !llOk
		THIS.Msg("Not saved:" + CHR(13) + pcWbErr, 48)
	ENDIF
	RETURN llOk
	ENDFUNC

	* the bulk line (WIISSUE_BULK)
	PROCEDURE WriteLine
	LOCAL loB
	SELECT wbk
	IF THIS.cMode == "A"
		APPEND BLANK
		SCATTER NAME loB
		loB.grpid = THIS.NewGrpId()
		loB.entryby = IIF(TYPE("pname") = "C", pname, "")
		loB.datetime = DATETIME()
	ELSE
		SCATTER NAME loB
	ENDIF
	loB.ol_no = ALLTRIM(THIS.txtOl.Value)
	loB.party = THIS.cSupplier
	loB.billno = ALLTRIM(THIS.txtBill.Value)
	loB.date = THIS.txtDate.Value
	loB.optionbl = UPPER(ALLTRIM(THIS.txtBL.Value))
	loB.quality = ALLTRIM(THIS.txtQlty.Value)
	loB.colour = ALLTRIM(THIS.txtColour.Value)
	loB.ytype = ALLTRIM(THIS.txtYtype.Value)
	loB.quantity = THIS.txtQty.Value
	loB.rate = THIS.txtRate.Value
	loB.amt = ROUND(THIS.txtRate.Value * THIS.txtQty.Value, 2)
	loB.comment = THIS.cComment
	loB.dyewht = THIS.cDyewht
	loB.totsqmt = THIS.nTotSq
	loB.nol = THIS.nNol
	SELECT wbk
	GATHER NAME loB
	ENDPROC

	* the divided rows (WIISSUE): update rows already in the group, delete those whose OL
	* left it, insert the rest.  cWbSib holds the shares.
	PROCEDURE WriteRows
	LOCAL laRow[1], lni, lnN, lnOl, lnQty, lnAmt, lnRate, lcG
	SELECT wbk
	REPLACE totsqmt WITH THIS.nTotSq, nol WITH THIS.nNol
	lcG = ALLTRIM(wbk.grpid)
	lnN = FCOUNT("wi_w")
	DIMENSION laRow[lnN]
	FOR lni = 1 TO lnN
		laRow[lni] = EVALUATE("wbk." + FIELD(lni, "wi_w"))
		DO CASE
		CASE FIELD(lni, "wi_w") == "OL_NO"
			lnOl = lni
		CASE FIELD(lni, "wi_w") == "QUANTITY"
			lnQty = lni
		CASE FIELD(lni, "wi_w") == "AMT"
			lnAmt = lni
		CASE FIELD(lni, "wi_w") == "RATE"
			lnRate = lni
		ENDCASE
	ENDFOR
	SELECT wi_w
	SCAN FOR EMPTY(pcWbErr) .AND. grpid = lcG
		SELECT cWbSib
		LOCATE FOR ALLTRIM(ol_no) == ALLTRIM(wi_w.ol_no) .AND. !taken .AND. share > 0
		IF FOUND()
			REPLACE taken WITH .T.
			laRow[lnOl] = cWbSib.ol_no
			laRow[lnQty] = cWbSib.share
			laRow[lnAmt] = ROUND(laRow[lnRate] * cWbSib.share, 2)
			SELECT wi_w
			GATHER FROM laRow
		ELSE
			SELECT wi_w
			DELETE
		ENDIF
		SELECT wi_w
	ENDSCAN
	SELECT cWbSib
	SCAN FOR EMPTY(pcWbErr) .AND. !taken .AND. share > 0
		laRow[lnOl] = cWbSib.ol_no
		laRow[lnQty] = cWbSib.share
		laRow[lnAmt] = ROUND(laRow[lnRate] * cWbSib.share, 2)
		SELECT wi_w
		INSERT INTO wi_w FROM ARRAY laRow
		SELECT cWbSib
	ENDSCAN
	ENDPROC

	FUNCTION NewGrpId
	LOCAL lcId, laC[1]
	DO WHILE .T.
		lcId = SUBSTR(DTOS(DATE()), 3) + STRTRAN(TIME(), ":", "") + PADL(INT(RAND() * 1000), 3, "0")
		SELECT COUNT(*) FROM wbk WHERE grpid = lcId INTO ARRAY laC
		IF laC[1] = 0
			EXIT
		ENDIF
	ENDDO
	RETURN lcId
	ENDFUNC

ENDDEFINE
