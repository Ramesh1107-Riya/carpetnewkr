*******Raw Material Detail Report
Do Case
  Case !empty(m.suplier) && One Supplier
	SELECT *;
	FROM yrnrecvd;
	WHERE Recdt>=msdate .and. Recdt<=medate;
	HAVING suplier=ALLTRIM(m.suplier);
	ORDER BY Recdt,rono;
	INTO CURSOR yrnrecv

  Case  empty(m.suplier)    && All Supplier
  	SELECT *;
	FROM yrnrecvd;
	WHERE Recdt>=msdate .and. Recdt<=medate;
	ORDER BY Recdt,rono;
	INTO CURSOR yrnrecv
Endcase

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		REPORT FORM yrnpurdtl.frx PREVIEW WINDOW wReport 
		*Report form yrnorderd.frx to console preview in screen
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnpurdtl.frx to printer prompt noconsole
Endcase
Endif


