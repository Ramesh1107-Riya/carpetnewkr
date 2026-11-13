**Int. Supplier Yarn Opening for Expectation
	SELECT *;
    FROM Carpet!yrsupop;
	ORDER BY Quality;
	INTO CURSOR yrsupoprep

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrsupop.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnop.frx to printer prompt noconsole
Endcase
Endif
