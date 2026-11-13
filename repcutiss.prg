*Cutting Issue Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo7      && Trim Information for Check Purpose !
Open Database Carpet

If m.cutrate>0
	SELECT b.BCODE, b.QUALITY, s.CUTSUPPLIER,s.WSHSUPPLIER,s.STRSUPPLIER,s.BINSUPPLIER,s.TRIMSUPPLIER,s.CLIPSUPPLIER, s.CARPETNO,  b.DESIGN,;
	b.COLOUR,s.BTHWEAV,s.LTHWEAV,s.FINSQMT,b.OL_NO,s.FDate,b.PO_NO,b.NOTES,s.CUTPAID,s.CUTISSDT,s.CUTRCDDT,s.CUTRATE,s.CUTAMT,b.SL_NO,b.SQMT,b.SZCODE;
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Cutissdt) .and. s.CUTRATE=m.cutrate;
	HAVING s.CUTISSDT>=m.Text1 .and. s.CUTISSDT<=m.Text2;
	INTO CURSOR temprepview1
Else
    SELECT b.BCODE, b.QUALITY, s.CUTSUPPLIER,s.WSHSUPPLIER,s.STRSUPPLIER,s.BINSUPPLIER,s.TRIMSUPPLIER,s.CLIPSUPPLIER, s.CARPETNO,  b.DESIGN,;
	b.COLOUR,s.BTHWEAV,s.LTHWEAV,s.FINSQMT,b.OL_NO,s.FDate,b.PO_NO,b.NOTES,s.CUTPAID,s.CUTISSDT,s.CUTRCDDT,s.CUTRATE,s.CUTAMT,b.SL_NO,b.SQMT,b.SZCODE;
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Cutissdt);
	HAVING s.CUTISSDT>=m.Text1 .and. s.CUTISSDT<=m.Text2;
	INTO CURSOR temprepview1
Endif

SELECT *;
FROM temprepview1;
WHERE ccsMatch18(Bcode,Quality,CutSupplier,WshSupplier,StrSupplier,BinSupplier,TrimSupplier,ClipSupplier,DESIGN,Po_no,Sl_No,CarpetNo) .AND. !EMPTY(CUTISSDT);
ORDER BY CutSupplier,CUTISSDT;
INTO CURSOR Temprepview 

IF(puPaidUpdate=.T.)
	Update Casupord;
	Set CutPaid=.T.;
	Where OL_NO IN (SELECT OL_NO FROM Temprepview)
	puPaidUpdate=.F.
Endif	

IF(puPaidRevert=.T.)
	Update Casupord;
	Set CutPaid=.F.;
	Where OL_NO IN (SELECT OL_NO FROM Temprepview)
	puPaidRevert=.F.
Endif			
	
*USE temprepview shared 
SELECT Temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repcutiss.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repcutiss.frx to printer prompt noconsole
Endcase
Endif
Return


