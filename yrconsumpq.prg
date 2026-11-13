***Yarn Consumption Detail report Qualitywise
Do Case 
 Case !empty(m.Quality) && One Quality
 	Select i.Quality,i.Colour,sum(i.quantity) IQuantity,sum(r.quantity) RQuantity;
	FROM wiissue i LEFT OUTER JOIN wireturn r;
	ON r.Quality=i.Quality .and. r.Colour=i.Colour;
	WHERE i.date>=msdate .and. i.date<=medate;
	HAVING i.Quality=ALLTRIM(m.Quality);
	GROUP BY i.Quality,i.Colour;
	ORDER BY i.Quality,i.Colour;
	INTO CURSOR consump
	
 Case empty(m.Quality) && All Quality
 	Select i.Quality,i.Colour,sum(i.quantity) IQuantity,sum(r.quantity) RQuantity;
	FROM wiissue i LEFT OUTER JOIN wireturn r;
	ON r.Quality=i.Quality .and. r.Colour=i.Colour;
	WHERE i.date>=msdate .and. i.date<=medate;
	GROUP BY i.Quality,i.Colour;
	ORDER BY i.Quality,i.Colour;
	INTO CURSOR consump
Endcase
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		*Report form yrdyeisd.frx to console preview in screen
		Report form Yrconsumpq.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P"
		Report form Yrconsumpq.frx to printer prompt noconsole
Endcase
Endif
