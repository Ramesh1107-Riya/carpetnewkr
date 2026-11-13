SET DELETED ON
SET TALK OFF
SET SAFE OFF

SELECT i.DATE,i.BILLNO,i.QUALITY,i.PARTY,i.COLOUR,i.RATE,i.QUANTITY,i.AMT,i.OL_NO,j.design;
FROM WIRETURN i;
Join CABUYORD j;
ON i.OL_NO=j.OL_NO;
WHERE i.Billno=Alltrim(m.BillNo);
ORDER BY i.Quality,i.Colour;
INTO CURSOR RET1

SELECT RET1
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form wibillreturn.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport	
	Case m.PrnStat="P"
		Report form wibillreturn.frx to printer prompt noconsole
Endcase
Endif
RETURN
SET COLOR TO


