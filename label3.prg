public ptotalpage

Open Database Carpet share
CREATE SQL VIEW Temprepview AS SELECT *;
FROM Carpet!packtran;
Where invno=alltrim(m.invno);
Order by slno

CREATE SQL VIEW Temprepview1 as SELECT max(recno()) as maxrecno;
FROM Temprepview ;
Where invno=alltrim(m.invno)

use Temprepview1
ptotalpage=Temprepview1->maxrecno

*Calcuclate sum of amount
USE Temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Label form label2.lbx to console preview in screen
	Case m.PrnStat="P"
		Label form label2.lbx to printer prompt noconsole
Endcase
Endif
Return