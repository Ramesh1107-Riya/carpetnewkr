SET DELETED ON
SET TALK OFF
SET SAFE OFF

*YrnIRsupvw1.View
SELECT s.issdt,b.ol_no,b.bcode,s.supplier,b.design,b.colour,b.quality;
FROM cabuyord b;
JOIN casupord s;
ON b.ol_no=s.ol_no;
WHERE s.issdt<>{//} ;
ORDER BY b.bcode,b.design,b.quality,b.colour;
GROUP BY b.bcode,b.design,b.quality,b.colour;
Into cursor ctmp2

*YrnIRsupvw2.View
SELECT b.issdt,b.ol_no,b.bcode,b.supplier,b.design,y.caqlty,y.pno,y.quality,y.colour,y.ibillno,y.sissqty,y.sissdt,y.srate,y.rbillno,y.sretdt,y.sretqty,y.rackno;
From ctmp2 b;
RIGH JOIN yrnchtran y;
ON y.bcode=b.bcode .and. y.design=b.design .and. y.caqlty=b.quality .and. y.basecolour=b.colour;
Into cursor cBilIss

SELECT SRETDT,RBILLNO,QUALITY,SUPPLIER,COLOUR,SRATE,SRETQTY,SRATE*SRETQTY AS AMT,OL_NO;
FROM cBilIss;
WHERE RBillno=Alltrim(m.BillNo);
ORDER BY Quality,Colour;
INTO CURSOR RET1

SELECT RET1
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form syretbill.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport	
	Case m.PrnStat="P"
		Report form syretbill.frx to printer prompt noconsole
Endcase
Endif
RETURN


