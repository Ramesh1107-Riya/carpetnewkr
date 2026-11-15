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
		* a wiissue_bulk.dbf left on disk that the database does not list: erase it if empty
		lnRecs = OrphanRecs("wiissue_bulk.dbf")
		DO CASE
		CASE lnRecs < 0
			llMake = .T.
		CASE lnRecs = 0
			ERASE wiissue_bulk.dbf
			ERASE wiissue_bulk.cdx
			ERASE wiissue_bulk.fpt
			llMake = !FILE("wiissue_bulk.dbf")
			IF !llMake
				=MESSAGEBOX("Cannot erase the old empty wiissue_bulk.dbf (in use?).", 16, "Wiissue_bulk")
			ENDIF
		OTHERWISE
			=MESSAGEBOX("wiissue_bulk.dbf is on disk with " + ALLTRIM(STR(lnRecs)) + " records but is not in the database." + CHR(13) + ;
				"It was not changed.  Rename or move it, and run this again.", 16, "Wiissue_bulk")
		ENDCASE
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

* record count of a DBF file read from its header (-1 = no such file)
FUNCTION OrphanRecs
LPARAMETERS tcFile
LOCAL lnH, lcHdr
IF !FILE(tcFile)
	RETURN -1
ENDIF
lnH = FOPEN(tcFile)
IF lnH < 0
	RETURN 1
ENDIF
lcHdr = FREAD(lnH, 8)
=FCLOSE(lnH)
RETURN ASC(SUBSTR(lcHdr, 5, 1)) + 256 * ASC(SUBSTR(lcHdr, 6, 1)) + 65536 * ASC(SUBSTR(lcHdr, 7, 1)) + 16777216 * ASC(SUBSTR(lcHdr, 8, 1))
ENDFUNC
