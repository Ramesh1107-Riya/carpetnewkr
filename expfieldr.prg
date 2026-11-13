Open Database Carpet
Do Case
Case (!empty(m.quality))  
	SELECT Fieldcode,Quality,Desc,Fldtype,RateNow,RateOld;
	FROM expfield; 
	WHERE  quality=alltrim(m.quality);
    ORDER BY quality,fldtype asc;
    INTO CURSOR temprepview 
Case (empty(m.quality))  
	SELECT Fieldcode,Quality,Desc,Fldtype,RateNow,RateOld;
	FROM expfield; 
	ORDER BY quality,fldtype asc;
	INTO CURSOR temprepview  
Endcase

Select temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form expfieldr.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form expfieldr.frx to printer prompt noconsole
Endcase
Endif
Return