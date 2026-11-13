*catool.prg window version collection of procedure

*Purpose: SELECT all distributed order which we have received from supplier


PROCEDURE Carcdwea 
Open database Carpet

SELECT *;
FROM Casupord;
WHERE .NOT. EXISTS (SELECT * FROM CarcdWea;
					WHERE Casupord.Card_no=CarcdWea.Card_no);
INTO CURSOR RcdWea

SELECT Casupord
Replace all recd with .F.
GO TOP

UPDATE Carpet!Casupord;
SET RECD=.T.;
WHERE Card_no IN (SELECT Card_no FROM RcdWea)

&& ONLY Once Needed ** Pls create thro' wizard, send sql updates, modi view and select
*CREATE SQL VIEW SUPBUYORDV;
*AS SELECT b.po_no,b.po_dt,b.bcode,b.ol_no,b.design,b.quality,b.colour,b.szcode,;
*s.card_no,s.supplier,s.weaver,s.supordno,s.issdt;
*FROM Carpet!Cabuyord b,Carpet!Casupord s;
*WHERE b.ol_no=s.ol_no .and. s.recd=.T.

RETURN
*eop RcdWeaCa

Procedure OrdNotDistri
***SELECT ALL ORDERS NOT DISTRIBUTED TO BUYER
Open Database Carpet

SELECT PO_NO,PO_DT,BCODE,OL_NO,Design,Quality,Colour,Szcode,BREADTH,LENGTH,DELIRY_DT,ORDER_TYPE;
FROM Cabuyord;
WHERE .NOT. EXISTS (SELECT * FROM Casupord;
					WHERE Cabuyord.ol_no=Casupord.ol_no);
INTO CURSOR OND

SELECT Cabuyord
Replace all label with .F.
GO TOP

UPDATE 	Carpet!Cabuyord;
Set Label=.T.;
WHERE ol_no IN (SELECT ol_no FROM OND)

SET FILTER TO LABEL

If RECNO()>RECCOUNT()
	Messagebox("There is No Order to Distribute to Supplier, ... press arrow button to exit",16)
Endif
RETURN
*eop OrdNotDistri

Procedure OrdDistri
***SELECT ALL ORDERS DISTRIBUTED TO BUYER
Open Database Carpet

SELECT PO_NO,PO_DT,BCODE,OL_NO,Design,Quality,Colour,Szcode,BREADTH,LENGTH,DELIRY_DT,ORDER_TYPE;
FROM Cabuyord;
WHERE Cabuyord.ol_no=Casupord.ol_no;
INTO CURSOR OND

SELECT Cabuyord
Replace all label with .F.
GO TOP

UPDATE 	Carpet!Cabuyord;
Set Label=.T.;
WHERE ol_no IN (SELECT ol_no FROM OND)

SET FILTER TO LABEL

If RECNO()>RECCOUNT()
	Messagebox("There is No Order Distributed to Supplier, ... press arrow button to exit",16)
Endif

RETURN
*eop OrdNotDistri


**Select only required field
PROCEDURE FLDQUERY

Open database Carpet
If used("CAFIELD")
	select CAFIELD
else
	USE CAFIELD  IN 0 ORDER TAG QUALITY     ALIAS CAFIELD
endif

SELECT CAFIELD
Replace all label with .F.
GO TOP

UPDATE 	Carpet!CAFIELD;
Set Label=.T.;
WHERE QUALITY=FLDQLTY .AND. FLDTYPE=pflddesign .AND. ORDTYPE=m.ordtype

SET FILTER TO LABEL

If RECNO()>RECCOUNT()
	Messagebox("This Combination is Not Defined in Field Code, Please Define first in Field Code, ... press arrow button to exit",16)
Endif

RETURN
************************************


* Help Function to Retrieve Records - checks Exact Match Case ! in Cabuyord

FUNCTION boExtMatch
PARAMETER m.boOrdType, m.boCrpType
IF EMPTY(m.SrchOType) .AND. EMPTY(m.SrchCType)
  RETURN .T.
ENDIF
IF (.NOT. EMPTY(m.SrchOType)) .AND. m.SrchOType # m.boOrdType
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.SrchCType)) .AND. m.SrchCType # m.boCrpType
  RETURN .F.
ENDIF
RETURN .T.
* EoF()


* Another Help Function to Retrieve Records - checks Existance of Text! in Cabuyord
FUNCTION boTxtMatch
PARAMETER m.boOrder, m.boOlNo, m.boDesign, m.boQlty, m.boSize, m.boField, m.boColour,;
  m.boBuyer, m.boSpclInst, m.boWashInst, m.boNote, m.boComment
IF (.NOT. EMPTY(m.SrchOrdNo)) .AND. (.NOT. ALLTRIM(m.SrchOrdNo) $ UPPER(m.boOrder)) && A&B chr string A is Identical or contained in B
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.SrchOlNo)) .AND. (.NOT. ALLTRIM(m.SrchOlNo) $ UPPER(m.boOlNo))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.SrchDesign)) .AND. (.NOT. ALLTRIM(m.SrchDesign) $ UPPER(m.boDesign))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.SrchQlty)) .AND. (.NOT. ALLTRIM(m.SrchQlty) $ UPPER(m.boQlty))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.SrchSize)) .AND. (.NOT. ALLTRIM(m.SrchSize) $ UPPER(m.boSize))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.SrchField)) .AND. (.NOT. ALLTRIM(m.SrchField) $ UPPER(m.boField))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.SrchColour)) .AND. (.NOT. ALLTRIM(m.SrchColour) $ UPPER(m.boColour))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.SrchBuyer)) .AND. (.NOT. ALLTRIM(m.SrchBuyer) $ UPPER(m.boBuyer))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.SrchTxtSp)) .AND. (.NOT. ALLTRIM(m.SrchTxtSp) $ UPPER(m.boSpclInst))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.SrchTxtWsh)) .AND. (.NOT. ALLTRIM(m.SrchTxtWsh) $ UPPER(m.boWashInst))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.SrchNote)) .AND. (.NOT. ALLTRIM(m.SrchNote) $ UPPER(m.boNote))
  RETURN .F.
ENDIF
IF (.NOT. EMPTY(m.SrchComment)) .AND. (.NOT. ALLTRIM(m.SrchComment) $ UPPER(m.boComment))
  RETURN .F.
ENDIF
RETURN .T.
* EoF()

