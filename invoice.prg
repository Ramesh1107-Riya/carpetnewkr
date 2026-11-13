**Invoice High ,Rate1 to Rate22, amt1 to amt22
Set Date to Briti
Set Century on
Public mgtotal,msqmtot
Store 0 to mgtotal,msqmtot

*CREATE SQL VIEW Invview AS 
Open Database Carpet share
SELECT i.*,p.Name as Namea,p.add1 as adda1,p.add2 as adda2,p.add3 as adda3,p.add4 as adda4,;
	p.add5 as adda5,p.add6 as adda6,p.add7 as adda7,pname;
FROM Carpet!Invtran i,expackingnp p;
Where  i.Invno=p.Invno .and. i.Invno=alltrim(m.Invno);
Into cursor Invview

*Calcuclate sum of amount
*USE Invview Share
Select Invview
mgtotal=amt1+amt2+amt3+amt4+amt5+amt6+amt7+amt8+amt9+amt10+amt11+amt12+amt13+amt14+amt15+amt16+;
	amt17+amt18+amt19+amt20+amt21+amt22
msqmtot=sqmt1+sqmt2+sqmt3+sqmt4+sqmt5+sqmt6+sqmt7+sqmt8+sqmt9+sqmt10+sqmt11+sqmt12+sqmt13+sqmt14+sqmt15+;
	sqmt16+sqmt17+sqmt18+sqmt19+sqmt20+sqmt21+sqmt22
do amtcal

SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form invoiceh.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form invoiceh.frx to printer prompt noconsole
	Case m.PrnStat="S"
		Select fieldcode, flddesc, sum(sqmt) sqmt;
		From Packtran;
		where invno=m.invno;
		group by invno,flddesc;
		into cursor packt1

		Select packt1
		EXPORT TO &exclfile TYPE XL5 FIELDS FIELDCODE, FLDDESC,SQMT 
			Messagebox("Successfuly converted Excel Format, open folder Carpetnew->Search For Excel File")
Endcase
use && for not display same result even if the value of m.Invno changed.
Endif
Return