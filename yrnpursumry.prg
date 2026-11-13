*******Raw Material Summary Report
	SELECT suplier,quality,colour,sum(netwt) netwt, sum(amt) amt;
    FROM yrnrecvd;
	WHERE Recdt>=msdate .and. Recdt<=medate;
	GROUP BY suplier,quality,colour;
	ORDER BY suplier,quality,colour;
	INTO CURSOR yrnrec1

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrnpursumry.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnpursumry.frx to printer prompt noconsole
Endcase
Endif
