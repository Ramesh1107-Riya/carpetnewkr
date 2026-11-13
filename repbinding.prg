*Binding Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo7      && Trim Information for Check Purpose !
Open Database Carpet

If m.binrate>0
	CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, b.QUALITY, s.CUTSUPPLIER,s.WSHSUPPLIER,s.STRSUPPLIER,s.BINSUPPLIER,s.TrimSupplier,s.ClipSupplier, s.CARPETNO,  b.DESIGN,;
	 b.COLOUR, s.BTHWEAV, s.LTHWEAV, s.FINSQMT, b.OL_NO, s.FDate, b.PO_NO, b.NOTES,s.BINFEET,s.STRDATE,s.BINSQMT,s.BINDATE,s.BINRATE,s.BINAMT,b.SL_NO,b.SQMT,b.SZCODE;
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.StrDate) .and. s.BINRATE=m.binrate;
	HAVING s.StrDate>=m.Text1 .and. s.StrDate<=m.Text2
Else
	CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, b.QUALITY, s.CUTSUPPLIER,s.WSHSUPPLIER,s.STRSUPPLIER,s.BINSUPPLIER,s.TrimSupplier,s.ClipSupplier, s.CARPETNO,  b.DESIGN,;
	 b.COLOUR, s.BTHWEAV, s.LTHWEAV, s.FINSQMT, b.OL_NO, s.FDate, b.PO_NO, b.NOTES,s.BINFEET,s.STRDATE,s.BINDATE,s.BINSQMT,s.BINRATE,s.BINAMT,b.SL_NO,b.SQMT,b.SZCODE;
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.StrDate);
	HAVING s.StrDate>=m.Text1 .and. s.StrDate<=m.Text2
Endif

CREATE SQL VIEW temprepview AS SELECT *;
FROM Carpet!temprepview1;
WHERE ccsMatch18(Bcode,Quality,CutSupplier,WshSupplier,StrSupplier,BinSupplier,TrimSupplier,ClipSupplier,DESIGN,Po_no,Sl_No,CarpetNo) ;
ORDER BY BinSupplier,StrDate
	
USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repbinding.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repbinding.frx to printer prompt noconsole
Endcase
Endif
Return


