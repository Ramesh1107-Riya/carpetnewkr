Set Date to Briti
Set Century on
SET ANSI ON

Open Database Carpet

	CREATE SQL VIEW temprepview AS SELECT *;
	FROM casize; 
	ORDER BY szcode ASC

USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form casizer.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form casizer.frx to printer prompt noconsole
Endcase
Endif
Return