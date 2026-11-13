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
	SELECT b.BCODE,b.QUALITY,s.Supplier as WEAVER,b.DESIGN,b.COLOUR,b.BREADTH,b.LENGTH,b.OL_NO,b.SZCODE,s.CARPETNO,s.GRADE,s.FDate, b.PO_NO,b.NOTES,s.BILLNO,;
		b.Deliry_dt,s.bthweav,s.lthweav,s.FinSqmt,s.bractual,s.lnactual;
	FROM Cabuyord b,Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Paintdt) .and. s.Paintdt>=m.Text1 .and. s.Paintdt<=m.Text2  .and. carpetno=m.psCarpetNo;
	Into Cursor tempbar 
Else
	SELECT b.BCODE,b.QUALITY,s.Supplier as WEAVER,b.DESIGN,b.COLOUR,b.BREADTH,b.LENGTH,b.OL_NO,b.SZCODE,s.CARPETNO,s.GRADE,s.FDate, b.PO_NO,b.NOTES,s.BILLNO,;
		b.Deliry_dt,s.bthweav,s.lthweav,s.FinSqmt,s.bractual,s.lnactual;
	FROM Cabuyord b,Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Paintdt) .and. s.Paintdt>=m.Text1 .and. s.Paintdt<=m.Text2;
	Into Cursor tempbar 
Endif

SELECT b.BCODE,b.QUALITY,b.WEAVER,b.DESIGN,d.Dgndesc,b.COLOUR,b.BREADTH,b.LENGTH,ALLTRIM(b.OL_NO) AS OL_NO,b.SZCODE,b.CARPETNO,b.GRADE,b.FDate, b.PO_NO,b.NOTES,b.BILLNO,;
	b.Deliry_dt,b.bthweav,b.lthweav,b.FinSqmt,b.bractual,b.lnactual,d.matcomp;
FROM tempbar b;
Join Cadesign d;
On alltrim(d.code)=alltrim(b.design);
Into Cursor tempbar1a

SELECT b.BCODE,b.QUALITY,b.WEAVER,b.DESIGN,b.Dgndesc,b.COLOUR,b.BREADTH,b.LENGTH,b.OL_NO,b.SZCODE,b.CARPETNO,b.GRADE,b.FDate, b.PO_NO,b.NOTES,b.BILLNO,;
	b.Deliry_dt,b.bthweav,b.lthweav,b.FinSqmt,b.bractual,b.lnactual,b.matcomp,d.supcode;
FROM tempbar1a b;
Join Casupplr d;
On alltrim(d.code)=alltrim(b.weaver);
Into Cursor tempbar1b

SELECT *;
FROM tempbar1b; 
WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes,BillNo,Carpetno);
ORDER BY ol_no;
Into Cursor tempbar1

***********BarCode Print Date Update after print*****6/1/2020*******
*			UPDATE Cabuyord;
*			SET BarcodePdt=Date();
*			WHERE ol_no IN (SELECT Ol_no FROM tempbar1) 
***********************************************************

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
