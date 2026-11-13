*White Wool Opening 
	SELECT *;
    FROM Carpet!woolop;
	ORDER BY wqlty,wtype;
	INTO CURSOR woolop1

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form woolop.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form woolop.frx to printer prompt noconsole
Endcase
Endif
