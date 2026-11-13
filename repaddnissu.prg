SET DELETED ON
SET TALK OFF
SET SAFE OFF

SELECT ol_no,party,date,billno,quality,colour,quantity,rate,amt;
FROM Wiissue;
WHERE ol_no=Alltrim(m.ol_no);
ORDER BY Quality,Colour;
INTO CURSOR ISS2

SELECT ISS2
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form repaddnissu.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport	
	Case m.PrnStat="P"
		Report form repaddnissu.frx to printer prompt noconsole
	Case  m.PrnStat="E" 
	 EXPORT TO &exclfile TYPE XL5 FIELDS  ol_no,party,date,billno,quality,colour,quantity,rate,amt
   	 Messagebox("Additional Dyeing Issue Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 		
Endcase
Endif
RETURN


