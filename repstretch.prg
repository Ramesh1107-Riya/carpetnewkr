*Stretching Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo7      && Trim Information for Check Purpose !
Open Database Carpet

SELECT b.BCODE, b.QUALITY, s.CUTSUPPLIER,s.WSHSUPPLIER,s.STRSUPPLIER,s.BINSUPPLIER,s.TRIMSUPPLIER,s.CLIPSUPPLIER, s.CARPETNO,  b.DESIGN,;
b.COLOUR, s.BTHWEAV, s.LTHWEAV, s.FINSQMT, b.OL_NO, s.FDate, b.PO_NO, b.NOTES,s.STRPAID,s.ISSDTWASH,s.RCDDTWASH,s.STRDATE,s.STRRATE,s.STRAMT,b.SL_NO,b.SQMT,b.SZCODE;
FROM  Carpet!Cabuyord b, Carpet!Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.StrDate) ;
HAVING s.STRDATE>=m.Text1 .and. s.STRDATE<=m.Text2;
INTO CURSOR temprepview1 

SELECT *;
FROM temprepview1;
WHERE ccsMatch18(Bcode,Quality,CutSupplier,WshSupplier,StrSupplier,BinSupplier,TrimSupplier,ClipSupplier,DESIGN,Po_no,Sl_No,CarpetNo);
ORDER BY StrSupplier,STRDATE ASC;
INTO CURSOR temprepview 

IF(puPaidUpdate=.T.)
	Update Casupord;
	Set StrPaid=.T.;
	Where OL_NO IN (SELECT OL_NO FROM Temprepview)
	puPaidUpdate=.F.
Endif	

IF(puPaidRevert=.T.)
	Update Casupord;
	Set StrPaid=.F.;
	Where OL_NO IN (SELECT OL_NO FROM Temprepview)
	puPaidRevert=.F.
Endif				
	
SELECT temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repstretch.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repstrpend.frx to printer prompt noconsole
Endcase
Endif
Return


