****We focus for PO Report in  NotDistributed Carpet
SET PROCEDURE TO Catool
Set talk off
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON
set color to

* Public Variable for Carpet-Inventory Search Option !!
PUBLIC m.psOrderNo  

**Initialization
STORE SPACE(150) TO m.psOrderNo 
m.psOrderNo = m.po_no && variable in defined in po form m.Text1

*WAIT WINDOW "Retrieving Records ... Please wait" NOWAIT


DO csTrimInfo3  

    && Trim Information for Check Purpose !
Open Database Carpet share

*** code is for all the 8 combinations
Do Case
	Case !empty(m.bcode) .and. !empty(m.po_no) .and. !empty(m.cstatus)
		CREATE SQL VIEW Poview1 AS SELECT b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.CSTATUS;
		FROM Carpet!Cabuyord b;
		WHERE b.bcode=m.bcode .and. b.cstatus=m.cstatus
		
		CREATE SQL VIEW Poview AS SELECT *;
		FROM Carpet!Poview1;
		WHERE ccsMatch5(po_no);
		ORDER BY po_no,deliry_dt,ol_no ASC
		
	Case !empty(m.bcode) .and. !empty(m.po_no) .and. empty(m.cstatus)
		CREATE SQL VIEW Poview1 AS SELECT b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.CSTATUS;
		FROM Carpet!Cabuyord b;
		WHERE b.bcode=m.bcode
		
		CREATE SQL VIEW Poview AS SELECT *;
		FROM Carpet!Poview1;
		WHERE ccsMatch5(po_no);
		ORDER BY po_no,deliry_dt,ol_no ASC
	
	Case empty(m.bcode) .and. !empty(m.po_no) .and. !empty(m.cstatus)
		CREATE SQL VIEW Poview1 AS SELECT b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.CSTATUS;
		FROM Carpet!Cabuyord b;
		WHERE b.bcode=m.bcode .and. b.CSTATUS=m.cstatus

		
		CREATE SQL VIEW Poview AS SELECT *;
		FROM Carpet!Poview1;
		WHERE ccsMatch5(po_no);
		ORDER BY deliry_dt,ol_no ASC		

	Case empty(m.bcode) .and. !empty(m.po_no) .and. empty(m.cstatus)
		CREATE SQL VIEW Poview1 AS SELECT b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.CSTATUS;
		FROM Carpet!Cabuyord b;
					
		CREATE SQL VIEW Poview AS SELECT *;
		FROM Carpet!Poview1;
		WHERE ccsMatch5(po_no);
		ORDER BY po_no,deliry_dt,ol_no ASC
		
	Case !empty(m.bcode) .and. empty(m.po_no) .and. !empty(m.cstatus)
		CREATE SQL VIEW Poview AS SELECT b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.CSTATUS;
		FROM Carpet!Cabuyord b;
		WHERE b.bcode=m.bcode .and. b.CSTATUS=m.cstatus;
		ORDER BY po_no,deliry_dt,ol_no ASC

	Case !empty(m.bcode) .and. empty(m.po_no) .and. empty(m.cstatus)
		CREATE SQL VIEW Poview AS SELECT b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.CSTATUS;
		FROM Carpet!Cabuyord b;
		WHERE b.bcode=m.bcode;
		ORDER BY po_no,deliry_dt,ol_no ASC
		
	Case empty(m.bcode) .and. empty(m.po_no) .and. !empty(m.cstatus)
		CREATE SQL VIEW Poview AS SELECT b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.CSTATUS;
		FROM Carpet!Cabuyord b;
		WHERE b.CSTATUS=m.cstatus;		
		ORDER BY po_no,deliry_dt,ol_no ASC

	Case empty(m.bcode) .and. empty(m.po_no) .and. empty(m.cstatus)
		CREATE SQL VIEW Poview AS SELECT b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.CSTATUS;
		FROM Carpet!Cabuyord b;
		ORDER BY po_no,deliry_dt,ol_no ASC
Endcase


USE Poview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form rordstat.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form rordstat.frx to printer prompt noconsole
Endcase
Endif
Return