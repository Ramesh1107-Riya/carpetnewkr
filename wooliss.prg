*******Wool Issue Summary Report
	SELECT suplier,quality,wqlty,wtype,sum(bales) bales, sum(netwt) netwt, sum(amt) amt;
    FROM carpet!woolissu;
	WHERE issdt>=msdate .and. issdt<=medate;
	GROUP BY suplier,quality;
	ORDER BY suplier,quality;
	INTO CURSOR wooltemps1

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form wooliss.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wooliss.frx to printer prompt noconsole
Endcase
Endif


