*******Wool Purchase Qualitywise Report
	SELECT wqlty,wtype,sum(bales) bales, sum(netwt) netwt, sum(amt) amt, location;
    FROM Carpet!woolpu;
	WHERE date>=msdate .and. date<=medate;
	GROUP BY wqlty,wtype;
	ORDER BY wqlty,wtype;
	INTO CURSOR wooltemp1

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form woolpurq.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form woolpurq.frx to printer prompt noconsole
Endcase
Endif


