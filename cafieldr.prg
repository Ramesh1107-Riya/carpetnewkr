Open Database Carpet
Do Case
Case (!empty(m.quality))  
	CREATE SQL VIEW temprepview AS SELECT *;
	FROM cafield; 
	WHERE  quality=alltrim(m.quality);
    ORDER BY quality,fldtype asc  
Case (empty(m.quality))  
	CREATE SQL VIEW temprepview AS SELECT *;
	FROM cafield; 
	ORDER BY quality,fldtype asc  
Endcase

USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form cafieldr.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form cafieldr.frx to printer prompt noconsole
Endcase
Endif
Return