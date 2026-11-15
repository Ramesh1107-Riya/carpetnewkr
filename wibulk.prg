*=====================================================================
* wibulk.prg   -   BULK ISSUE of yarn to SUPPLIER by Order Form GRPID      (DO wibulk)
*
* Data entry for WIISSUE_BULK.  One line = one bulk issue (total kg) to the OLs of one
* Order Form.  The Order Form is Casupord.GRPID, the number set by "GrpID Update" on the
* Order Form screen (rordform.scx, list = orderformview).  Type the GRPID or pick it
* with [Groups]; the OLs, supplier, design, total SqMt and number of OLs come from
* Casupord / Cabuyord.
*
*   Save    keeps the bulk line in WIISSUE_BULK (Wiissue is not touched yet)
*   Commit  divides the line over the OLs of its GRPID by SqMt and writes one WIISSUE
*           row per OL (Wiissue.GRPID = the line's BULKID).  Commit again after an
*           Edit, or after OLs were added to / taken out of the GRPID.
*   Edit / Delete   blocked once a Wiissue row of the line has a printed SlipNo
*   Search  by GRPID, Bill No or OL No.   |<  <  >  >|  move through the lines.
*
* Needs (once):  DO wiissue_addgrp   and   DO wiissue_bulk_create
* For scripts:   lSilent = .T. (no dialogs, Msg returns Yes), lCheckStock = .F.
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
	* K = select the whole value on entry, so typing replaces it (e.g. the 0 of GRPID)
	Format = "K"
	PROCEDURE LostFocus
		THISFORM.CtlLost(THIS.Name)
	ENDPROC
ENDDEFINE

DEFINE CLASS wbBtn AS CommandButton
	FontName = "Arial"
	FontSize = 10
	FontBold = .T.
	Height = 32
	Width = 95
	PROCEDURE Click
		THISFORM.BtnClick(THIS.Name)
	ENDPROC
ENDDEFINE


*---------------------------------------------------------------------
DEFINE CLASS frmWiBulk AS Form
	Caption = "Bulk Issue of Yarn to SUPPLIER - by Order Form GRPID"
	Height = 580
	Width = 790
	AutoCenter = .T.
	DataSession = 2
	BorderStyle = 2
	MaxButton = .F.
	BackColor = RGB(0, 153, 255)
	cMode = "V"
	cBulk = ""
	nGrp = 0
	cSupplier = ""
	cDesign = ""
	nTotSq = 0
	nNol = 0
	nOldQty = 0
	cOldQlty = ""
	cOldColour = ""
	cDyewht = "D"
	cComment = "Dyed Yarn Issue"
	cPoNo = ""
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
	IF TYPE("wbk.bulkid") = "U" .OR. TYPE("wbk.grpid") # "N"
		THIS.Msg("WIISSUE_BULK has the old structure." + CHR(13) + "Run  DO wiissue_bulk_create  once (all users out of the program).", 16)
		RETURN .F.
	ENDIF
	SET ORDER TO grpid IN wbk
	USE wiissue AGAIN SHARED IN 0 ALIAS wi_w
	IF TYPE("wi_w.grpid") = "U"
		THIS.Msg("Wiissue has no GRPID column." + CHR(13) + "Run  DO wiissue_addgrp  once (all users out of the program).", 16)
		RETURN .F.
	ENDIF
	IF !USED("casupord")
		USE casupord SHARED IN 0
	ENDIF
	IF TYPE("casupord.grpid") # "N"
		THIS.Msg("Casupord has no numeric GRPID column.", 16)
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
	THIS.AddLbl("lblTitle", "Bulk Issue of Yarn to SUPPLIER  (divided by SqMt over the OLs of the Order Form GRPID)", 12, 20, 750, 14)
	THIS.AddLbl("l1", "Order GRPID", 52, 20, 100, 10)
	THIS.AddTxt("txtGrp", 48, 135, 80, 0, .F.)
	THIS.AddBtn("cmdGroups", "Groups...", 225, 46, 90)
	THIS.AddLbl("l2", "Supplier", 52, 330, 70, 10)
	THIS.AddTxt("txtParty", 48, 400, 200, "", .T.)
	THIS.AddLbl("l2b", "Order Dt", 52, 615, 65, 10)
	THIS.AddTxt("txtIssdt", 48, 685, 90, {}, .T.)
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
	THIS.AddLbl("l17", "Division over the OLs   (OL No  /  Card No  /  SqMt  /  Kg)", 292, 20, 500, 10)
	THIS.txtGrp.InputMask = "999999"
	THIS.txtQty.InputMask = "999999.999"
	THIS.txtRate.InputMask = "99999.99"
	THIS.txtAmt.InputMask = "999999999.99"
	THIS.txtTotSq.InputMask = "99999.99"
	THIS.txtBal.InputMask = "999999.999"
	THIS.txtDate.Format = "DK"
	THIS.txtIssdt.Format = "D"
	THIS.txtBL.MaxLength = 1
	THIS.txtStatus.FontBold = .T.
	THIS.AddObject("lstSh", "ListBox")
	WITH THIS.lstSh
		.Left = 20
		.Top = 312
		.Width = 750
		.Height = 140
		.FontName = "Courier New"
		.FontSize = 10
		.ColumnCount = 4
		.ColumnWidths = "220,150,170,170"
		.RowSourceType = 6
		.Visible = .T.
	ENDWITH
	THIS.AddBtn("cmdSave", "Save", 20, 470, 95)
	THIS.AddBtn("cmdEdit", "Edit", 120, 470, 95)
	THIS.AddBtn("cmdDelete", "Delete", 220, 470, 95)
	THIS.AddBtn("cmdCommit", "Commit", 320, 470, 95)
	THIS.AddBtn("cmdNew", "New", 420, 470, 95)
	THIS.AddBtn("cmdSearch", "Search", 520, 470, 95)
	THIS.AddBtn("cmdFirst", "|<", 20, 515, 45)
	THIS.AddBtn("cmdPrev", "<", 70, 515, 45)
	THIS.AddBtn("cmdNext", ">", 120, 515, 45)
	THIS.AddBtn("cmdLast", ">|", 170, 515, 45)
	THIS.AddBtn("cmdExit", "Exit", 675, 515, 95)
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
	LPARAMETERS tcName, tcCap, tnLeft, tnTop, tnWidth
	THIS.AddObject(tcName, "wbBtn")
	WITH THIS.&tcName
		.Caption = tcCap
		.Left = tnLeft
		.Top = tnTop
		.Width = tnWidth
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
	llLine = (!EOF() .AND. !BOF() .AND. RECCOUNT() > 0 .AND. !EMPTY(THIS.cBulk))
	THIS.txtGrp.ReadOnly = !llEntry
	THIS.txtBill.ReadOnly = !llEntry
	THIS.txtDate.ReadOnly = !llEntry
	THIS.txtBL.ReadOnly = !llEntry
	THIS.txtQlty.ReadOnly = !llEntry
	THIS.txtColour.ReadOnly = !llEntry
	THIS.txtQty.ReadOnly = !llEntry
	THIS.cmdGroups.Enabled = llEntry
	THIS.cmdSave.Enabled = llEntry
	THIS.cmdEdit.Enabled = (tcMode == "V" .AND. llLine)
	THIS.cmdDelete.Enabled = (tcMode == "V" .AND. llLine)
	THIS.cmdCommit.Enabled = (llLine .AND. tcMode # "A")
	THIS.cmdFirst.Enabled = !llEntry
	THIS.cmdPrev.Enabled = !llEntry
	THIS.cmdNext.Enabled = !llEntry
	THIS.cmdLast.Enabled = !llEntry
	ENDPROC

	PROCEDURE BtnClick
	LPARAMETERS tcName
	DO CASE
	CASE tcName == "cmdSave"
		THIS.SaveEntry()
	CASE tcName == "cmdEdit"
		THIS.EditEntry()
	CASE tcName == "cmdDelete"
		THIS.DeleteEntry()
	CASE tcName == "cmdCommit"
		THIS.CommitEntry()
	CASE tcName == "cmdNew"
		THIS.AddEntry()
	CASE tcName == "cmdSearch"
		THIS.FindEntry("")
	CASE tcName == "cmdGroups"
		THIS.PickGroup()
	CASE tcName == "cmdFirst" .OR. tcName == "cmdPrev" .OR. tcName == "cmdNext" .OR. tcName == "cmdLast"
		THIS.MoveTo(SUBSTR(tcName, 4))
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
	CASE tcName == "txtGrp"
		THIS.Recalc()
	CASE tcName == "txtQlty" .OR. tcName == "txtBL"
		THIS.QualityInfo()
		THIS.Recalc()
	CASE tcName == "txtQty"
		THIS.Recalc()
	ENDCASE
	ENDPROC

	*-----------------------------------------------------------------
	* ---------- Order Form group (Casupord.GRPID) ----------
	* Fills cWbSib with the OLs of GRPID tnGrp and sets cSupplier, cDesign, cPoNo,
	* nTotSq, nNol and the order boxes.  Returns the number of OLs (0 = no such GRPID).
	FUNCTION LoadGroup
	LPARAMETERS tnGrp
	THIS.NewShareCursor()
	THIS.cSupplier = ""
	THIS.cDesign = ""
	THIS.cPoNo = ""
	THIS.txtIssdt.Value = {}
	IF tnGrp > 0
		SELECT s.ol_no, s.card_no, s.weaver, s.supplier, s.issdt, b.design, b.po_no, b.sqmt ;
			FROM casupord s, cabuyord b ;
			WHERE b.ol_no = s.ol_no AND s.grpid = tnGrp ;
			ORDER BY 1 ;
			INTO CURSOR cWbG
		SELECT cWbG
		SCAN
			INSERT INTO cWbSib (ol_no, card_no, weaver, po_no, sqmt) ;
				VALUES (cWbG.ol_no, cWbG.card_no, cWbG.weaver, cWbG.po_no, cWbG.sqmt)
		ENDSCAN
		SELECT cWbG
		GO TOP
		IF !EOF()
			THIS.cSupplier = ALLTRIM(cWbG.supplier)
			THIS.cDesign = ALLTRIM(cWbG.design)
			THIS.cPoNo = ALLTRIM(cWbG.po_no)
			THIS.txtIssdt.Value = cWbG.issdt
		ENDIF
		USE IN cWbG
	ENDIF
	THIS.TotalsFromCursor()
	RETURN RECCOUNT("cWbSib")
	ENDFUNC

	PROCEDURE NewShareCursor
	IF USED("cWbSib")
		USE IN cWbSib
	ENDIF
	CREATE CURSOR cWbSib (ol_no C(15), card_no C(7), weaver C(20), po_no C(15), sqmt N(8,2), share N(11,3), taken L)
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

	* GRPID / quantity changed on screen: order info + division preview
	PROCEDURE Recalc
	LOCAL lnQty
	lnQty = THIS.txtQty.Value
	THIS.nGrp = THIS.txtGrp.Value
	IF THIS.LoadGroup(THIS.nGrp) = 0 .AND. THIS.nGrp > 0 .AND. !THIS.lSilent
		WAIT WINDOW "GRPID " + ALLTRIM(STR(THIS.nGrp)) + " has no OL in Casupord - use [Groups...] to pick one." NOWAIT
	ENDIF
	THIS.txtParty.Value = THIS.cSupplier
	THIS.txtDesign.Value = THIS.cDesign
	THIS.txtTotSq.Value = THIS.nTotSq
	THIS.txtNol.Value = THIS.nNol
	THIS.SetShares(lnQty)
	THIS.txtAmt.Value = ROUND(THIS.txtRate.Value * lnQty, 2)
	THIS.ShowShares()
	ENDPROC

	PROCEDURE ShowShares
	SELECT cWbSib
	GO TOP
	THIS.lstSh.RowSource = "cWbSib.ol_no,card_no,sqmt,share"
	THIS.lstSh.Refresh()
	ENDPROC

	* [Groups...]: pick an Order Form GRPID from a list
	PROCEDURE PickGroup
	LOCAL loP, lnG
	loP = CREATEOBJECT("frmWbPick")
	IF TYPE("loP") # "O" .OR. ISNULL(loP)
		RETURN
	ENDIF
	loP.Show(1)
	lnG = loP.nPick
	loP.Release()
	IF lnG > 0
		THIS.txtGrp.Value = lnG
		THIS.Recalc()
		THIS.txtBill.SetFocus()
	ENDIF
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
	IF EOF() .OR. BOF() .OR. RECCOUNT() = 0
		THIS.cBulk = ""
		THIS.nGrp = 0
		THIS.ClearScreen()
		THIS.ShowStatus("")
		RETURN
	ENDIF
	THIS.cBulk = ALLTRIM(wbk.bulkid)
	THIS.nGrp = wbk.grpid
	THIS.txtGrp.Value = wbk.grpid
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
	THIS.txtBal.Value = 0
	THIS.cDyewht = IIF(EMPTY(wbk.dyewht), "D", wbk.dyewht)
	THIS.cComment = ALLTRIM(wbk.comment)
	* order info of the GRPID as it is now
	=THIS.LoadGroup(wbk.grpid)
	THIS.txtDesign.Value = THIS.cDesign
	IF THIS.GroupInfo(THIS.cBulk, 0, 0) > 0
		* committed: show the rows really written to Wiissue
		THIS.LoadSaved()
		THIS.txtTotSq.Value = wbk.totsqmt
		THIS.txtNol.Value = wbk.nol
	ELSE
		* saved, not committed: show how Commit would divide it
		THIS.txtTotSq.Value = THIS.nTotSq
		THIS.txtNol.Value = THIS.nNol
		THIS.SetShares(wbk.quantity)
		THIS.ShowShares()
	ENDIF
	THIS.ShowStatus(THIS.StatusOf())
	ENDPROC

	PROCEDURE ClearScreen
	THIS.txtGrp.Value = 0
	THIS.txtParty.Value = ""
	THIS.txtIssdt.Value = {}
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

	* division of a committed line = the Wiissue rows that carry its BULKID
	PROCEDURE LoadSaved
	LOCAL lcB
	lcB = THIS.cBulk
	THIS.NewShareCursor()
	SELECT w.ol_no, w.card_no, w.weaver, w.po_no, b.sqmt, w.quantity ;
		FROM wi_w w LEFT JOIN cabuyord b ON b.ol_no = w.ol_no ;
		WHERE w.grpid = lcB ;
		ORDER BY 1 ;
		INTO CURSOR cWbL
	SELECT cWbL
	SCAN
		INSERT INTO cWbSib (ol_no, card_no, weaver, po_no, sqmt, share) ;
			VALUES (cWbL.ol_no, cWbL.card_no, cWbL.weaver, cWbL.po_no, IIF(ISNULL(cWbL.sqmt), 0, cWbL.sqmt), cWbL.quantity)
	ENDSCAN
	USE IN cWbL
	THIS.ShowShares()
	ENDPROC

	* NOT COMMITTED / COMMITTED / CHANGED - COMMIT AGAIN
	* CHANGED = the line was edited, or OLs were added to / taken out of the GRPID
	FUNCTION StatusOf
	LOCAL lnN, lnTot, lnPrn, laM[1], laO[1], lcB, lnG
	SELECT wbk
	lcB = THIS.cBulk
	lnG = wbk.grpid
	lnN = THIS.GroupInfo(lcB, @lnTot, @lnPrn)
	IF lnN = 0
		RETURN "NOT COMMITTED"
	ENDIF
	SELECT COUNT(*) FROM wi_w ;
		WHERE grpid = lcB AND ALLTRIM(billno) == ALLTRIM(wbk.billno) AND ALLTRIM(quality) == ALLTRIM(wbk.quality) ;
		AND ALLTRIM(colour) == ALLTRIM(wbk.colour) AND date = wbk.date AND ALLTRIM(party) == ALLTRIM(wbk.party) ;
		AND UPPER(optionbl) == UPPER(wbk.optionbl) ;
		AND ol_no IN (SELECT ol_no FROM casupord WHERE grpid = lnG) INTO ARRAY laM
	SELECT COUNT(*) FROM casupord WHERE grpid = lnG INTO ARRAY laO
	IF laM[1] = lnN .AND. laO[1] = lnN .AND. ROUND(lnTot - wbk.quantity, 3) = 0
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
	THIS.cBulk = ""
	THIS.nGrp = 0
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
	THIS.txtGrp.SetFocus()
	ENDPROC

	PROCEDURE EditEntry
	LOCAL lnN, lnTot, lnPrn
	SELECT wbk
	IF EOF() .OR. RECCOUNT() = 0
		RETURN
	ENDIF
	lnN = THIS.GroupInfo(THIS.cBulk, @lnTot, @lnPrn)
	IF lnPrn > 0
		THIS.Msg("Cannot edit: the bill/slip of this issue is already printed.", 48)
		RETURN
	ENDIF
	THIS.nOldQty = wbk.quantity
	THIS.cOldQlty = ALLTRIM(wbk.quality)
	THIS.cOldColour = ALLTRIM(wbk.colour)
	THIS.ShowStatus("EDITING")
	THIS.SetMode("E")
	THIS.txtGrp.SetFocus()
	ENDPROC

	FUNCTION DeleteEntry
	LOCAL lnN, lnTot, lnPrn, llOk
	SELECT wbk
	IF EOF() .OR. RECCOUNT() = 0 .OR. EMPTY(THIS.cBulk)
		RETURN .F.
	ENDIF
	lnN = THIS.GroupInfo(THIS.cBulk, @lnTot, @lnPrn)
	IF lnPrn > 0
		THIS.Msg("Cannot delete: the bill/slip of this issue is already printed.", 48)
		RETURN .F.
	ENDIF
	IF THIS.Msg("Delete this bulk issue (" + ALLTRIM(STR(wbk.quantity, 12, 3)) + " kg, GRPID " + ALLTRIM(STR(wbk.grpid)) + ")" + ;
			IIF(lnN > 0, CHR(13) + "and its " + ALLTRIM(STR(lnN)) + " Wiissue rows", "") + "?", 292) # 6
		RETURN .F.
	ENDIF
	llOk = THIS.Guarded("DELETE")
	IF llOk
		SELECT wbk
		IF !EOF()
			SKIP
		ENDIF
		IF EOF()
			GO BOTTOM
		ENDIF
		THIS.ToScreen()
		THIS.SetMode("V")
	ENDIF
	RETURN llOk
	ENDFUNC

	PROCEDURE MoveTo
	LPARAMETERS tcWhere
	SELECT wbk
	IF RECCOUNT() = 0
		RETURN
	ENDIF
	DO CASE
	CASE tcWhere == "First"
		GO TOP
	CASE tcWhere == "Last"
		GO BOTTOM
	CASE tcWhere == "Prev"
		IF !BOF()
			SKIP -1
		ENDIF
		IF BOF()
			GO TOP
		ENDIF
	CASE tcWhere == "Next"
		IF !EOF()
			SKIP
		ENDIF
		IF EOF()
			GO BOTTOM
		ENDIF
	ENDCASE
	THIS.ToScreen()
	THIS.SetMode("V")
	ENDPROC

	* rows / total kg / printed slips of the Wiissue rows of one bulk line
	FUNCTION GroupInfo
	LPARAMETERS tcBulk, tnTot, tnPrn
	LOCAL laI[3], lnN
	tnTot = 0
	tnPrn = 0
	lnN = 0
	IF !EMPTY(tcBulk)
		SELECT COUNT(*), SUM(quantity), SUM(IIF(EMPTY(slipno), 0, 1)) FROM wi_w WHERE grpid = tcBulk INTO ARRAY laI
		* no rows: VFP6 may leave the array untouched (.F.) or give NULL sums
		IF _TALLY > 0 .AND. TYPE("laI[1]") = "N"
			lnN = laI[1]
		ENDIF
		IF lnN > 0
			tnTot = NVL(laI[2], 0)
			tnPrn = NVL(laI[3], 0)
		ENDIF
	ENDIF
	RETURN lnN
	ENDFUNC

	* Search: GRPID (number), Bill No or OL No
	FUNCTION FindEntry
	LPARAMETERS tcKey
	LOCAL lcKey, lnRec, laG[1], llF
	lcKey = UPPER(ALLTRIM(tcKey))
	IF EMPTY(lcKey) .AND. !THIS.lSilent
		lcKey = UPPER(ALLTRIM(INPUTBOX("GRPID, Bill No or OL No to find:", THIS.Caption, "")))
	ENDIF
	IF EMPTY(lcKey)
		RETURN .F.
	ENDIF
	SELECT wbk
	lnRec = RECNO()
	LOCATE FOR UPPER(ALLTRIM(billno)) == lcKey
	llF = FOUND()
	IF !llF .AND. VAL(lcKey) > 0 .AND. LEN(CHRTRAN(lcKey, "0123456789", "")) = 0
		LOCATE FOR grpid = VAL(lcKey)
		llF = FOUND()
	ENDIF
	IF !llF
		* an OL No: its Order Form GRPID
		SELECT grpid FROM casupord WHERE UPPER(ALLTRIM(ol_no)) == lcKey AND grpid > 0 INTO ARRAY laG
		IF _TALLY > 0
			SELECT wbk
			LOCATE FOR grpid = laG[1]
			llF = FOUND()
		ENDIF
	ENDIF
	SELECT wbk
	IF llF
		THIS.ToScreen()
		THIS.SetMode("V")
		RETURN .T.
	ENDIF
	IF lnRec > 0 .AND. lnRec <= RECCOUNT()
		GO lnRec
	ENDIF
	THIS.Msg(lcKey + " not found in the bulk issues.", 48)
	RETURN .F.
	ENDFUNC

	*-----------------------------------------------------------------
	* ---------- validate, save, commit ----------
	* returns "" when ok, else the text of the first problem
	FUNCTION Validate
	LOCAL lnGrp, lcQ, lcC, lnQty, ldDate, lcAnsi, lnAllowed, laD[1], lcMy
	lnGrp = THIS.txtGrp.Value
	lcQ = ALLTRIM(THIS.txtQlty.Value)
	lcC = ALLTRIM(THIS.txtColour.Value)
	lnQty = THIS.txtQty.Value
	ldDate = THIS.txtDate.Value
	IF lnGrp <= 0
		RETURN "Order GRPID must be entered (use [Groups...] to pick one)."
	ENDIF
	IF THIS.LoadGroup(lnGrp) = 0 .OR. EMPTY(THIS.cSupplier)
		RETURN "GRPID " + ALLTRIM(STR(lnGrp)) + " has no OL in the order file (Casupord / Cabuyord)."
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
	lcMy = IIF(THIS.cMode == "E", THIS.cBulk, "#none#")
	SELECT COUNT(*) FROM wbk ;
		WHERE grpid = lnGrp AND ALLTRIM(quality) == lcQ AND ALLTRIM(colour) == lcC ;
		AND date = ldDate AND UPPER(optionbl) == UPPER(ALLTRIM(THIS.txtBL.Value)) AND !(ALLTRIM(bulkid) == lcMy) ;
		INTO ARRAY laD
	IF laD[1] > 0
		RETURN "Same GRPID, quality, colour, date and Ball/Lachhi is already entered."
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
	llOk = THIS.Guarded("SAVE")
	IF llOk
		THIS.ToScreen()
		THIS.SetMode("V")
	ENDIF
	RETURN llOk
	ENDFUNC

	* Commit: divide the saved line over the OLs of its GRPID and write them into Wiissue
	FUNCTION CommitEntry
	LOCAL lnN, lnTot, lnPrn, llOk, lnSum
	IF THIS.cMode $ "AE"
		IF !THIS.SaveEntry()
			RETURN .F.
		ENDIF
	ENDIF
	SELECT wbk
	IF EOF() .OR. RECCOUNT() = 0 .OR. EMPTY(THIS.cBulk)
		THIS.Msg("Nothing to commit: Save an entry first.", 48)
		RETURN .F.
	ENDIF
	lnN = THIS.GroupInfo(THIS.cBulk, @lnTot, @lnPrn)
	IF lnPrn > 0
		THIS.Msg("Cannot commit again: the bill/slip of this issue is already printed.", 48)
		RETURN .F.
	ENDIF
	IF THIS.StatusOf() == "COMMITTED"
		THIS.Msg("Already committed and up to date.", 64)
		RETURN .F.
	ENDIF
	IF THIS.LoadGroup(wbk.grpid) = 0
		THIS.Msg("GRPID " + ALLTRIM(STR(wbk.grpid)) + " has no OL in the order file any more.", 48)
		RETURN .F.
	ENDIF
	THIS.SetShares(wbk.quantity)
	SELECT cWbSib
	CALCULATE SUM(share) TO lnSum
	IF lnSum <= 0
		THIS.Msg("Nothing to divide: the OLs of the GRPID have no SqMt / quantity.", 48)
		RETURN .F.
	ENDIF
	IF THIS.Msg("Send " + ALLTRIM(STR(wbk.quantity, 12, 3)) + " kg divided by SqMt over " + ALLTRIM(STR(THIS.nNol)) + ;
			" OL of GRPID " + ALLTRIM(STR(wbk.grpid)) + " to Wiissue?", 36) # 6
		RETURN .F.
	ENDIF
	llOk = THIS.Guarded("COMMIT")
	IF llOk
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
	DO CASE
	CASE tcWhat == "SAVE"
		THIS.WriteLine()
	CASE tcWhat == "COMMIT"
		THIS.WriteRows()
	CASE tcWhat == "DELETE"
		THIS.DropLine()
	ENDCASE
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
	LOCAL loB, lcId
	SELECT wbk
	IF THIS.cMode == "A"
		lcId = THIS.NewBulkId()
		APPEND BLANK
		SCATTER NAME loB
		loB.bulkid = lcId
		loB.entryby = IIF(TYPE("pname") = "C", pname, "")
		loB.datetime = DATETIME()
	ELSE
		SCATTER NAME loB
	ENDIF
	loB.grpid = THIS.txtGrp.Value
	loB.party = THIS.cSupplier
	loB.po_no = THIS.cPoNo
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
	THIS.cBulk = ALLTRIM(loB.bulkid)
	ENDPROC

	* the divided rows (WIISSUE): rows already in the line are updated, rows whose OL
	* left the GRPID are deleted, new OLs are added.  cWbSib holds the shares.
	PROCEDURE WriteRows
	LOCAL loR, lnI, lcF, lcB
	SELECT wbk
	REPLACE totsqmt WITH THIS.nTotSq, nol WITH THIS.nNol
	lcB = ALLTRIM(wbk.bulkid)
	* the fields every row takes from the bulk line
	SELECT wi_w
	SCATTER NAME loR BLANK
	FOR lnI = 1 TO FCOUNT("wi_w")
		lcF = FIELD(lnI, "wi_w")
		IF !INLIST(lcF, "GRPID", "OL_NO", "CARD_NO", "WEAVER", "PO_NO", "QUANTITY", "AMT") .AND. TYPE("wbk." + lcF) # "U"
			loR.&lcF = EVALUATE("wbk." + lcF)
		ENDIF
	ENDFOR
	loR.grpid = lcB
	SELECT wi_w
	SCAN FOR EMPTY(pcWbErr) .AND. grpid = lcB
		SELECT cWbSib
		LOCATE FOR ALLTRIM(ol_no) == ALLTRIM(wi_w.ol_no) .AND. !taken .AND. share > 0
		IF FOUND()
			REPLACE taken WITH .T.
			THIS.RowFromShare(loR)
			SELECT wi_w
			GATHER NAME loR
		ELSE
			SELECT wi_w
			DELETE
		ENDIF
		SELECT wi_w
	ENDSCAN
	SELECT cWbSib
	SCAN FOR EMPTY(pcWbErr) .AND. !taken .AND. share > 0
		THIS.RowFromShare(loR)
		SELECT wi_w
		APPEND BLANK
		GATHER NAME loR
		SELECT cWbSib
	ENDSCAN
	ENDPROC

	* the OL part of a Wiissue row, from the current cWbSib record
	PROCEDURE RowFromShare
	LPARAMETERS loR
	loR.ol_no = cWbSib.ol_no
	loR.card_no = cWbSib.card_no
	loR.weaver = cWbSib.weaver
	loR.po_no = cWbSib.po_no
	loR.quantity = cWbSib.share
	loR.amt = ROUND(loR.rate * cWbSib.share, 2)
	ENDPROC

	* Delete: the bulk line and its Wiissue rows
	PROCEDURE DropLine
	LOCAL lcB
	lcB = THIS.cBulk
	SELECT wi_w
	DELETE FOR grpid = lcB .AND. !EMPTY(lcB)
	SELECT wbk
	DELETE
	ENDPROC

	FUNCTION NewBulkId
	LOCAL lcId, laC[1]
	DO WHILE .T.
		lcId = SUBSTR(DTOS(DATE()), 3) + STRTRAN(TIME(), ":", "") + PADL(INT(RAND() * 1000), 3, "0")
		SELECT COUNT(*) FROM wbk WHERE bulkid = lcId INTO ARRAY laC
		IF laC[1] = 0
			EXIT
		ENDIF
	ENDDO
	RETURN lcId
	ENDFUNC

ENDDEFINE


*---------------------------------------------------------------------
* [Groups...]  list of Order Form GRPIDs (from Casupord, as orderformview shows them)
DEFINE CLASS frmWbPick AS Form
	Caption = "Order Form GRPID - pick one"
	Height = 420
	Width = 780
	AutoCenter = .T.
	DataSession = 2
	BorderStyle = 2
	MaxButton = .F.
	MinButton = .F.
	WindowType = 1
	nPick = 0

	PROCEDURE Init
	SET TALK OFF
	SET DATE TO BRITISH
	SET CENTURY ON
	SET DELETED ON
	IF !DBUSED("carpet")
		OPEN DATABASE carpet SHARED
	ENDIF
	SET DATABASE TO carpet
	SELECT s.grpid, MAX(s.issdt) AS issdt, MAX(s.supplier) AS supplier, MAX(b.design) AS design, ;
		MAX(b.colour) AS colour, MAX(b.quality) AS quality, COUNT(*) AS nol, SUM(b.sqmt) AS sqmt ;
		FROM casupord s, cabuyord b ;
		WHERE b.ol_no = s.ol_no AND s.grpid > 0 ;
		GROUP BY s.grpid ;
		ORDER BY 1 DESC ;
		INTO CURSOR cWbGrp
	THIS.AddObject("grd", "Grid")
	WITH THIS.grd
		.Left = 10
		.Top = 10
		.Width = 760
		.Height = 350
		.FontName = "Arial"
		.FontSize = 9
		.ReadOnly = .T.
		.DeleteMark = .F.
		.RecordSource = "cWbGrp"
		.Visible = .T.
	ENDWITH
	THIS.AddObject("cmdOk", "wbPickBtn")
	WITH THIS.cmdOk
		.Caption = "OK"
		.Left = 560
		.Top = 372
		.Default = .T.
		.Visible = .T.
	ENDWITH
	THIS.AddObject("cmdCancel", "wbPickBtn")
	WITH THIS.cmdCancel
		.Caption = "Cancel"
		.Left = 670
		.Top = 372
		.Cancel = .T.
		.Visible = .T.
	ENDWITH
	ENDPROC

	PROCEDURE Done
	LPARAMETERS tlOk
	THIS.nPick = IIF(tlOk .AND. !EOF("cWbGrp"), cWbGrp.grpid, 0)
	THIS.Hide()
	ENDPROC
ENDDEFINE

DEFINE CLASS wbPickBtn AS CommandButton
	FontName = "Arial"
	FontSize = 10
	FontBold = .T.
	Height = 32
	Width = 100
	PROCEDURE Click
		THISFORM.Done(THIS.Name == "cmdOk")
	ENDPROC
ENDDEFINE
