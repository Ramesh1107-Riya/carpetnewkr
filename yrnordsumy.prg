*******Raw Material Summary Report
	SELECT suplier,quality,colour,sum(netwt) netwt, sum(amt) amt;
    FROM yrnorder;
	WHERE date>=msdate .and. date<=medate;
	GROUP BY suplier,quality,colour;
	ORDER BY suplier,quality,colour;
	INTO CURSOR yrnorderv1

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrnordsumy.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnordsumy.frx to printer prompt noconsole
Endcase
Endif
