****Delivery Report Distributed Orders
Private head1
SET PROCEDURE TO Catool
DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet
DO CASE
	CASE EMPTY(m.cstatus) .and. m.check1=0
		CREATE SQL VIEW Poview1 AS SELECT b.BCODE, b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.ORDER_TYPE, b.NOTES,;
			 b.CSTATUS, s.ISSDT, s.LOOMDT, s.FDATE, s.WEAVER, s.CARD_NO;
		FROM Carpet!Cabuyord b, Casupord s;
		WHERE b.OL_NO=s.OL_NO .and. b.DELIRY_DT<=m.Text2;
		HAVING b.cstatus<>"Exported" .and. b.cstatus<>"Packed" 
		head1="(Include Finish)"

	CASE EMPTY(m.cstatus) .and. m.check1=1
		CREATE SQL VIEW Poview1 AS SELECT b.BCODE, b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.ORDER_TYPE, b.NOTES,;
			 b.CSTATUS, s.ISSDT, s.LOOMDT, s.FDATE, s.WEAVER, s.CARD_NO;
		FROM Carpet!Cabuyord b, Casupord s;
		WHERE b.OL_NO=s.OL_NO .and. b.DELIRY_DT<=m.Text2;
		HAVING empty(s.FDATE)
		head1="(Exclude Finish)"

	CASE !EMPTY(m.cstatus) .and. check1=0
		CREATE SQL VIEW Poview1 AS SELECT b.BCODE, b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.ORDER_TYPE, b.NOTES,;
			 b.CSTATUS, s.ISSDT, s.LOOMDT, s.FDATE, s.WEAVER, s.CARD_NO;
		FROM Carpet!Cabuyord b, Casupord s;
		WHERE b.OL_NO=s.OL_NO .and. b.DELIRY_DT<=m.Text2 .and. b.cstatus=m.cstatus;
		HAVING b.cstatus<>"Exported" .and. b.cstatus<>"Packed" 
		head1="(Include Finish)"
		
	CASE !EMPTY(m.cstatus) .and. check1=1
		CREATE SQL VIEW Poview1 AS SELECT b.BCODE, b.PO_NO, b.DELIRY_DT, b.PO_DT, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT, b.QUALITY, b.ORDER_TYPE, b.NOTES,;
			 b.CSTATUS, s.ISSDT, s.LOOMDT, s.FDATE, s.WEAVER, s.CARD_NO;
		FROM Carpet!Cabuyord b, Casupord s;
		WHERE b.OL_NO=s.OL_NO .and. b.DELIRY_DT<=m.Text2 .and. b.cstatus=m.cstatus;
		HAVING empty(s.FDATE)
		head1="(Exclude Finish)"
ENDCASE

CREATE SQL VIEW Poview AS SELECT *;
FROM Carpet!Poview1;
WHERE ccsMatch13(BCODE, ORDER_TYPE, WEAVER);
ORDER BY po_no,deliry_dt,ol_no ASC

USE Poview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form rordelid.frx  PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form rordelid.frx to printer prompt noconsole
Endcase
Endif
Return