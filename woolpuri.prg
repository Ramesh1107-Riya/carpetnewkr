*******Wool Purchase Detail Report
Do Case
  Case !empty(m.suplier) && One Supplier
	SELECT *;
	FROM carpet!woolpu;
	WHERE date>=msdate .and. date<=medate;
	HAVING suplier=ALLTRIM(m.suplier);
	ORDER BY date,wqlty,wtype;
	INTO CURSOR wooltemp

  Case  empty(m.suplier)    && All Supplier
	SELECT *;
	FROM carpet!woolpu;
	WHERE date>=msdate .and. date<=medate;
	ORDER BY suplier,date,wqlty,wtype;
	INTO CURSOR wooltemp
Endcase

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		*Report form woolpuri.frx to console preview in screen
		Report form woolpuri.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form woolpuri.frx to printer prompt noconsole
Endcase
Endif

