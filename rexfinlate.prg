*PACKING LATE (EXPORT)report (REXFINLATE.PRG)
SET PROCEDURE TO Catool
Open Database Carpet
DO csTrimInfo      && Trim Information for Check Purpose !
CREATE SQL VIEW temprepview2 AS SELECT s.FDATE, b.PO_NO, s.CARPETNO, s.CARD_NO, b.OL_NO, b.DESIGN, b.COLOUR,;
		 s.BTHWEAV, s.LTHWEAV, b.PO_DT, b.QUALITY, b.ORDER_TYPE, b.BCODE, b.DELIRY_DT, s.PALATE, s.ESTSHIP_DT, b.CSTATUS ;
FROM Carpet!Cabuyord b, Carpet!Casupord s;
Where b.ol_no=s.ol_no .and. b.Deliry_Dt<=Date(); 
HAVING b.cstatus<>"Exported" .and. b.cstatus<>"Packed" .and. b.cstatus<>"Cancel" .and. !empty(s.Fdate)

CREATE SQL VIEW temprepview AS SELECT PO_NO, PO_DT, CARPETNO, CARD_NO, OL_NO, DESIGN, COLOUR, BTHWEAV, LTHWEAV, FDATE,;
		 DELIRY_DT, PALATE, ESTSHIP_DT, CSTATUS;
FROM Carpet!temprepview2;
WHERE ccsMatch8(BCODE, PO_NO, QUALITY, ORDER_TYPE);
ORDER BY po_no,ol_no

USE temprepview share
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form exfinlate.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form exfinlate.frx to printer prompt noconsole
	Case m.PrnStat="A" && View Update PALATE Report
		Report form exfinlateu.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="B" && Print Updated PALATE Report
		Report form exfinlateu.frx to printer prompt noconsole

Endcase
Endif
Return

*Where b.ol_no=s.ol_no .and. s.Fdate> b.Deliry_Dt; original condition