*******White Issue for Dyeing Detail report
Do Case
  Case !empty(m.suplier) && One Supplier
	SELECT *;
	FROM carpet!yrnissdy;
	WHERE date>=msdate .and. date<=medate;
	HAVING suplier=ALLTRIM(m.suplier);
	ORDER BY Billno,date,quality,colour;
	INTO CURSOR yarntodye

  Case  empty(m.suplier)    && All Supplier
	SELECT *;
	FROM carpet!yrnissdy;
	WHERE date>=msdate .and. date<=medate;
	ORDER BY Billno,Date,Quality,Colour;
	INTO CURSOR yarntodye
Endcase
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		*Report form yrdyeisd.frx to console preview in screen
		Report form yrdyeisd.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P"
		Report form yrdyeisd.frx to printer prompt noconsole
Endcase
Endif
