*=====================================================================
* wiissue_bulk_create.prg   -   ONE-TIME: create the table WIISSUE_BULK in carpet.dbc
*
* WIISSUE_BULK holds ONE line per bulk yarn issue (the total, e.g. 50 kg) to the OLs of
* one Order Form.  The Order Form is Casupord.GRPID (set by "GrpID Update" on rordform).
* The form wibulk.prg divides each line over the OLs of that GRPID by SqMt and writes the
* divided rows into WIISSUE.
*
*   GRPID    Order Form group, same value as Casupord.GRPID  (N 6)
*   BULKID   id of this bulk line; the divided Wiissue rows carry it in Wiissue.GRPID
*   TOTSQMT  total SqMt of the OLs of the GRPID   (from Cabuyord.Sqmt)
*   NOL      number of OLs of the GRPID
*   the other fields are the same as in WIISSUE
*
* HOW TO RUN: all users out of the program, then in the VFP command window:
*       DO wiissue_bulk_create
* Safe to run again: does nothing if the table already has this structure.  An EMPTY
* table of the old (OL No based) structure is dropped and created again.
*=====================================================================
LOCAL lcSafety, lcExcl, llOk, llMake, lnRecs, llOld
lcSafety = SET("SAFETY")
lcExcl = SET("EXCLUSIVE")
SET SAFETY OFF
SET EXCLUSIVE ON
llOk = .T.
llMake = .F.
IF TYPE("pname") # "C"
	PUBLIC pname
	pname = ""
ENDIF
OPEN DATABASE carpet EXCLUSIVE
IF !DBUSED("carpet")
	=MESSAGEBOX("Cannot open database CARPET exclusively. Close the program on all computers and try again.", 16, "Wiissue_bulk")
	llOk = .F.
ENDIF
IF llOk
	IF INDBC("wiissue_bulk", "TABLE")
		USE wiissue_bulk IN 0 EXCLUSIVE ALIAS wb_chk
		llOld = (TYPE("wb_chk.bulkid") = "U")
		lnRecs = RECCOUNT("wb_chk")
		USE IN wb_chk
		DO CASE
		CASE !llOld
			WAIT WINDOW "Wiissue_bulk already exists - nothing to do." TIMEOUT 3
		CASE lnRecs = 0
			DROP TABLE wiissue_bulk
			llMake = .T.
		OTHERWISE
			=MESSAGEBOX("Wiissue_bulk has the old structure and " + ALLTRIM(STR(lnRecs)) + " records." + CHR(13) + ;
				"It was not changed.  Copy the records out, delete them, and run this again.", 16, "Wiissue_bulk")
		ENDCASE
	ELSE
		llMake = .T.
	ENDIF
ENDIF
IF llMake
	USE wiissue IN 0 SHARED ALIAS wi_chk
	llOk = (TYPE("wi_chk.grpid") # "U")
	USE IN wi_chk
	IF !llOk
		=MESSAGEBOX("Run  DO wiissue_addgrp  first (Wiissue has no GRPID column).", 16, "Wiissue_bulk")
	ELSE
		CREATE TABLE wiissue_bulk ( ;
			grpid N(6), bulkid C(15), party C(20), quality C(10), ytype C(6), colour C(10), ;
			date D, quantity N(11,3), billno C(8), rate N(8,2), amt N(12,2), comment C(25), ;
			optionbl C(1) DEFAULT "L", po_no C(15), slipno C(5), dyewht C(1), ;
			datetime T DEFAULT DATETIME(), entryby C(10), totsqmt N(9,2), nol N(3))
		INDEX ON grpid TAG grpid
		INDEX ON bulkid TAG bulkid
		INDEX ON billno TAG billno
		INDEX ON date TAG date
		USE
		WAIT WINDOW "Wiissue_bulk created (GRPID = Casupord.GRPID, BULKID = line id)." TIMEOUT 3
	ENDIF
ENDIF
CLOSE DATABASES
SET EXCLUSIVE &lcExcl
SET SAFETY &lcSafety
RETURN
