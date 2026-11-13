*******Raw Material Sumary Qualitywise Report
	SELECT suplier,quality,Colour,sum(netwt) netwt, sum(amt) amt;
    FROM yrnrecvd;
	WHERE Recdt>=msdate .and. Recdt<=medate;
	GROUP BY quality,Colour;
	ORDER BY quality,Colour;
	INTO CURSOR yrnrecvd2

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrnpurqlty.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnpurqlty.frx to printer prompt noconsole
Endcase

Endif
RETURN
