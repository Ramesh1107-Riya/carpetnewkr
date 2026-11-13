****We focus for Delivery Report  NotDistributed Carpet
SET PROCEDURE TO Catool

DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

CREATE SQL VIEW Poview1 AS SELECT b.BCODE, b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.ORDER_TYPE, b.NOTES, b.CSTATUS;
FROM Carpet!Cabuyord b;
WHERE b.DELIRY_DT<=m.Text2 and b.cstatus="NotDistri" 
	
CREATE SQL VIEW Poview AS SELECT *;
FROM Carpet!Poview1;
WHERE ccsMatch8(BCODE, PO_NO, QUALITY, ORDER_TYPE);
ORDER BY po_no,deliry_dt,ol_no ASC

USE Poview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form rordelind.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form rordelind.frx to printer prompt noconsole
Endcase
Endif
Return