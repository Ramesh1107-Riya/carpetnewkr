*******Wool Issue Detail Report
Do Case
  Case !empty(m.suplier) && One Supplier
	SELECT *;
	FROM carpet!woolissu;
	WHERE issdt>=msdate .and. issdt<=medate;
	HAVING suplier=ALLTRIM(m.suplier);
	ORDER BY issdt,quality;
	INTO CURSOR wooltempi

  Case  empty(m.suplier)    && All Supplier
  	SELECT *;
	FROM carpet!woolissu;
	WHERE issdt>=msdate .and. issdt<=medate;
	ORDER BY suplier,issdt,quality;
	INTO CURSOR wooltempi
Endcase
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		*Report form woolisi.frx to console preview in screen
		Report form woolisi.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form woolisi.frx to printer prompt noconsole
Endcase
Endif
