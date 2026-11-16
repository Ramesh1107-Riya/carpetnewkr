*=====================================================================
* wiissue_addbulkid.prg   -   ONE-TIME schema change (run once on the live data)
*
* Adds Wiissue.BULKID (C15 + index tag) for the Bulk Issue form (wibulk.prg).
* From now on Commit writes:
*     Wiissue.GRPID  = the Order Form GRPID      (e.g. "1002")
*     Wiissue.BULKID = the bulk line's BULKID   (Wiissue_bulk.BULKID)
*
* Rows committed before this change carry the BULKID in Wiissue.GRPID.  They are
* converted here: BULKID moves to the new column and GRPID gets the Order Form
* GRPID of that bulk line.  Other rows are not touched.
*
* HOW TO RUN:  every user must be out of the program (needs exclusive use).
*   In the VFP command window, from the program folder:   DO wiissue_addbulkid
* It is safe to run again: the column is added once, and the conversion only
* finds rows that still have a BULKID in GRPID.
*=====================================================================
LOCAL lcSafety, lcExcl, lcDele, llOk, lnConv
lcSafety = SET("SAFETY")
lcExcl   = SET("EXCLUSIVE")
lcDele   = SET("DELETED")
SET SAFETY OFF
SET EXCLUSIVE ON
SET DELETED ON
llOk = .T.
lnConv = 0

OPEN DATABASE carpet EXCLUSIVE
IF !DBUSED("carpet")
	=MESSAGEBOX("Cannot open database CARPET exclusively. Close the program on all computers and try again.", 16, "Wiissue BULKID")
	llOk = .F.
ENDIF

IF llOk
	USE wiissue EXCLUSIVE IN 0 ALIAS wiissue_mig
	SELECT wiissue_mig
	IF TYPE("grpid") = "U"
		=MESSAGEBOX("Wiissue has no GRPID column. Run  DO wiissue_addgrp  first.", 16, "Wiissue BULKID")
		llOk = .F.
	ENDIF
ENDIF

IF llOk
	IF TYPE("wiissue_mig.bulkid") = "U"
		ALTER TABLE wiissue_mig ADD COLUMN bulkid C(15)
		INDEX ON bulkid TAG bulkid
	ENDIF
	* rows committed the old way: GRPID holds a BULKID of Wiissue_bulk
	IF INDBC("wiissue_bulk", "TABLE")
		USE wiissue_bulk IN 0 ALIAS wbk_mig
		SELECT wbk_mig
		SCAN
			SELECT wiissue_mig
			REPLACE bulkid WITH wbk_mig.bulkid, grpid WITH ALLTRIM(STR(wbk_mig.grpid)) ;
				FOR !EMPTY(wbk_mig.bulkid) .AND. ALLTRIM(grpid) == ALLTRIM(wbk_mig.bulkid)
			lnConv = lnConv + _TALLY
			SELECT wbk_mig
		ENDSCAN
		USE IN wbk_mig
	ENDIF
	=MESSAGEBOX("Wiissue.BULKID is ready." + CHR(13) + ;
		"Rows converted (BULKID moved out of GRPID): " + ALLTRIM(STR(lnConv)), 64, "Wiissue BULKID")
ENDIF

IF USED("wiissue_mig")
	USE IN wiissue_mig
ENDIF
CLOSE DATABASES

SET DELETED &lcDele
SET EXCLUSIVE &lcExcl
SET SAFETY &lcSafety
RETURN
