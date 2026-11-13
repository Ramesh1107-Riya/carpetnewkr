*White Yarn Opening Report Supplierwise 
	SELECT *;
    FROM Carpet!yrnop;
	ORDER BY Quality;
	INTO CURSOR wyarnop

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrnop.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnop.frx to printer prompt noconsole
Endcase
Endif
