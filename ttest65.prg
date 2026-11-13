close all
Private m.PrnStat

m.PrnStat="V"
SELECT b.BCODE,b.QUALITY,s.SUPPLIER,s.CARPETNO,b.DESIGN,b.COLOUR,s.BTHWEAV,s.LTHWEAV,s.FINSQMT,b.OL_NO,s.FDate,b.PO_NO,s.Rate,s.amt;
FROM Cabuyord b,Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate);
Into Cursor temp9


*********************************************
Select temp9
brow
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prcfinrate.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcfinrate.frx to printer prompt noconsole
Endcase
Endif
Return
