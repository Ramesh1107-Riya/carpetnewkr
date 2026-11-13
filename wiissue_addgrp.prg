*=====================================================================
* wiissue_addgrp.prg   -   ONE-TIME schema change (run once on the live data)
*
* Adds Wiissue.GRPID (+ index tag) used by the "split issue by SqMt" feature
* in the Issue Dyed Yarn to SUPPLIER form (wiissue.scx / abtool.prg WiXxx).
* Rows saved by one split entry share the same GRPID; old rows stay blank.
*
* HOW TO RUN:  every user must be out of the program (needs exclusive use).
*   In the VFP command window, from the program folder:   DO wiissue_addgrp
* It is safe to run again - it does nothing if GRPID already exists.
*=====================================================================
LOCAL lcSafety, lcExcl, llOk
lcSafety = SET("SAFETY")
lcExcl   = SET("EXCLUSIVE")
SET SAFETY OFF
SET EXCLUSIVE ON
llOk = .T.

OPEN DATABASE carpet EXCLUSIVE
IF !DBUSED("carpet")
	=MESSAGEBOX("Cannot open database CARPET exclusively. Close the program on all computers and try again.", 16, "Wiissue GRPID")
	llOk = .F.
ENDIF

IF llOk
	USE wiissue EXCLUSIVE IN 0 ALIAS wiissue_mig
	SELECT wiissue_mig
	IF TYPE("grpid") # "U"
		WAIT WINDOW "Wiissue.GRPID already exists - nothing to do." TIMEOUT 3
	ELSE
		ALTER TABLE wiissue_mig ADD COLUMN grpid C(15)
		INDEX ON grpid TAG grpid
		WAIT WINDOW "Wiissue.GRPID added (C15, index tag GRPID)." TIMEOUT 3
	ENDIF
	USE IN wiissue_mig
	CLOSE DATABASES
ENDIF

SET EXCLUSIVE &lcExcl
SET SAFETY &lcSafety
RETURN
