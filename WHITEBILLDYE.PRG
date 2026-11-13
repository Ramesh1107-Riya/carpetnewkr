SET DELETED ON
SET TALK OFF
SET SAFE OFF

SELECT DATE,BILLNO,QUALITY,REMARK,Suplier,COLOUR,QUANTITY;
FROM Yrnissdy;
WHERE Billno=Alltrim(m.BillNo);
ORDER BY Quality,Colour;
INTO CURSOR ISS1

SELECT ISS1
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form WhiteBillDye.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport	
	Case m.PrnStat="P"
		Report form WhiteBillDye.frx to printer prompt noconsole
Endcase
Endif
RETURN


