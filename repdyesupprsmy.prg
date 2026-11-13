*Supplier Production carpet Multipel pcs
SET DELETED ON
*SET PROCEDURE TO Catool 
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

Local m.po_no
*DO csTrimInfo11      && Trim Information for Check Purpose !
*Open Database Carpet

Select po_no,ol_no;
From Cabuyord;
Where ol_no=m.ol_no;
Into cursor cpono

Select cpono
m.po_no=cpono->po_no

SELECT s.issdt,b.ol_no,b.bcode,s.supplier,b.TrimLast2,LEN(alltrim(b.Design)) AS LEN2,b.design,b.colour,b.quality,b.po_no,b.qty,b.sqmt,b.szcode,b.estdt;
FROM cabuyord b;
JOIN casupord s;
ON b.ol_no=s.ol_no;
Where b.po_no=m.po_no;
Order by b.ol_no;
Into cursor ctmp3a

*We are sorting for hightest Len first, ALTERNATE DHARI 2 4 S,ALTERNATE DHARI 2 S, TO GET higher LEN first, if lower len take, both give result ALTERNATE DHARI 2
SELECT issdt,ol_no,po_no,bcode,len2,supplier,Design,qty,sqmt,szcode,colour,quality,estdt,TrimLast2;
From ctmp3a;
order by len2 desc;
Into Cursor ctmp3i 

SELECT issdt,ol_no,po_no,bcode,supplier,iif(Trimlast2=.T.,SUBSTR(DESIGN,1,LEN2-2),Design) AS Design,qty,sqmt,szcode,colour,quality,estdt;
From ctmp3i ;
order by ol_no;
Into cursor ctmp3b

SELECT issdt,ol_no,po_no,bcode,supplier,Design,sum(qty) as qty,sum(sqmt) as sqmt,szcode,colour,quality,estdt;
From ctmp3b;
GROUP BY ol_no;
ORDER BY ol_no;
Into cursor ctmp3c

*2/7/2020
*GROUP BY bcode,design,quality,colour,supplier,issdt
*ORDER BY bcode,design,quality,colour,supplier,issdt
******************18/1/2019 modified***************
SELECT issdt,ol_no,po_no,bcode,supplier,Design,qty,sqmt,szcode,colour,quality,estdt;
From ctmp3c;
Where ol_no=m.ol_no;
Into cursor ctmp3

Select *;
From Yrnissrecsup;
Where carpetno=ctmp3->ol_no; && Where carpetno=m.ol_no 18/1/2020
Into Cursor Yissrecp

*abillno,aquantity,arate,aamt is added in yrnissrecsup for report of Additinal quantity from wiissue 29/7/2018
SELECT b.issdt,b.ol_no,b.po_no,b.bcode,b.supplier,b.Design,y.qty,y.sqmt,y.caqlty,y.quality,y.colour,y.ibillno,y.sissqty,y.sissdt,y.srate,y.sissqty*y.srate as iamt,;
   y.rbillno,y.sretdt,y.sretqty,y.rackno,y.srate*y.sretqty as ramt,b.szcode,y.basecolour,y.abillno,y.aquantity,y.adate,y.aamt,y.pno;
From ctmp3 b;
JOIN Yissrecp y;
ON y.carpetno=b.ol_no;
Into cursor tempsupa

*25/1/2021 Ramesh changed for above
*ON y.bcode=b.bcode .and. y.design=b.design .and. y.caqlty=b.quality .and. y.basecolour=b.colour 

SELECT issdt,ol_no,po_no,bcode,supplier,Design,qty,sqmt,caqlty,quality,colour,ibillno,sum(sissqty) as sissqty,sissdt,srate,sum(iamt) as iamt,;
   rbillno,sretdt,sum(sretqty) as sretqty,rackno,sum(ramt) as ramt,szcode,basecolour,abillno,sum(aquantity) as aquantity,adate,sum(aamt) as aamt,pno;
From tempsupa;
Group by pno,quality,colour;
Into cursor tempsup

*Add wiissue,ol_no,quality,colour,date,quantity,rate,amt (Relation on ol_No)
****************additional in Issue Bill***
Local m.ibillno
Select dist ibillno;
From tempsup;
Where !empty(ibillno);
Into cursor cibill
select cibill
m.ibillno=cibill->ibillno

Select distinct ibillno,cotqlty,cotkg,cotrate,cotamt,rollingamt;
From yrnbilliss;
Where Alltrim(Ibillno)=Alltrim(m.iBillno);
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
*******************eof issue bill*********
***************Additional Return Bill*****
Local m.rBillno
Select dist rbillno;
From tempsup;
Where !empty(rbillno);
Into cursor crbill
select crbill
m.rBillno=crbill->rbillno

Select Distinct rbillno,trillamt-twil_Amt as trillamt,dyeamt,cotkg,cotamt,remark;
From yrnbillret;
Where alltrim(rbillno)=Alltrim(m.rBillno);
Into Cursor cRbil
Select cRbil
Dimension Rbil(1,6)
rbil(1,1)=''
rbil(1,2)=0
rbil(1,3)=0
rbil(1,4)=0
rbil(1,5)=0
rbil(1,6)=0
SELECT cRbil
COPY TO ARRAY Rbil
*************eof return bill**************

USE (DBF([Tempsup])) ALIAS YrnIRSup AGAIN IN 0 SHARED
USE IN SELECT([Tempsup])

SELECT YrnIRSup
INDEX ON OL_NO+Quality+Colour   TAG QlColOl
SET ORDER TO QlColOl

*****updating wiissue**************
SELECT ol_no,colour,quality,pno,billno,sum(quantity) as quantity,date,sum(amt) as amt;
From wiissue i;
Where ol_no=m.ol_no;
Group by pno,quality,colour;  && in place of quality, colour added 18/12/2019
Into cursor cWiis
*********************************
select cWiis && values come FROM this table 
do while .not. eof()
update  YrnIRSup ;
set abillno=cWiis.billno,aquantity=cWiis.quantity,adate=cWiis.date,aamt=cWiis.Amt;
Where YrnIRSup.ol_no=cWiis.ol_no .and. YrnIRSup.quality=cWiis.Quality .and. YrnIRSup.colour=cWiis.Colour .and. YrnIRSup.pno=cWiis.pno
	Select cWiis
	If .not. eof()
		skip
	Endif
enddo
USE IN cWiis
*Where YrnIRSup.ol_no=cWiis.ol_no .and. YrnIRSup.quality=cWiis.Quality .and. YrnIRSup.colour=cWiis.Colour .and. YrnIRSup.pno=cWiis.pno 18/12/2019

SELECT issdt,ol_no,po_no,bcode,supplier,Design,qty,sqmt,caqlty,quality,colour,ibillno,sum(sissqty) as sissqty,sissdt,srate,sum(iamt) as iamt,;
   rbillno,sretdt,sum(sretqty) as sretqty,rackno,sum(ramt) as ramt,szcode,basecolour,abillno,sum(aquantity) as aquantity,adate,sum(aamt) as aamt,pno;
From YrnIRSup;
Where !empty(ibillno);
Group by quality;
Into cursor YrnIRSup1

*SELECT tempsup
Select YrnIRSup1
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repdyesuprsmy.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repdyesuprsmy.frx to printer prompt noconsole
Endcase
Endif
USE IN YrnIRSup 
UNLOCK ALL

Return
