*******Raw Material Detail Report
Do Case
  Case !empty(m.suplier) && One Supplier
	SELECT *;
	FROM yrnorder;
	WHERE date>=msdate .and. date<=medate;
	HAVING suplier=ALLTRIM(m.suplier);
	ORDER BY date,rono;
	INTO CURSOR yrnorderv

  Case  empty(m.suplier)    && All Supplier
  	SELECT *;
	FROM yrnorder;
	WHERE date>=msdate .and. date<=medate;
	ORDER BY date,rono;
	INTO CURSOR yrnorderv
Endcase

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		REPORT FORM yrnordetail.frx PREVIEW WINDOW wReport 
		*Report form yrnorderd.frx to console preview in screen
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnordetail.frx to printer prompt noconsole
Endcase
Endif


