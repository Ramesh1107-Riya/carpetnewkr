**Invoice USA & Others=> Detail Proform Invoice, Sq.Mtr, Sq.Ft
Set Exact on
Set Decimal to 2
Set date to british
Set Century on
Public mgtotal,gtotal,mtotalft,gtotalft
Store 0.0 to mgtotal,gtotal,mtotft
Private m.curntype,m.shipdesc,m.goodsdesc,m.DisExtDes,m.DisExtAmt
Store space(5) to m.curntype,m.shipdesc,m.goodsdescm,m.DisExtDes
m.DisExtAmt=0.0
m.DisExtDes=''
*****Header Data for Invoice************
Select *;
From expackingnp;
where Alltrim(invno)==Alltrim(m.invno);
Into cursor packdtl

***Amount in usd for Linear Feet added to mgtotal for words
Select packdtl
m.DisExtDes=packdtl->DisExtDes
m.DisExtAmt=packdtl->DisExtAmt
Dimension packdata (1,44)
Store ' ' to packdata
Select packdtl
copy to ARRAY packdata

Select curntype,shipdesc,goodsdesc;
From Invtran;
Where invno==Alltrim(m.invno);
Into Cursor Inv1

Select Inv1
m.curntype=Inv1->curntype
m.shipdesc=Inv1->shipdesc
m.goodsdesc=Inv1->goodsdesc

*QltyInv not used for Kamala Rug
Select Invno,carpetno,int(val(padr(1,1))) as Pcs,PO_NO,Alltrim(Quality)+'....'+Alltri(Matcomp) as Description,Sqmt,SqFt,;
			RateFeet,RateSqmt,br_feet,br_inch,ln_feet,ln_inch,Quality,Design,shipbrth,shiplngth;
FROM Packtran p;
Where alltrim(invno)==alltrim(m.invno);
Order by Carpetno;
Into Cursor Invoice1

*Group by Po_no,Rcode,Quality
*Order by PO_NO

Select Invno,carpetno,Pcs,po_no,Description,Sqmt,SqFt,Ratefeet,RateSqmt,Round((Sqmt*RateSqmt),2) as AmtSqmt,Round((SqFt*RateFeet),2) as Amtfeet,;
			br_feet,br_inch,ln_feet,ln_inch,Quality,Design,shipbrth,shiplngth;
From Invoice1;
Order by Carpetno;
Into Cursor Invoice

Select sum(Amtsqmt) as gtamtsqmt,sum(amtfeet) as gtamtFeet;
From Invoice;
Where invno==Alltrim(m.invno);
Group by invno;
Into Cursor InvTot

Select InvTot 
If  m.chk2=1
	gtotal=Round(InvTot.gtamtsqmt,2)
	mgtotal=Round(InvTot.gtamtsqmt,2)+m.DisExtAmt
else
	mtotalft=Round(InvTot.gtamtfeet,2)
	gtotalft=Round(InvTot.gtamtFeet,2)+m.DisExtAmt
	mgtotal=gtotalft && 24/8/2021 passing parameter to amtcal 
endif

************For getting 2 first Invno***********************************
Select Distinct Po_No;
From Invoice;
Order by Po_No;
Into Cursor InvPono

Dimension pono(2,1)
Store ' ' to pono
Select InvPono
copy to ARRAY pono
*************************************************************************
****Main Body Invoice Data*********
do amtcal
Select Invoice
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case  && Proform Invoice Feet 1,2
	Case m.PrnStat="V" .and. m.chk1=0 .and. m.chk2=0
		Report form InvUSAdPft1.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.chk1=0 .and. m.chk2=0
		Report form InvUSAdPft1.frx  to printer prompt noconsole
	Case m.PrnStat="V" .and. m.chk1=1 .and. m.chk2=0
		Report form InvUSAdPft2 PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.chk1=1 .and. m.chk2=0
		Report form InvUSAdPft2.frx to printer prompt noconsole
******** Proform Invoice In Mtr 1,2	
	Case m.PrnStat="V" .and. m.chk1=0 .and. m.chk2=1
		Report form InvUSAdPmt1.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.chk1=0 .and. m.chk2=1
		Report form InvUSAdPmt1.frx  to printer prompt noconsole
	Case m.PrnStat="V" .and. m.chk1=1 .and. m.chk2=1
		Report form InvUSAdPmt2 PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.chk1=1 .and. m.chk2=1
		Report form InvUSAdPmt2.frx to printer prompt noconsole
********
	Case m.PrnStat="S"
		EXPORT TO &exclfile TYPE XL5 FIELDS  Invno,Pcs,po_no,Description,Sqmt,rateusd,amtusd,SqFt,RateSqFeet,AmtFeet
			Messagebox("Successfuly converted Excel Format, open folder Carpetnew->Search For Excel File")
Endcase
use && for not display same result even if the value of m.Invno changed.
Endif
Return