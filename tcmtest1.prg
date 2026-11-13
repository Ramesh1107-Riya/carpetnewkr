Local m.ol_no
m.ol_no='190899/02922'


Local m.po_no
Select po_no,ol_no;
From Cabuyord;
Where ol_no=m.ol_no;
Into cursor cpono

Select cpono
m.po_no=cpono->po_no

***Do to keep Design Field size, Quality Field size as .dbf***
SELECT s.issdt,b.ol_no,b.bcode,s.supplier,b.TrimLast2,LEN(alltrim(b.Design)) AS LEN2,b.DESIGN,b.colour,b.quality,b.po_no,b.qty,b.sqmt,b.szcode,b.estdt;
FROM cabuyord b;
JOIN casupord s;
ON b.ol_no=s.ol_no;
Where b.po_no=m.po_no;
Into cursor ctmp3a

*We are sorting for hightest Len first, ALTERNATE DHARI 2 4 S,ALTERNATE DHARI 2 S, TO GET higher LEN first, if lower len take, both give result ALTERNATE DHARI 2
SELECT issdt,ol_no,po_no,bcode,len2,supplier,Design,qty,sqmt,szcode,colour,quality,estdt,TrimLast2;
From ctmp3a;
order by len2 desc;
Into Cursor ctmp3i 
select ctmp3i
brow

SELECT issdt,ol_no,po_no,bcode,supplier,iif(Trimlast2=.T.,SUBSTR(DESIGN,1,LEN2-2),Design) AS Design,qty,sqmt,szcode,colour,quality,estdt;
From ctmp3i ;
Into cursor ctmp3b

select ctmp3i
brow

SELECT issdt,ol_no,po_no,bcode,supplier,Design,sum(qty) as qty,sum(sqmt) as sqmt,szcode,colour,quality,estdt;
From ctmp3b;
GROUP BY bcode,design,quality,colour,supplier,issdt;
ORDER BY bcode,design,quality,colour,supplier,issdt;
Where ol_no=m.ol_no;
Into cursor ctmp3

select ctmp3
brow
*Group BY bcode,design,quality,colour,supplier;

Select *;
From Yrnissrecsup;
Where carpetno=m.ol_no;
Into Cursor Yissrecp
Select Yissrecp
brow

*abillno,aquantity,arate,aamt is added in yrnissrecsup for report of Additinal quantity from wiissue 29/7/2018
SELECT b.issdt,b.ol_no,b.po_no,b.bcode,b.supplier,b.Design,b.qty,b.sqmt,y.caqlty,y.quality,y.colour,y.ibillno,y.sissqty,y.sissdt,y.srate,y.sissqty*y.srate as iamt,;
   y.rbillno,y.sretdt,y.sretqty,y.rackno,y.srate*y.sretqty as ramt,b.szcode,y.basecolour,y.abillno,y.aquantity,y.adate,y.aamt,y.pno;
From ctmp3 b;
JOIN Yissrecp y;
ON y.bcode=b.bcode .and. y.design=b.design .and. y.caqlty=b.quality .and. y.basecolour=b.colour .and. y.supplier=b.supplier;
Where b.ol_no=m.ol_no;
Into cursor tempsupa
SELECT TEMPSUPA
BROW

SELECT issdt,ol_no,po_no,bcode,supplier,Design,qty,sqmt,caqlty,quality,colour,ibillno,sum(sissqty) as sissqty,sissdt,srate,sum(iamt) as iamt,;
   rbillno,sretdt,sretqty,rackno,sum(ramt) as ramt,szcode,basecolour,abillno,aquantity,adate,aamt,pno;
From tempsupa;
GROUP BY quality,colour;
Into cursor tempsup

select tempsup
brow
