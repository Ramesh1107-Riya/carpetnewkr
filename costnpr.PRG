**CostNPR

Select *;
From CostCalc;
Where DgnId=val(m.DgnId);
Into Cursor Costdtl

select Costdtl
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form CostNPR.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P"
		Report form CostNPR.frx to printer prompt noconsole
Endcase
Endif
