SET DELETED ON
SET TALK OFF
SET SAFE OFF

*YrnIRsupvw1.View This done for Carpet Order Issue Date 14/11/2018 By Ramesh
*SELECT s.issdt,b.ol_no,b.bcode,s.supplier,b.design,b.colour,b.quality;
*FROM cabuyord b;
*JOIN casupord s;
*ON b.ol_no=s.ol_no;
*WHERE s.issdt<>{//};
*ORDER BY b.bcode,b.design,b.quality,b.colour;
*GROUP BY b.bcode,b.design,b.quality,b.colour;
*Into cursor ctmp2

*YrnIRsupvw2.View
*SELECT b.issdt,b.ol_no,b.bcode,b.supplier,b.design,y.caqlty,y.pno,y.quality,y.colour,y.ibillno,y.sissqty,y.sissdt,y.srate,y.rbillno,y.sretdt,y.sretqty,y.rackno;
*From ctmp2 b;
*RIGH JOIN Yrnissrecsup y;
*ON y.bcode=b.bcode .and. y.design=b.design .and. y.caqlty=b.quality .and. y.basecolour=b.colour;
*Into cursor cBilIss

****************additional in Issue Bill*****************
Select ibillno,cotqlty,cotkg,cotrate,cotamt,rollingamt;
From yrnbilliss;
Where Ibillno=Alltrim(m.Billno);
Into Cursor cIbil
Select cIbil
Dimension ibil(1,6)
ibil(1,1)=''
ibil(1,2)=''
ibil(1,3)=0
ibil(1,4)=0
ibil(1,5)=0
ibil(1,6)=0

SELECT cIbil
COPY TO ARRAY ibil
******************************************************************

*If RECNO()>RECCOUNT()
	SELECT SISSDT,IBILLNO,QUALITY,SUPPLIER,COLOUR,SRATE,SISSQTY,SRATE*SISSQTY AS AMT,CARPETNO AS OL_NO;
	FROM Yrnissrecsup;
	WHERE IBillno=Alltrim(m.BillNo);
	ORDER BY Quality,Colour;
	INTO CURSOR ISS1
*Else
*	SELECT SISSDT,IBILLNO,QUALITY,SUPPLIER,COLOUR,SRATE,SISSQTY,SRATE*SISSQTY AS AMT,OL_NO;
*	FROM cBilIss b,cIbil i;
*	WHERE IBillno=i.Ibillno .and. IBillno=Alltrim(m.BillNo);
*	ORDER BY Quality,Colour;
*	INTO CURSOR ISS1
*Endif
	
SELECT ISS1
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form syissbill.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport	
	Case m.PrnStat="P"
		Report form syissbill.frx to printer prompt noconsole
Endcase
Endif
RETURN


