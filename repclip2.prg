*Repcli2 Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo7      && Trim Information for Check Purpose !
Open Database Carpet

SELECT b.BCODE, b.QUALITY, s.CUTSUPPLIER,s.WSHSUPPLIER,s.STRSUPPLIER,s.BINSUPPLIER,s.TRIMSUPPLIER,s.CLIPSUPPLIER, s.CARPETNO,  b.DESIGN,;
b.COLOUR, s.BTHWEAV, s.LTHWEAV, s.FINSQMT, b.OL_NO, s.FDate, b.PO_NO, b.NOTES,s.Clp2Paid,s.CLIPDATE,s.CLIPRATE,s.CLIPAMT,b.SL_NO,b.SQMT,b.SZCODE;
FROM  Carpet!Cabuyord b, Carpet!Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.ClipDate) ;
HAVING s.CLIPDATE>=m.Text1 .and. s.CLIPDATE<=m.Text2;
INTO CURSOR temprepview1

SELECT *;
FROM temprepview1;
WHERE ccsMatch18(Bcode,Quality,CutSupplier,WshSupplier,StrSupplier,BinSupplier,TrimSupplier,ClipSupplier,DESIGN,Po_no,Sl_No,CarpetNo) ;
ORDER BY ClipSupplier,ClipDate;
INTO CURSOR temprepview

IF(puPaidUpdate=.T.)
	Update Casupord;
	Set Clp2Paid=.T.;
	Where OL_NO IN (SELECT OL_NO FROM Temprepview)
	puPaidUpdate=.F.
Endif	

IF(puPaidRevert=.T.)
	Update Casupord;
	Set Clp2Paid=.F.;
	Where OL_NO IN (SELECT OL_NO FROM Temprepview)
	puPaidRevert=.F.
Endif				
	
Select Temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repclip2.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repclip2.frx to printer prompt noconsole
Endcase
Endif
Return


