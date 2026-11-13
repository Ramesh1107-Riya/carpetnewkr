**Invoice Real ,Ratea1 to Ratea22, amta1 to amta2
Set date to british
Set Century on
Public mgtotal,msqmtot
Store 0 to mgtotal,msqmtot


*Open Database Carpet share
*CREATE SQL VIEW Invview AS
SELECT i.*,p.Name as Namea,p.add1 as adda1,p.add2 as adda2,p.add3 as adda3,p.add4 as adda4,;
	p.add5 as adda5,p.add6 as adda6,p.add7 as adda7,pname,p.ppan,p.ship_inst;
FROM Carpet!Invtran i,expackingnp p;
Where  i.Invno=p.Invno .and. i.Invno=alltrim(m.Invno);
Into Cursor Invview

*Calcuclate sum of amount
*USE Invview Share
Select Invview
mgtotal=amta1+amta2+amta3+amta4+amta5+amta6+amta7+amta8+amta9+amta10+amta11+amta12+amta13+amta14+amta15+amta16+;
	amta17+amta18+amta19+amta20+amta21+amta22+amta23+amta24+amta25+amta26+amta27+amta28
msqmtot=sqmt1+sqmt2+sqmt3+sqmt4+sqmt5+sqmt6+sqmt7+sqmt8+sqmt9+sqmt10+sqmt11+sqmt12+sqmt13+sqmt14+sqmt15+;
	sqmt16+sqmt17+sqmt18+sqmt19+sqmt20+sqmt21+sqmt22+sqmt23+sqmt24+sqmt25+sqmt26+sqmt27+sqmt28
do amtcal

SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form invoicer1.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form invoicer1.frx to printer prompt noconsole
	Case m.PrnStat="S"
		Select fieldcode, flddesc, sum(sqmt) sqmt;
		From Packtran;
		where invno=m.	invno;
		group by invno,flddesc;
		into cursor packt1

		Select packt1
		EXPORT TO &exclfile TYPE XL5 FIELDS FIELDCODE, FLDDESC,SQMT 
			Messagebox("Successfuly converted Excel Format, open folder Carpetnew->Search For Excel File")
Endcase
use && for not display same result even if the value of m.Invno changed.
Endif
Return