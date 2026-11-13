*Estimated Shipping  Date On Time/ Late Report, Today Date - Est. Shipping Date
SET PROCEDURE TO Catool
DO csTrimInfo5      && Trim Information for Check Purpose !
Open Database Carpet

Do Case
  Case m.allweave=.T.
	CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, s.WEAVER, b.ORDER_TYPE, s.CARD_NO, b.QUALITY, b.DESIGN, b.COLOUR, b.SZCODE, s.FDATE,;
			 b.SQMT, b.OL_NO, s.ESTSHIP_DT, m.Text2-s.ESTSHIP_DT NODAY, b.PO_NO, s.CARPETNO, b.DELIRY_DT, b.CSTATUS, s.GRADE; 
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.ESTSHIP_DT) .and. CSTATUS<>'Exported';  
	HAVING s.ESTSHIP_DT>=m.Text1 .and. s.ESTSHIP_DT<=m.Text2
	
  Case m.posweave=.T.  && we have -ve value adjusted on 17/03/2011 due to comment +VE MORE LATE, -VE FOR BEFORE
	CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, s.WEAVER, b.ORDER_TYPE, s.CARD_NO, b.QUALITY, b.DESIGN, b.COLOUR, b.SZCODE, s.FDATE,;
			 b.SQMT, b.OL_NO, s.ESTSHIP_DT, m.Text2-s.ESTSHIP_DT NODAY, b.PO_NO, s.CARPETNO, b.DELIRY_DT, b.CSTATUS, s.GRADE; 	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.ESTSHIP_DT) .and. CSTATUS<>'Exported'; 
	HAVING s.ESTSHIP_DT>=m.Text1 .and. s.ESTSHIP_DT<=m.Text2 .and. NODAY<0

 Case  m.negweave=.T. && we have +ve value adjusted on 17/03/2011 due to comment  +VE MORE LATE, -VE FOR BEFORE
	CREATE SQL VIEW temprepview1 AS SELECT b.BCODE, s.WEAVER, b.ORDER_TYPE, s.CARD_NO, b.QUALITY, b.DESIGN, b.COLOUR, b.SZCODE, s.FDATE,;
				 b.SQMT, b.OL_NO, s.ESTSHIP_DT, m.Text2-s.ESTSHIP_DT NODAY, b.PO_NO, s.CARPETNO, b.DELIRY_DT, b.CSTATUS, s.GRADE; 	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.ESTSHIP_DT) .and. CSTATUS<>'Exported';
	HAVING s.ESTSHIP_DT>=m.Text1 .and. s.ESTSHIP_DT<=m.Text2 .and. NODAY>=0
Endcase	

CREATE SQL VIEW temprepview AS SELECT *;
FROM Carpet!temprepview1;
WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes, Order_Type);
ORDER BY BCODE,WEAVER,ESTSHIP_DT,OL_NO ASC
	
USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form rEstShipDt.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form rEstShipDt.frx to printer prompt noconsole
	Case  m.PrnStat="E" 
  		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,PO_NO,WEAVER,CARPETNO,CARD_NO,DESIGN,COLOUR,SZCODE,SQMT,DELIRY_DT,FDATE,CSTATUS,NODAY
		Messagebox("Estimated Shipping List Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Otherwise
		Messagebox("Invalid choice, make correct Choice!!")
Endcase
Endif
Return