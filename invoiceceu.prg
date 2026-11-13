**Invoice Custom,cs1,cdesc1,csqmt1,crate1,camt1 ....22
Set date to british
Set Century on
Public mgtotal,msqmtot
Store 0 to mgtotal,msqmtot

Select *;
From expackingnp;
where Alltrim(invno)=Alltrim(m.invno);
Into cursor packdtl

Dimension packdata (1,32)
Store ' ' to packdata
Select packdtl
copy to ARRAY packdata

SELECT i.*,p.Invno;
FROM Invtran i,expackingnp p;
Where  i.Invno=p.Invno .and. i.Invno=alltrim(m.Invno);
Into Cursor invview

*Calcuclate sum of amount
*USE Invview Share
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
		Report form invoiceceu.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form invoiceceu.frx to printer prompt noconsole
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