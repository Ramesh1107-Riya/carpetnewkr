*******Raw Material Detail Report
Do Case
  Case !empty(m.suplier) .and. !empty(m.recno) && One Supplier one billno
	SELECT *;
	FROM Yrnrecvd;
	WHERE recdt>=msdate .and. recdt<=medate; 
	HAVING suplier=ALLTRIM(m.suplier) .and. recno=m.recno;
	ORDER BY recdt,recno;
	INTO CURSOR yrnorderv2

*****for company name 28/08/2025********
	SELECT i.*,j.compname;
	FROM yrnorderv2 i, casupplr j;
	WHERE ALLTRIM(i.suplier)=ALLTRIM(j.code);
	INTO CURSOR yrnorderv

	Otherwise	
  		Messagebox("Please Enter Bill No. & Supplier Name for Printing Bill !")
  		return
Endcase


Select yrnorderv
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
	IF yrnorderv.VATPER>0
		SET COLOR TO
		Do Case
			Case m.PrnStat="V"
				REPORT FORM yrnpurbillv.frx PREVIEW WINDOW wReport 
				*Report form yrnorderd.frx to console preview in screen
				DEACTIVATE WINDOW wReport
			Case m.PrnStat="P"
				Report form yrnpurbillv.frx to printer prompt noconsole
		Endcase
	ELSE
		Do Case
			Case m.PrnStat="V"
				REPORT FORM yrnpurbill.frx PREVIEW WINDOW wReport 
				*Report form yrnorderd.frx to console preview in screen
				DEACTIVATE WINDOW wReport
			Case m.PrnStat="P"
				Report form yrnpurbill.frx to printer prompt noconsole
		Endcase
	ENDIF
Endif


