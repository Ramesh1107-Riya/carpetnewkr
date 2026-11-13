**Invoice Others Commercial for Gyaltsen Rug Industries
Set Exact on
Set Decimal to 2
Set date to british
Set Century on

Public mgtotal,gtotal
Store 0.0 to mgtotal,gtotal
Private m.curntype,m.shipdesc,m.goodsdesc,m.DisExtDes,m.DisExtAmt
Store space(5) to m.curntype,m.shipdesc,m.goodsdescm,m.DisExtDes
m.DisExtAmt=0.0
m.DisExtDes=''
*****Header Data for Invoice************
Select *;
From expackingnp;
where Alltrim(invno)=Alltrim(m.invno);
Into cursor packdtl

***Amount in usd for Linear Feet added to mgtotal for words
Select packdtl
m.DisExtDes=packdtl->DisExtDes
m.DisExtAmt=packdtl->DisExtAmt

Dimension packdata (1,35)
Store ' ' to packdata
Select packdtl
copy to ARRAY packdata

Select curntype,shipdesc,goodsdesc;
From Invtran;
Where invno=Alltrim(m.invno);
Into Cursor Inv1

Select Inv1
m.curntype=Inv1->curntype
m.shipdesc=Inv1->shipdesc
m.goodsdesc=Inv1->goodsdesc

Select Invno,Carpetno,Pcs,PO_NO,Alltrim(Design)+' '+Alltrim(Quality)+' '+Alltri(Desc) as Description,Sqmt,Ratedollar as rateusd;
From Invdata;
Where invno=Alltrim(m.invno);
Into Cursor Invoice1

*Round((Sqmt*rateusd),2)
Select Invno,Carpetno,Pcs,po_no,Description,Sqmt,rateusd,Round((Sqmt*rateusd),2) as amtusd;
From Invoice1;
Order by Po_no;
Into Cursor Invoice

Select sum(amtusd) as gtamtusd;
From Invoice;
Where invno=Alltrim(m.invno);
Group by invno;
Into Cursor InvTot

Select InvTot
gtotal=Round(InvTot.gtamtusd,2)
mgtotal=Round(InvTot.gtamtusd,2)+m.DisExtAmt
****Main Body Invoice Data********************************************************
do amtcal

***17-1-2020**Added for Gyaltsen Rug Industry***
SELECT i.Pcs,i.po_no,i.Sqmt,i.rateusd,i.amtusd,p.Invno,p.carpetno,p.design,p.quality,p.baleno,p.shipbrth,p.shiplngth,int(val(padr(1,1))) as qty;
FROM Invoice i;
Join packtran p;
On i.Carpetno=p.Carpetno;
Where i.Invno=alltrim(m.Invno);
Into Cursor Invoicegri

Select Invoicegri
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form invoicecgrinc.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form invoicecgrinc.frx to printer prompt noconsole
	Case m.PrnStat="S"
		Select Baleno,Design,po_no,po_dt,carpetno,quality,szcode,sqmt;
		From Packtran;
		where invno=m.invno;
		into cursor packt1

		Select packt1
		EXPORT TO &exclfile TYPE XL5 FIELDS Baleno,Design,po_no,po_dt,carpetno,qty,quality,szcode,sqmt
			Messagebox("Successfuly converted Excel Format, open folder Carpetnew->Search For Excel File")
Endcase
*use && for not display same result even if the value of m.Invno changed.
Endif
Return