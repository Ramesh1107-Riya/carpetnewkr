*******White Issue for Dyeing Quality Summary
	SELECT Suplier,quality,colour,sum(quantity) quantity,sum(dyingload) dyingload;
    FROM carpet!yrnissdy;
	WHERE date>=msdate .and. date<=medate;
	GROUP BY Quality,Colour;
	ORDER BY Quality;
	INTO CURSOR yrdyeisq

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrdyeisq.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrdyeisq.frx to printer prompt noconsole
Endcase
Endif
