**Invoice Custom,cs1,cdesc1,csqmt1,crate1,camt1 ....22
Set Century on

Public mgtotal,msqmtot
Set Century on
Local m.bnkcode
Store 0 to mgtotal,msqmtot


Open Database Carpet
SELECT i.*,p.Name as Namea,p.add1 as adda1,p.add2 as adda2,p.add3 as adda3,p.add4 as adda4,	p.add5 as adda5,p.add6 as adda6,p.add7 as adda7;
FROM Invprofma i,CaBuyer p;
Where  i.bcode=p.bcode .and. i.Invno=alltrim(m.Invno);
Into Cursor Invview1

Select invview1
m.bakcode=invview1->bnkcode

SELECT i.*,p.Bnkcode as bbnkcode,p.name as bname,p.add1 as badd1,p.add2 as badd2,p.telex,p.swift,p.cname as bcname,p.detail,p.acno;
FROM Invview1 i,Bankdtl p;
Where i.bnkcode=p.bnkcode .and. i.Invno=alltrim(m.Invno);
Into Cursor Invview


*Calcuclate sum of amount
Select Invview 
mgtotal=camt1+camt2+camt3+camt4+camt5
msqmtot=csqmt1+csqmt2+csqmt3+csqmt4+csqmt5
do amtcal

SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form invoicep.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form invoicep.frx to printer prompt noconsole
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