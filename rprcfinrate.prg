*FINISHED PRC report Payment Report, Paid
SET DELETED ON
*SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON
*fdate is CaRcdDt
*DO csTrimInfo5      && Trim Information for Check Purpose !
*Open Database Carpet
* Assumption Before Bill is is Printed, we update Bill No. Starting 1001, Done for Numbering Bill
If (m.PrnStat="V" .and. m.Rate>0.0)

	SELECT b.OL_NO, b.PO_NO, b.Design,b.szcode,s.FinSqmt,s.Amt;
	FROM Cabuyord b,Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) .and. b.po_no=m.po_no .and. b.design=m.design .and. b.szcode=m.szcode;
	INTO CURSOR TEMP1

	UPDATE Casupord;
	SET Rate=m.rate,Amt=m.rate*temp1->finSqmt;
	WHERE ol_no IN (SELECT Ol_no FROM Temp1) 
Endif

**Report Generation*******************************
SELECT b.BCODE,b.QUALITY,s.SUPPLIER,s.CARPETNO,b.DESIGN,b.COLOUR,s.BTHWEAV,s.LTHWEAV,s.FINSQMT,b.OL_NO,s.FDate,b.PO_NO,s.Rate,s.amt;
FROM Cabuyord b,Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate).and. b.po_no=m.po_no .and. b.design=m.design .and. b.szcode=m.szcode;
Into Cursor temp9


*********************************************
Select temp9
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


