*=====================================================================
* wiissue_bulk_create.prg   -   ONE-TIME: create the table WIISSUE_BULK in carpet.dbc
*
* WIISSUE_BULK holds ONE line per bulk yarn issue (the total, e.g. 50 kg).  The form
* wibulk.prg divides each line over the OLs of its Order Form by SqMt and writes the
* divided rows into WIISSUE with the same GRPID.
*
* Same fields as WIISSUE (+ GRPID, already added to WIISSUE by wiissue_addgrp.prg) and
*   TOTSQMT  total SqMt of the Order Form OLs   (from Cabuyord.Sqmt)
*   NOL      number of OLs (carpets) in the Order Form (from Casupord / Cabuyord)
*
* HOW TO RUN: all users out of the program, then in the VFP command window:
*       DO wiissue_bulk_create
* Safe to run again: does nothing if the table already exists.
*=====================================================================
LOCAL lcSafety, lcExcl, llOk
lcSafety = SET("SAFETY")
lcExcl = SET("EXCLUSIVE")
SET SAFETY OFF
SET EXCLUSIVE ON
llOk = .T.
OPEN DATABASE carpet EXCLUSIVE
IF !DBUSED("carpet")
	=MESSAGEBOX("Cannot open database CARPET exclusively. Close the program on all computers and try again.", 16, "Wiissue_bulk")
	llOk = .F.
ENDIF
IF llOk
	IF INDBC("wiissue_bulk", "TABLE")
		WAIT WINDOW "Wiissue_bulk already exists - nothing to do." TIMEOUT 3
	ELSE
		USE wiissue IN 0 SHARED ALIAS wi_chk
		llOk = (TYPE("wi_chk.grpid") # "U")
		USE IN wi_chk
		IF !llOk
			=MESSAGEBOX("Run  DO wiissue_addgrp  first (Wiissue has no GRPID column).", 16, "Wiissue_bulk")
		ELSE
			CREATE TABLE wiissue_bulk ( ;
				grpid C(15), party C(20), quality C(10), ytype C(6),colour C(10), date D, quantity N(11,3), billno C(8), rate N(8,2), ;
				amt N(12,2), comment C(25), optionbl C(1) DEFAULT "L", po_no C(15), slipno C(5), ;
				dyewht C(1), datetime T DEFAULT DATETIME(), entryby C(10) DEFAULT pname,  ;
				totsqmt N(9,2), nol N(3))
			INDEX ON ol_no TAG ol_no
			INDEX ON grpid TAG grpid
			INDEX ON billno TAG billno
			INDEX ON date TAG date
			USE
			WAIT WINDOW "Wiissue_bulk created (same fields as Wiissue + TOTSQMT, NOL)." TIMEOUT 3
		ENDIF
	ENDIF
ENDIF
CLOSE DATABASES
SET EXCLUSIVE &lcExcl
SET SAFETY &lcSafety
RETURN
