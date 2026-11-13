**Invoice High ,Rate1 to Rate22, amt1 to amt22
Set Exact on
Set Decimal to 2
Set date to british
Set Century on
Public mgtotal,gtotal
Store 0.0 to mgtotal,gtotal
Private m.curntype,m.shipdesc,m.goodsdesc,m.linftusd,m.amtlinftusd,m.amtlinftusd1,m.DisExtDes,m.DisExtAmt
Store space(5) to m.curntype,m.shipdesc,m.goodsdescm,m.DisExtDes
m.DisExtAmt=0.0
m.linftusd=0.0
m.amtlinftusd1=0.0
m.amtlinftusd=0.0
*****Header Data for Invoice************
Select *;
From expackingnp;
where Alltrim(invno)=Alltrim(m.invno);
Into cursor packdtl

***Amount in usd for Linear Feet added to mgtotal for words
Select packdtl
m.linftusd=packdtl->ratenpr/packdtl->exchngrate
m.amtlinftusd=packdtl->linfeet*Round(m.linftusd,2)
m.DisExtDes=packdtl->DisExtDes
m.DisExtAmt=packdtl->DisExtAmt
***********************************
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

Select Invno,Pcs,PO_NO,Alltrim(Design)+' '+Alltrim(Quality)+' '+Alltri(Desc) as Description,Sqmt,Ratenpr,Exchngrate,ExchngDt,Round((Ratenpr/Exchngrate),2) as rateusd;
From Invdata;
Where invno=Alltrim(m.invno);
Into Cursor Invoice1

*Round((Sqmt*rateusd),2)
Select Invno,Pcs,po_no,Description,Sqmt,Ratenpr,Exchngrate,ExchngDt,rateusd,Round((Sqmt*rateusd),2) as amtusd;
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
mgtotal=Round(InvTot.gtamtusd,2)+Round(m.amtlinftusd,2)+m.DisExtAmt
****Main Body Invoice Data*********
do amtcal
Select Invoice

SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.chk1=0
		Report form invoiceeu.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.chk1=0
		Report form invoiceeu.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.chk1=1
		Report form invoiceeu1.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.chk1=0
		Report form invoiceeu1.frx to printer prompt noconsole
	Case m.PrnStat="S"
		EXPORT TO &exclfile TYPE XL5 FIELDS  Invno,Pcs,po_no,Description,Sqmt,Ratenpr,Exchngrate,rateusd,amtusd
			Messagebox("Successfuly converted Excel Format, open folder Carpetnew->Search For Excel File")
Endcase
use && for not display same result even if the value of m.Invno changed.
Endif
Return