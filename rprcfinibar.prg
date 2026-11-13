*FINISHED PRC report Payment Report, Paid
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo5      && Trim Information for Check Purpose !
Open Database Carpet

SELECT b.BCODE,b.QUALITY,s.WEAVER,b.DESIGN,b.COLOUR,b.BREADTH,b.LENGTH,b.OL_NO,s.CARPETNO,s.GRADE,s.FDate, b.PO_NO,b.NOTES,s.BILLNO,s.ALLOWPAY,s.PAIDSTATUS,s.PAIDDATE,;
s.WshLastDt,s.ISSDTWASH,b.Sqmt,b.Szcode,s.WashIslip,alltrim(str(s.BTHWEAV))+'X'+alltrim(str(s.LTHWEAV)) as ActlSize,s.FinSqmt,s.CutSupplier,s.WshSupplier,s.StrSupplier,BinSupplier,TrimSupplier,ClipSupplier;
FROM Cabuyord b,Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2  .and. b.cstatus<>"Exported";
Into Cursor tempbar Nofilter

If !empty(m.WashIslip)
	SELECT *;
	FROM tempbar;
	WHERE ccsMatch18(Bcode,Quality,CutSupplier,WshSupplier,StrSupplier,BinSupplier,TrimSupplier,ClipSupplier,DESIGN,Po_no,Sl_No,CarpetNo) .AND. WashIslip=m.WashIslip;
	ORDER BY WshSupplier,ISSDTWASH;
	INTO CURSOR tempbar1
Else && Washslip is empty
 	SELECT *;
	FROM tempbar;
	WHERE ccsMatch18(Bcode,Quality,CutSupplier,WshSupplier,StrSupplier,BinSupplier,TrimSupplier,ClipSupplier,DESIGN,Po_no,Sl_No,CarpetNo);
	ORDER BY WshSupplier,ISSDTWASH;
	INTO CURSOR tempbar1
Endif

Select tempbar1
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
	Do Case
		Case m.PrnStat="V"
			Label form label5.lbx to console preview in screen
		Case m.PrnStat="P"
			Label form label5.lbx to printer prompt noconsole
	Endcase
Endif
Return
