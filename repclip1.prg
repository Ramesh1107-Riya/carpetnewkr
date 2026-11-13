*Clipping-I Report, as cutting only report generated
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON
DO csTrimInfo7      && Trim Information for Check Purpose !
Open Database Carpet

CREATE SQL VIEW temprepview2 AS SELECT b.BCODE, b.QUALITY, s.CUTSUPPLIER,s.WSHSUPPLIER,s.STRSUPPLIER,s.BINSUPPLIER,s.TRIMSUPPLIER,s.CLIPSUPPLIER, s.CARPETNO,  b.DESIGN,;
 b.COLOUR, s.BTHWEAV, s.LTHWEAV, s.FINSQMT, b.OL_NO, s.FDate, b.PO_NO, b.NOTES,s.ISSDTWASH,s.CUTISSDT,s.STRDATE,s.CLIPDATE,s.CLIPRATE,s.CLIPAMT,b.SL_NO,b.SQMT,b.SZCODE;
FROM  Carpet!Cabuyord b, Carpet!Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.IssDtWash);
HAVING s.ISSDTWASH>=m.Text1 .and. s.ISSDTWASH<=m.Text2


*to pull cutting rate from cadesign,DESIGN=CODE
CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, b.QUALITY, b.CUTSUPPLIER,b.WSHSUPPLIER,b.STRSUPPLIER,b.BINSUPPLIER,b.TRIMSUPPLIER,b.CLIPSUPPLIER,b.CARPETNO,  b.DESIGN,;
 b.COLOUR, b.BTHWEAV, b.LTHWEAV, b.FINSQMT, b.OL_NO, b.FDate, b.PO_NO, b.NOTES,b.ISSDTWASH,b.CUTISSDT,b.STRDATE,b.CLIPRATE,b.CLIPAMT,b.SL_NO,e.cutrateb,b.SQMT,b.SZCODE;
FROM Carpet!temprepview2 b, Carpet!CaDesign e;
WHERE b.Design=e.Code .and. b.Quality=e.Quality

CREATE SQL VIEW temprepview AS SELECT *;
FROM Carpet!temprepview1;
WHERE ccsMatch18(Bcode,Quality,CutSupplier,WshSupplier,StrSupplier,BinSupplier,TrimSupplier,ClipSupplier,DESIGN,Po_no,Sl_No,CarpetNo);
ORDER BY ISSDTWASH ASC	
	
USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repclip1.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repclip1.frx to printer prompt noconsole
Endcase
Endif
Return


