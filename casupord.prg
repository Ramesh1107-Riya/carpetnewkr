* Bof()                         CaSupOrd.PRG
*
* Procedure to Place Order to Supplier/Branch/Loom !!
SET PROCEDURE TO Catool

PROCEDURE CaSupOrd
m.FileLocked = .F.
* Open Main Files.
USE CARPET    IN SELECT(1)  ORDER TAG OL_NUMBER  ALIAS Carpet
* Other auxiliary files for Input help!
USE CASUPPLR  IN SELECT(1)  ORDER TAG CODE       ALIAS Supplier
USE CADESIGN  IN SELECT(1)  ORDER TAG CODE       ALIAS Design
USE CACOLOUR  IN SELECT(1)  ORDER TAG CODE       ALIAS Colour
USE CAQLTY    IN SELECT(1)  ORDER TAG CODE       ALIAS Quality
USE CAFIELD   IN SELECT(1)  ORDER TAG FIELDCODE  ALIAS DgnField
USE CASIZE    IN SELECT(1)  ORDER TAG CODE       ALIAS SizeGroup
USE CASTATUS  IN SELECT(1)  ORDER TAG STAT_CODE  ALIAS Status
USE CABUYER   IN SELECT(1)  ORDER TAG CODE       ALIAS Buyer
USE CABUYORD  IN SELECT(1)  ORDER TAG USIKEY     ALIAS BuyerOrder
set procedure to catools
IF m.FileLocked
  DO CloseFile
  RETURN
ENDIF
*
SELECT Carpet
LOCATE FOR EMPTY(STATUS)
IF (.NOT. FOUND())
  DO CloseFile
  DO ShowMess WITH "NOT Distributed Orders Could not be Found !"
  RETURN
ENDIF
*
* First, offer normal Screen to User and ask which Order-List Number to
* Distribute. If user enters a valid OL-Number, its ok - so ask the
* rest information and save it.
* -> The other is, if user presses Hot-Key (F2), it will lead to Search
*    screen and show selected pieces - from there user could press Enter
*    to Distribute the piece.
*
PRIVATE m.CanFind1, m.CanFind2, m.CanFind3, m.CanFind4, m.CanFind5, ;
  m.tVar1, m.tVar2, m.tVar3, m.tVar4, m.tVar5, m.tVar6, m.tVar7, m.tVar8
PRIVATE m.DistOLNo, m.CardNo_, m.Supplier_, m.SupOrdNo_, m.WeaverNm_, ;
  m.LoomNo_, m.IssueDate_, m.LoomDate_, m.EstFinDt_, m.Status_, ;
  m.Comment_, m.USIKey_
PRIVATE m.GoToSearch
*
m.DistOLNo   = SPACE(LEN(OL_NUMBER))
m.CardNo_    = Control.CARD_NO + 1
m.Supplier_  = SPACE(LEN(SUPPLIER))
m.SupOrdNo_  = SPACE(LEN(SUPLRORDNO))
m.WeaverNm_  = SPACE(LEN(WEAVER))
m.LoomNo_    = SPACE(LEN(LOOMNO))
m.IssueDate_ = DATE()
m.LoomDate_  = CTOD("")
m.EstFinDt_  = CTOD("")
m.Status_    = SPACE(LEN(STATUS))
m.Comment_   = SPACE(LEN(COMMENT))
m.USIKey_    = SPACE(LEN(USIKEY))
*
PRIVATE m.soSpVr1, m.soSpVr2, m.soSpVr3
m.soSpVr1    = '[[ Select Right Order-List Number ]]'
m.soSpVr2    = 'Order-# Ord-Size  Design    Ctrl-#'
m.PrgTitle   = "Order Distribution to Suppliers/Branches"
m.CanFind1   = "ShowList(SYS(18), .F., 'Carpet', 'OL_NUMBER', 'OL_NUMBER', ;
  'OL_NUMBER', m.soSpVr1, 'OL_NUMBER', 'OL-Number', '@!', ;
  'xTmpFld_=LEFT(ORDERNO,7)+SPACE(1)+LEFT(SIZE,9)+SPACE(1)+LEFT(DESIGN,9)+SPACE(1)+CONTROLNO', ;
  m.soSpVr2, '@X')"
m.CanFind2   = SetCanFind(9, .F.)    && Suppliers/Branches!
m.CanFind2   = m.CanFind2 + " .AND. ShowSupCat(m.Supplier_, 11, 47, 10, 'm.WeaverNm_')"
m.GoToSearch = " "
*
*ACTIVATE WINDOW BigWin_ NOSHOW
@ 0,(WCOLS()-LEN(m.PrgTitle))/2 SAY m.PrgTitle
@ 1,0 TO 1,WCOLS() DOUBLE COLOR (m.Color10Line)
@ 2,0  CLEAR
@ 3,5   SAY "     OL-# to Distribute :"
*
@ 4,00  TO 4,WCOLS()
@ 10,00 TO 10,WCOLS()
@ 5,5   SAY "    P.O.-# :"
@ 6,5   SAY "Order Type :"
@ 7,5   SAY " Control-# :"
@ 8,5   SAY " Spcl-Inst.:"
@ 9,5   SAY " Wash-Inst.:"
@ 5,44  SAY "  Quality :"
@ 6,44  SAY "   Design :"
@ 7,44  SAY "Ord.-Size :"
@ 8,44  SAY "    Field :"
@ 9,44  SAY "   Colour :"
*
@ 11,5  SAY " Distribute to Supplier :"
@ 12,5  SAY "        As Order Number :"
@ 13,5  SAY "            Weaver Name :"
@ 14,5  SAY "            Card Number :"
@ 15,5  SAY "            Loom Number :"
@ 16,5  SAY " Issue Date to Supplier :"
@ 17,5  SAY "              Loom Date :"
@ 18,5  SAY "  Estimated Finish Date :"
@ 19,5  SAY "  Comment for the Piece :"
*SHOW WINDOW BigWin_
*
DO WHILE .T.
  UNLOCK ALL

    DO csoSrNDst_
    LOOP
  *
  SELECT Carpet
  SEEK m.DistOLNo
  IF (.NOT. FOUND())
    ?? CHR(7)
    WAIT WINDOW "Invalid Order-List Number !" NOWAIT
    LOOP
  ENDIF
  IF (.NOT. EMPTY(STATUS))
    ?? CHR(7)
    = SEEK(STATUS, "Status")
    DO ShowMess WITH "This is a [" + ALLTRIM(Status.DESC) + "] Piece !", ;
      "You should Select a NOT Distributed Piece for Distribution !"
    LOOP
  ENDIF
  IF (.NOT. FileLock("Carpet", "Control"))
    ?? CHR(7)
    WAIT WINDOW "File could not be locked now ... Try later" NOWAIT
    LOOP
  ENDIF
  m.Comment_   = COMMENT
  m.USIKey_    = USIKEY
  *
  * Now show the information on screen and ask necessary inputs.
  *
  = SEEK(m.USIKey_, "BuyerOrder")
  = SEEK(FIELD, "DgnField")
  = SEEK(COLOUR, "Colour")
  @ 5,18  SAY ORDERNO COLOR SCHEME 5
  @ 5,27  SAY "of " + DTOC(BuyerOrder.ORDERDATE)
  @ 6,18  SAY LEFT(RetOrdType(BuyerOrder.ORDERTYPE), 24) COLOR SCHEME 5
  @ 7,18  SAY LEFT(CONTROLNO, 24) COLOR SCHEME 5
  @ 8,18  SAY LEFT(SPCL_INST, 24) COLOR SCHEME 5
  @ 9,18  SAY LEFT(WASH_INST, 24) COLOR SCHEME 5
  @ 5,56  SAY LEFT(QUALITY, 20) COLOR SCHEME 5
  @ 6,56  SAY LEFT(DESIGN, 20) COLOR SCHEME 5
  @ 7,56  SAY LEFT(SIZE, 9) COLOR SCHEME 5
  @ 7,66  SAY LEFT(RetCrpType(CARPETTYPE), 10) COLOR SCHEME 5
  @ 8,56  SAY LEFT(FIELD + ": " + DgnField.DESC, 20) COLOR SCHEME 5
  @ 9,56  SAY LEFT(COLOUR + ": " + Colour.DESC, 20) COLOR SCHEME 5
  *
  @ 11,31 GET m.Supplier_ PICTURE "@!" MESSAGE "Enter Supplier to whom it is Distributed" ;
    VALID &CanFind2 ERROR "Invalid Supplier ID !"
  @ 12,31 GET m.SupOrdNo_ PICTURE "@!" MESSAGE "Order Number for Supplier" ;
    VALID AllowMove() .OR. (.NOT. EMPTY(m.SupOrdNo_)) ERROR ;
    "Please Enter Order Number for Supplier !"
  @ 13,31 GET m.WeaverNm_ PICTURE "@X" MESSAGE "Weaver Name  (You Must Enter if its an Internal Order)" ;
    VALID csoWvrNmCh(m.Supplier_) ERROR "Please Enter Weaver Name !"
  @ 14,31 GET m.CardNo_ PICTURE "9999999" MESSAGE "Card Number - Leave Empty to Fill later" ;
    VALID csoCrdNrCh(m.CardNo_) ERROR "Invalid Card Number !"
  @ 15,31 GET m.LoomNo_ PICTURE "@!" MESSAGE "Loom Number, for Record Purpose"
  @ 16,31 GET m.IssueDate_ MESSAGE "Issue Date of the Piece to Supplier" ;
    VALID cSamIssDChk(m.IssueDate_, m.USIKey_) ERROR "Invalid Issue Date !"
  @ 17,31 GET m.LoomDate_ MESSAGE "Loom Date of the Piece" VALID ;
    cSamOLmDChk(m.LoomDate_, m.USIKey_, m.IssueDate_, .T.) ERROR ;
    "Leave EMPTY - OR Enter Valid Loom Date !"
  @ 18,31 GET m.EstFinDt_ MESSAGE "Estimated Finish Date of Carpet from Loom/Supplier" ;
    VALID cSamEFnDChk(m.EstFinDt_, m.USIKey_, m.IssueDate_) ERROR ;
    "Invalid Estimated-Finish-Date !"
  @ 19,31 GET m.Comment_ MESSAGE "Comment for the Piece, if any"
  @ 14,40 SAY LEFT("(Last: " + ALLTRIM(STR(Control.CARD_NO)) + ")" + SPACE(15), 15)
  READ VALID ReadExit() .AND. EnterF12() TIMEOUT m.InReadWait
  IF LASTKEY() = 27 .OR. READKEY() = 20 .OR. READKEY() = 276
    WAIT CLEAR
    LOOP
  ENDIF
  *
  * Now final confirmation for Saving the Record !
  *
  IF YesNo("Confirm to Distribute OL-# " + ALLTRIM(m.DistOLNo) + " to " + ;
    ALLTRIM(m.Supplier_), " ", "", 1)
    SELECT Carpet
    SEEK m.DistOLNo
    REPLACE SUPPLIER WITH m.Supplier_, SUPLRORDNO WITH m.SupOrdNo_, ;
      WEAVER WITH m.WeaverNm_, CARD_NO WITH m.CardNo_, LOOMNO WITH ;
      m.LoomNo_, ISSUEDATE WITH m.IssueDate_, LOOMDATE WITH m.LoomDate_, ;
      ESTFINDATE WITH m.EstFinDt_, STATUS WITH "OL", COMMENT WITH m.Comment_
    IF Control.CARD_NO < m.CardNo_
      SELECT Control
      REPLACE CARD_NO  WITH m.CardNo_
    ENDIF
    DO UpdateTA WITH "Single Piece of OL-# " + ALLTRIM(m.DistOLNo) + ;
      " Distributed to Supplier " + ALLTRIM(m.Supplier_)
    SELECT Carpet
    FLUSH
    ?? CHR(7)
    WAIT WINDOW "OL-# " + ALLTRIM(m.DistOLNo) + " Distributed to " + ;
      ALLTRIM(m.Supplier_) + " !" NOWAIT
  ENDIF
ENDDO
*
DEACTIVATE WINDOW BigWin_
DO CloseFile
RETURN

* Eof()



* Help Procedure to allow to User to Select Carpets by Criteria and then to
* Mark and Distribute to one Supplier.

PROCEDURE csoSrNDst_
PRIVATE m.csVar1, m.csVar2, m.csVar3, m.csVar4, m.csVar5, m.csVar6, ;
  m.csVar7, m.csVar8, m.csVar9, m.csTmpLCard
IF csCarpSrch("  ") <= 0    && It locks the "Carpet" file too!
  WAIT CLEAR
  RETURN
ENDIF
* Now Display ALL the Found Records and allow the user to Mark them for
* Distribution !
DEFINE WINDOW csoSrchWn_ FROM 08,00 TO 23,79 IN SCREEN DOUBLE NOCLOSE ;
  NOFLOAT NOGROW NOZOOM TITLE "[ NOT Distributed Pieces Searching by Criteria ]" ;
  COLOR SCHEME 10
?? CHR(7)
DO MessDisplay WITH "Mark for Distribution with [Y] - and press [F10] when Done     [ESC]= Exit"
WAIT WINDOW ALLTRIM(STR(RECCOUNT("csCarpetCr"))) + " Matching Pieces Found !" NOWAIT
SELECT csCarpetCr
REPLACE ALL LABEL      WITH .F.
GO TOP
m.csVar9  = ON("KEY", "F10")
ON KEY LABEL F10     KEYBOARD CHR(23)
BROWSE FIELDS LABEL:H="Dist.?":P="Y", OL_NUMBER:H="OL-Number":10:R, ;
  CARD_NO:P="9999999":H="Card-#":R, ORDERNO:H="P.O.-#":R, CONTROLNO:H="Control-#":9:R, ;
  DESIGN:H="Design":8:R, QUALITY:H="Quality":8:R, SIZE:H="Ord-Size":R, ;
  COLOUR:H="Clr.":4:R, FIELD:H="Fld":3:R, BrwCType_=RetCrpType(CARPETTYPE):H="C.Type":6:R, ;
  COMMENT:R REST FREEZE LABEL NOAPPEND NODELETE NOMENU TIMEOUT m.InBrowWait ;
  TITLE "[[ NOT Distributed Pieces Searched by Criteria ]]" WINDOW ;
  csoSrchWn_ COLOR SCHEME 10
m.csVar1  = LASTKEY()
ON KEY LABEL F10   &csVar9
IF m.csVar1 = 23     && F10 Pressed: ask other Inputs to Record !
  COUNT TO m.csVar1  FOR LABEL
  IF m.csVar1 <= 0
    ?? CHR(7)
    WAIT WINDOW "No Pieces Marked for Distribution !!" TIMEOUT 2
    USE IN csCarpetCr
    SELECT Carpet
    UNLOCK ALL
    RELEASE WINDOW csoSrchWn_
    RETURN
  ENDIF
  * Now ask the necessary Infos. for the Marked Pieces and Save them!
  * -> We should ask the informations one by one for all the pieces
  m.csVar2  = ALLTRIM(STR(m.csVar1)) + " Pieces Marked for Distribution"
  RELEASE WINDOW csoSrchWn_
  DEFINE WINDOW csoSrchWn_ FROM 02,00 TO 23,79 IN SCREEN DOUBLE NOCLOSE ;
    NOFLOAT NOGROW NOZOOM TITLE "[ " + m.csVar2 + " ]" COLOR SCHEME 10
  ACTIVATE WINDOW csoSrchWn_ TOP
  @ 0,05  SAY "You should fill Information for each of the Selected Pieces!"
  @ 1,05  SAY "Press Page-Down if everything is OK - or Page-Up to Edit Previous !"
  @ 0,00  FILL TO 1,WCOLS() COLOR SCHEME 5
  @ 3,5   SAY "       for Order-List-# :"
  @ 4,00  TO 4,WCOLS()
  @ 10,00 TO 10,WCOLS()
  @ 5,5   SAY "    P.O.-# :"
  @ 6,5   SAY "Order Type :"
  @ 7,5   SAY " Control-# :"
  @ 8,5   SAY " Spcl-Inst.:"
  @ 9,5   SAY " Wash-Inst.:"
  @ 5,44  SAY "  Quality :"
  @ 6,44  SAY "   Design :"
  @ 7,44  SAY "Ord.-Size :"
  @ 8,44  SAY "    Field :"
  @ 9,44  SAY "   Colour :"
  @ 11,5  SAY " Distribute to Supplier :"
  @ 12,5  SAY "        As Order Number :"
  @ 13,5  SAY "            Weaver Name :"
  @ 14,5  SAY "            Card Number :"
  @ 15,5  SAY "            Loom Number :"
  @ 16,5  SAY " Issue Date to Supplier :"
  @ 17,5  SAY "              Loom Date :"
  @ 18,5  SAY "  Estimated Finish Date :"
  @ 19,5  SAY "  Comment for the Piece :"
  * -> for these Information entry, take advantage of the "Main" Program's
  *    variables !!!
  SELECT csCarpetCr
  SET FILTER TO LABEL
  GO TOP
  m.csVar2  = 1      && Increasing Serial Number (Record-#) to Display!
  m.csVar3  = .T.
  m.csTmpLCard = Control.CARD_NO
  m.on140600V1 = -9999.99
  *
  DO WHILE .T.
    SELECT csCarpetCr
    m.Comment_   = COMMENT      && Actual Comment of the Piece!
    m.USIKey_    = USIKEY
    @ 3,31  SAY OL_NUMBER PICTURE "@!" COLOR G+/GR
    @ 11,62 SAY LEFT(ALLTRIM(STR(m.csVar2)) + " of " + ALLTRIM(STR(m.csVar1)) + SPACE(12), 12) COLOR SCHEME 5
    *
    = SEEK(m.USIKey_, "BuyerOrder")
    = SEEK(FIELD, "DgnField")
    = SEEK(COLOUR, "Colour")
    @ 5,18  SAY LEFT(ORDERNO, 24) COLOR SCHEME 5
    @ 5,27  SAY "of " + DTOC(BuyerOrder.ORDERDATE)
    @ 6,18  SAY LEFT(RetOrdType(BuyerOrder.ORDERTYPE), 24) COLOR SCHEME 5
    @ 7,18  SAY LEFT(CONTROLNO, 24) COLOR SCHEME 5
    @ 8,18  SAY LEFT(SPCL_INST, 24) COLOR SCHEME 5
    @ 9,18  SAY LEFT(WASH_INST, 24) COLOR SCHEME 5
    @ 5,56  SAY LEFT(QUALITY, 20) COLOR SCHEME 5
    @ 6,56  SAY LEFT(DESIGN, 20) COLOR SCHEME 5
    @ 7,56  SAY LEFT(SIZE, 9) COLOR SCHEME 5
    @ 7,66  SAY LEFT(RetCrpType(CARPETTYPE), 10) COLOR SCHEME 5
    @ 8,56  SAY LEFT(FIELD + ": " + DgnField.DESC, 20) COLOR SCHEME 5
    @ 9,56  SAY LEFT(COLOUR + ": " + Colour.DESC, 20) COLOR SCHEME 5
    *
    @ 11,31 GET m.Supplier_ PICTURE "@!" MESSAGE "Enter Supplier to whom it is Distributed" ;
      VALID LASTKEY() = 3 .OR. &CanFind2 ERROR "Invalid Supplier ID !"
    @ 12,31 GET m.SupOrdNo_ PICTURE "@!" MESSAGE "Order Number for Supplier" ;
      VALID AllowMove() .OR. (.NOT. EMPTY(m.SupOrdNo_)) ERROR ;
      "Please Enter Order Number for Supplier !"
    @ 13,31 GET m.WeaverNm_ PICTURE "@X" MESSAGE "Weaver Name  (You Must Enter if its an Internal Order)" ;
      VALID csoWvrNmCh(m.Supplier_) ERROR "Please Enter Weaver Name !"
    @ 14,31 GET m.CardNo_ PICTURE "9999999" MESSAGE "Card Number - Leave Empty to Fill later" ;
      VALID m.on140600V1 = m.CardNo_ .OR. csoCrdNrCh(m.CardNo_, .T.) ERROR "Invalid Card Number !"
    @ 15,31 GET m.LoomNo_ PICTURE "@!" MESSAGE "Loom Number, for Record Purpose"
    @ 16,31 GET m.IssueDate_ MESSAGE "Issue Date of the Piece to Supplier" ;
      VALID cSamIssDChk(m.IssueDate_, m.USIKey_) ERROR "Invalid Issue Date !"
    @ 17,31 GET m.LoomDate_ MESSAGE "Loom Date of the Piece" VALID ;
      cSamOLmDChk(m.LoomDate_, m.USIKey_, m.IssueDate_, .T.) ERROR ;
      "Leave EMPTY - OR Enter Valid Loom Date !"
    @ 18,31 GET m.EstFinDt_ MESSAGE "Estimated Finish Date of Carpet from Loom/Supplier" ;
      VALID cSamEFnDChk(m.EstFinDt_, m.USIKey_, m.IssueDate_) ERROR ;
      "Invalid Estimated-Finish-Date !"
    @ 19,31 GET m.Comment_ MESSAGE "Comment for the Piece, if any"
    @ 14,40 SAY LEFT("(Last: " + ALLTRIM(STR(m.csTmpLCard)) + ")" + SPACE(15), 15)
    * READ VALID ReadExit() .AND. EnterF12() TIMEOUT m.InReadWait
    READ
    IF LASTKEY() = 27 .OR. READKEY() = 20 .OR. READKEY() = 276
      WAIT CLEAR
      IF YesNo("You Pressed ESCape! It will cancel all the Changes!! OK", " ", "", 2)
        m.csVar3  = .F.
        EXIT
      ENDIF
      LOOP
    ENDIF
    IF LASTKEY() = 18     && Page-Up: Previous Record !
      IF (.NOT. BOF())
        SKIP -1
        IF BOF()
          GO TOP
        ELSE
          m.csVar2  = m.csVar2 - 1
        ENDIF
      ENDIF
      ?? CHR(7)
      m.csTmpLCard = CARD_NO
      WAIT WINDOW "Previous Record !" NOWAIT
      m.Supplier_   = SUPPLIER
      m.SupOrdNo_   = SUPLRORDNO
      m.WeaverNm_   = WEAVER
      m.CardNo_     = CARD_NO
      m.LoomNo_     = LOOMNO
      m.IssueDate_  = ISSUEDATE
      m.LoomDate_   = LOOMDATE
      m.EstFinDt_   = ESTFINDATE
      m.on140600V1  = CARD_NO
      LOOP
    ENDIF
    IF LASTKEY() = 3    && Page-Down: Next Record !!
      IF EMPTY(SUPPLIER) .OR. EMPTY(CARD_NO) .OR. STATUS # "OL"
        ?? CHR(7)
        WAIT WINDOW "Invalid Record Set ..." NOWAIT
        LOOP
      ENDIF
      SKIP
      m.csTmpLCard = CARD_NO
      m.csVar2  = m.csVar2 + 1
      IF EOF()
        = INKEY(0.5)
        EXIT
      ELSE
        m.Supplier_   = IIF(EMPTY(SUPPLIER), m.Supplier_, SUPPLIER)
        m.SupOrdNo_   = IIF(EMPTY(SUPLRORDNO), m.SupOrdNo_, SUPLRORDNO)
        m.WeaverNm_   = IIF(EMPTY(WEAVER), m.WeaverNm_, WEAVER)
        m.CardNo_     = IIF(EMPTY(CARD_NO), m.CardNo_, CARD_NO)
        m.LoomNo_     = IIF(EMPTY(LOOMNO), m.LoomNo_, LOOMNO)
        m.IssueDate_  = IIF(EMPTY(ISSUEDATE), m.IssueDate_, ISSUEDATE)
        m.LoomDate_   = IIF(EMPTY(LOOMDATE), m.LoomDate_, LOOMDATE)
        m.EstFinDt_   = IIF(EMPTY(ESTFINDATE), m.EstFinDt_, ESTFINDATE)
        m.on140600V1  = CARD_NO
        ?? CHR(7)
        WAIT WINDOW "Next Record ..." NOWAIT
        LOOP
      ENDIF
    ENDIF
    *
    IF LASTKEY() # 13   && It must be Exited with Right Key (Enter) !
      ?? CHR(7)
      WAIT WINDOW "Please Complete the Record Set ..." NOWAIT
      LOOP
    ENDIF
    *
    * Save the Record
    *
    REPLACE SUPPLIER WITH m.Supplier_, SUPLRORDNO WITH m.SupOrdNo_, WEAVER ;
      WITH m.WeaverNm_, CARD_NO WITH m.CardNo_, LOOMNO WITH m.LoomNo_, ;
      ISSUEDATE WITH m.IssueDate_, LOOMDATE WITH m.LoomDate_, ESTFINDATE ;
      WITH m.EstFinDt_, STATUS WITH "OL", COMMENT WITH m.Comment_
    m.csTmpLCard = MAX(m.csTmpLCard, m.CardNo_)
    m.csVar2  = m.csVar2 + 1
    m.on140600V1  = -9999.99
    ?? CHR(7)
    WAIT WINDOW "Saved !" NOWAIT
    SKIP
    IF EOF()
      = INKEY(0.5)
      EXIT
    ENDIF
  ENDDO
  *
  IF m.csVar3    && Everything OK ! Record it without confirmation !
    WAIT WINDOW "Making actual changes in Database ... Please wait" NOWAIT
    SELECT Carpet
    IF ORDER() # "OL_NUMBER"
      SET ORDER TO OL_NUMBER
    ENDIF
    SELECT csCarpetCr
    GO TOP
    SCAN WHILE (.NOT. EOF())
      IF (.NOT. LABEL)
        LOOP
      ENDIF
      SELECT Carpet
      SEEK csCarpetCr.OL_NUMBER
      REPLACE SUPPLIER WITH csCarpetCr.SUPPLIER, SUPLRORDNO WITH ;
        csCarpetCr.SUPLRORDNO, WEAVER WITH csCarpetCr.WEAVER, CARD_NO WITH ;
        csCarpetCr.CARD_NO, LOOMNO WITH csCarpetCr.LOOMNO, ISSUEDATE WITH ;
        csCarpetCr.ISSUEDATE, LOOMDATE WITH csCarpetCr.LOOMDATE, ;
        ESTFINDATE WITH csCarpetCr.ESTFINDATE, STATUS WITH "OL", ;
        COMMENT WITH csCarpetCr.COMMENT
      IF Control.CARD_NO < csCarpetCr.CARD_NO
        SELECT Control
        REPLACE CARD_NO  WITH csCarpetCr.CARD_NO
      ENDIF
      SELECT csCarpetCr
    ENDSCAN
    ?? CHR(7)
    WAIT WINDOW "ALL Selected Pieces Marked as Distributed !!" TIMEOUT 3
  ENDIF
ENDIF
*
USE IN csCarpetCr
SELECT Carpet
UNLOCK ALL
RELEASE WINDOW csoSrchWn_
RETURN

* EoP()
