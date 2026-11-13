*Paintaing Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo8      && Trim Information for Check Purpose !
Open Database Carpet

CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, b.QUALITY, s.CUTSUPPLIER,s.WSHSUPPLIER,s.STRSUPPLIER,s.BINSUPPLIER,s.TRIMSUPPLIER,s.CLIPSUPPLIER,s.CARPETNO,  b.DESIGN,;
 b.COLOUR, b.SZCODE,s.BTHWEAV, s.LTHWEAV, s.FINSQMT, b.OL_NO, s.FDate, b.PO_NO, b.NOTES,s.PAINTDT,s.LOCATION,b.SL_NO;
FROM  Carpet!Cabuyord b, Carpet!Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.PAINTDT) ;
HAVING s.PAINTDT>=m.Text1 .and. s.PAINTDT<=m.Text2

CREATE SQL VIEW temprepview AS SELECT *;
FROM Carpet!temprepview1;
WHERE ccsMatch19(Bcode,Quality,CutSupplier,WshSupplier,StrSupplier,BinSupplier,TrimSupplier,ClipSupplier,DESIGN,Po_no,Sl_No,CarpetNo,Location)  ;
ORDER BY PAINTDT,LOCATION
	
USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form reppainting.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form reppainting.frx to printer prompt noconsole
Endcase
Endif
Return


