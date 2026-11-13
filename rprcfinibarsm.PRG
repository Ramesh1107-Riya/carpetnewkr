*FINISHED PRC report Payment Report, Paid
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo5     && Trim Information for Check Purpose !
Open Database Carpet
IF !empty(m.psCarpetNo)
	SELECT b.BCODE,b.QUALITY,s.WEAVER,b.DESIGN,b.COLOUR,b.BREADTH,b.LENGTH,b.OL_NO,b.SZCODE,s.CARPETNO,s.GRADE,s.FDate, b.PO_NO,b.NOTES,s.BILLNO,s.ALLOWPAY,;
		s.PAIDSTATUS,s.PAIDDATE,b.Deliry_dt,s.bthweav,s.lthweav,s.FinSqmt,s.bractual,s.lnactual;
	FROM Cabuyord b,Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2  .and. carpetno=m.psCarpetNo;
	Into Cursor tempbar 
Else
	SELECT b.BCODE,b.QUALITY,s.WEAVER,b.DESIGN,b.COLOUR,b.BREADTH,b.LENGTH,b.OL_NO,b.SZCODE,s.CARPETNO,s.GRADE,s.FDate, b.PO_NO,b.NOTES,s.BILLNO,s.ALLOWPAY,;
		s.PAIDSTATUS,s.PAIDDATE,b.Deliry_dt,s.bthweav,s.lthweav,s.FinSqmt,s.bractual,s.lnactual;
	FROM Cabuyord b,Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2;
	Into Cursor tempbar Nofilter
Endif

SELECT b.BCODE,b.QUALITY,b.WEAVER,b.DESIGN,d.Dgndesc,d.matcomp,b.COLOUR,b.BREADTH,b.LENGTH,ALLTRIM(b.OL_NO) AS OL_NO,b.SZCODE,b.CARPETNO,b.GRADE,b.FDate, b.PO_NO,b.NOTES,b.BILLNO,b.ALLOWPAY,;
	b.PAIDSTATUS,b.PAIDDATE,b.Deliry_dt,b.bthweav,b.lthweav,b.FinSqmt,b.bractual,b.lnactual;
FROM tempbar b;
Join Cadesign d;
On alltrim(d.code)=alltrim(b.design);
Into Cursor tempbar1b

SELECT b.BCODE,b.QUALITY,b.WEAVER,b.DESIGN,b.Dgndesc,b.matcomp,b.COLOUR,b.BREADTH,b.LENGTH,OL_NO,b.SZCODE,b.CARPETNO,b.GRADE,b.FDate, b.PO_NO,b.NOTES,b.BILLNO,b.ALLOWPAY,;
	b.PAIDSTATUS,b.PAIDDATE,b.Deliry_dt,b.bthweav,b.lthweav,b.FinSqmt,b.bractual,b.lnactual,d.supcode,ALLTRIM(STR(bthweav)) + "X" + ALLTRIM(STR(lthweav)) as wsize;
FROM tempbar1b b;
Join Casupplr d;
On alltrim(d.code)=alltrim(b.weaver);
Where ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes, BillNo, Carpetno) .and.  ALLOWPAY=.T. .AND. (PAIDSTATUS=.F. .OR. PAIDDATE=Date());
ORDER BY ol_no;
Into Cursor tempbar1

Select tempbar1
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
		Case m.PrnStat="V"
			Label form labelkr4.lbx to console preview in screen
		Case m.PrnStat="P"
			Label form labelkr4.lbx to printer prompt noconsole
	Endcase
Endif
Return
