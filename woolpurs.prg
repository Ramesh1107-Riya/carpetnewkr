*******Wool Purchase Summary Report
	SELECT suplier,wqlty,wtype,sum(bales) bales, sum(netwt) netwt, sum(amt) amt, location;
    FROM carpet!woolpu;
	WHERE date>=msdate .and. date<=medate;
	GROUP BY suplier,wqlty,wtype;
	ORDER BY suplier,wqlty,wtype;
	INTO CURSOR wooltemp2

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form woolpurs.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form woolpurs.frx to printer prompt noconsole
Endcase
Endif
