* BARCODE
SET TALK OFF
SET CENTURY ON
SET DATE TO BRITISH
SET SAFE OFF
SET ANSI ON

SELECT b.BCODE,b.QUALITY,s.Supplier as WEAVER,b.DESIGN,b.COLOUR,b.BREADTH,b.LENGTH,b.SZCODE,s.CARPETNO,b.PO_NO,b.Deliry_dt,s.bthweav,s.lthweav,s.FinSqmt,s.bractual,s.lnactual;
FROM Cabuyord b,Casupord s;
Where b.ol_no=s.ol_no;	
having s.ol_no=m.ol_no;
Into cursor temp2

SELECT b.BCODE,b.QUALITY,b.WEAVER,b.DESIGN,b.COLOUR,b.BREADTH,b.LENGTH,b.SZCODE,b.CARPETNO,b.PO_NO,b.Deliry_dt,b.bthweav,b.lthweav,b.FinSqmt,b.bractual,b.lnactual,d.matcomp;
FROM temp2 b;
Join Cadesign d;
On alltrim(d.code)=alltrim(b.design);
Into Cursor temp3

SELECT b.BCODE,b.QUALITY,b.WEAVER,b.DESIGN,b.COLOUR,b.BREADTH,b.LENGTH,b.SZCODE,b.CARPETNO,b.PO_NO,b.Deliry_dt,b.bthweav,b.lthweav,b.FinSqmt,b.bractual,b.lnactual,b.matcomp,d.supcode;
FROM temp3 b;
Join Casupplr d;
On alltrim(d.code)=alltrim(b.weaver);
Into Cursor tempbar1b

Select tempbar1b
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