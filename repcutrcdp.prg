*Cutting Received Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo7      && Trim Information for Check Purpose !
Open Database Carpet

SELECT b.BCODE, b.QUALITY, s.CUTSUPPLIER,s.WSHSUPPLIER,s.STRSUPPLIER,s.BINSUPPLIER,s.TRIMSUPPLIER,s.CLIPSUPPLIER, s.CARPETNO,  b.DESIGN,;
 b.COLOUR, s.BTHWEAV, s.LTHWEAV, s.FINSQMT,b.OL_NO, s.FDate, b.PO_NO, b.NOTES,s.CUTISSDT,s.CUTRCDDT,s.CUTRATE,s.CUTAMT,s.CUTPAID,b.SL_NO,b.SQMT,b.SZCODE;
FROM  Carpet!Cabuyord b, Carpet!Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.CUTRCDDT) .and. CutPaid=.T. .and. s.CUTRCDDT>=m.Text1 .and. s.CUTRCDDT<=m.Text2;
Into Cursor Temp5

SELECT *;
FROM Temp5;
WHERE ccsMatch18(Bcode,Quality,CutSupplier,WshSupplier,StrSupplier,BinSupplier,TrimSupplier,ClipSupplier,DESIGN,Po_no,Sl_No,CarpetNo);
ORDER BY CutSupplier,CUTRCDDT ASC;
Into Cursor Temp5a	

Select Temp5a
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repcutrcdp.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repcutrcdp.frx to printer prompt noconsole
Endcase
Endif
Return


