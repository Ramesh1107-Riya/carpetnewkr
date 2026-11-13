* All three basically same, packtran related for exported
*1*[] Current Balance [Not Exported] 
*2*[] Expoted Only
**Enter Po_dt From[     ] to po_dt [    ]

*PO_DT,YRNCALDT AS BUY_DELIDT,
*DELIRY_DT AS SUP_ESTDT,
*YRNCALDT-PO_DT AS BUY_DELIDAY,
*YRNCALDT-DATE() AS REMAINDAY,
*(YRNCALDT-PO_DT)-(YRNCALDT-DATE()) AS PASSDAY;

SET DELETED ON
Set talk off
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

SET PROCEDURE TO CATOOL
DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

Do Case
	Case m.Option="A" 
*1*[] Current Balance [No Exported only]
Select i.PO_NO,i.BCODE,i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.SZCODE,i.WashType,i.spcl_inst,i.notes,i.skuno,i.comment,i.packno,i.po_dt,i.cstatus,i.breadth,;
i.length,i.sqmt,i.yrncaldt as buy_delidt,i.deliry_dt as sup_estdt,b.wev_last_dt as wevlastdt,b.fdate,b.issdt,b.issdtwash,b.rcddtwash,b.supplier,;
i.yrncaldt-i.po_dt as buy_delday,b.wev_last_dt-b.issdt as weverday,b.issdt-i.po_dt as yarnday,b.fdate-b.issdt as wevday,b.issdtwash-b.fdate as cutday,;
b.rcddtwash-b.issdtwash as washday,iif(!empty(b.rcddtwash),date()-b.rcddtwash,00.00) as pkday;
From cabuyord i;
Join casupord b;
On i.ol_no=b.ol_no;
Where i.cstatus<>"Exported" .and.  PO_DT>=m.Startdt .and. PO_DT<=m.Enddt .and. !empty(b.fdate);
Into table Tempb

Select PO_NO,BCODE,OL_NO,QUALITY,DESIGN,COLOUR,SZCODE,WashType,spcl_inst,notes,skuno,comment,cstatus,packno,breadth,length,sqmt,buy_delidt,sup_estdt,po_dt,wevlastdt,;
issdt,fdate,supplier,issdtwash,rcddtwash,buy_delday,weverday,yarnday,wevday,cutday,washday,pkday,;
(iif(yarnday>0,yarnday,0)+iif(wevday>0,wevday,0)+iif(cutday>0,cutday,0)+iif(washday>0,washday,0)+iif(pkday>0,pkday,0)) as totalday,;
(iif(yarnday>0,yarnday,0)+iif(wevday>0,wevday,0)+iif(cutday>0,cutday,0)+iif(washday>0,washday,0)+iif(pkday>0,pkday,0))-buy_delday as BuyLate;
From Tempb;
Order by po_no,ol_no;
Into table Temp

************************************************
	Case m.Option="B"
*2*[] Current Balance [Yes Eported only] *********Here Packtran table added***************
Select i.PO_NO,i.BCODE, i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.SZCODE,i.WashType,i.spcl_inst,i.notes,i.skuno,i.comment,i.packno,i.cstatus,i.breadth,i.length,i.sqmt,;
i.po_dt,i.yrncaldt as buy_delidt,i.deliry_dt as sup_estdt,b.wev_last_dt as wevlastdt,b.fdate,b.issdt,b.issdtwash,b.rcddtwash,b.supplier,;
i.yrncaldt-i.po_dt as buy_delday,b.wev_last_dt-b.issdt as weverday,b.issdt-i.po_dt as yarnday,b.fdate-b.issdt as wevday,b.issdtwash-b.fdate as cutday,;
b.rcddtwash-b.issdtwash as washday;
From cabuyord i;
Join casupord b;
On i.ol_no=b.ol_no;
Where i.PO_DT>=m.Startdt .and. i.PO_DT<=m.Enddt .and. i.cstatus=="Exported";
Into Cursor CabuSup

Select i.PO_NO, i.BCODE, i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.SZCODE,i.WashType,i.supplier,i.spcl_inst,i.notes,i.skuno,i.comment,i.cstatus,i.breadth,i.length,;
i.sqmt,i.po_dt,b.invno,b.expdt,i.packno,i.buy_delidt,i.sup_estdt,i.wevlastdt,i.issdt,i.fdate,i.issdtwash,i.rcddtwash,i.buy_delday,i.cutday,i.weverday,i.yarnday,;
i.wevday,i.washday,b.expdt-i.rcddtwash as pkday;
From CabuSup i;
Inner Join Packtran b;
On i.ol_no=b.ol_no;
Into table Tempa

Select PO_NO,BCODE,OL_NO,QUALITY,DESIGN,COLOUR,SZCODE,WashType,spcl_inst,notes,skuno,comment,cstatus,packno,breadth,length,sqmt,buy_delidt,sup_estdt,po_dt,wevlastdt,;
issdt,fdate,supplier,issdtwash,rcddtwash,buy_delday,weverday,yarnday,wevday,cutday,washday,pkday,expdt,;
(iif(yarnday>0,yarnday,0)+iif(wevday>0,wevday,0)+iif(cutday>0,cutday,0)+iif(washday>0,washday,0)+iif(pkday>0,pkday,0)) as totalday,;
(iif(yarnday>0,yarnday,0)+iif(wevday>0,wevday,0)+iif(cutday>0,cutday,0)+iif(washday>0,washday,0)+iif(pkday>0,pkday,0))-buy_delday as BuyLate;
From Tempa;
Order by po_no,ol_no;
Into table Temp

Endcase
*******************************************
SELECT *;
FROM TEMP;
WHERE ccsMatch6C(BCODE, PO_NO, QUALITY, DESIGN, SZCODE, COLOUR, WashType);
ORDER BY po_no,ol_no;
INTO CURSOR Tempfinal

SELECT Tempfinal
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" 
		Report form cadurnrep.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" 
		Report form cadurnrep.frx to printer prompt noconsole
	**Data Export to Excel
	Case  m.PrnStat="S" .and. m.Option="A"
		EXPORT TO &exclfile TYPE XL5 FIELDS PO_NO,BCODE,OL_NO,QUALITY,DESIGN,COLOUR,supplier,spcl_inst,notes,skuno,comment,cstatus,breadth,length,sqmt,buy_delidt,;
					sup_estdt,po_dt,wevlastdt,issdt,fdate,issdtwash,rcddtwash,buy_delday,weverday,yarnday,wevday,cutday,washday,pkday,totalday,BuyLate
		Messagebox("Search Stage-wise Production Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File")
	Case  m.PrnStat="S" .and. m.Option="B"
		EXPORT TO &exclfile TYPE XL5 FIELDS PO_NO,BCODE,OL_NO,QUALITY,DESIGN,COLOUR,supplier,spcl_inst,notes,skuno,comment,cstatus,expdt,invno,packno,breadth,length,sqmt,buy_delidt,;
					sup_estdt,po_dt,wevlastdt,issdt,fdate,issdtwash,rcddtwash,buy_delday,weverday,yarnday,wevday,cutday,washday,pkday,totalday,BuyLate
		Messagebox("Search Stage-wise Production Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File")
Endcase
Endif
