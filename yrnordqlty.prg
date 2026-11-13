*******Raw Material Sumary Qualitywise Report
	SELECT suplier,quality,Colour,sum(netwt) netwt, sum(amt) amt;
    FROM yrnorder;
	WHERE date>=msdate .and. date<=medate;
	GROUP BY quality,Colour;
	ORDER BY quality,Colour;
	INTO CURSOR ynroderv2

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrnordqlty.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnordqlty.frx to printer prompt noconsole
Endcase

Endif
RETURN
