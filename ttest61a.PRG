**[] Current Balane [No Exported] 
**[] Expoted Only
**Enter Po_dt From[     ] to po_dt [    ]
set safe off

Select i.PO_NO,i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.spcl_inst,i.notes,i.skuno,i.comment,i.packno,i.cstatus,i.breadth,i.length,i.sqmt,i.po_dt,i.yrncaldt as buy_delidt,;
i.deliry_dt as sup_delidt,b.wev_last_dt as wevlastdt,b.fdate,b.issdt,b.issdtwash,b.rcddtwash,i.yrncaldt-i.po_dt as custday,b.wev_last_dt-b.issdt as weverday,;
b.issdt-i.po_dt as yarnday,iif(empty(b.fdate) .and. !empty(b.issdt), date()-b.issdt,0.00) as Loom , b.fdate-b.issdt as wevday,b.issdtwash-b.fdate as cutday,b.rcddtwash-b.issdtwash as washday;
From cabuyord i;
Join casupord b;
On i.ol_no=b.ol_no;
Into Cursor CabuSup

Select i.PO_NO,i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.spcl_inst,i.notes,i.skuno,i.comment,i.breadth,i.length,i.sqmt,i.po_dt,b.invno,i.packno,i.buy_delidt,b.expdt,i.cstatus,;
i.sup_delidt,i.wevlastdt,i.issdt,i.fdate,i.issdtwash,i.rcddtwash,i.custday,i.loom,i.cutday,i.weverday,i.yarnday,i.wevday,i.washday,iif(i.cstatus=='Exported',b.expdt-i.rcddtwash,date()-i.rcddtwash) as pkday;
From CabuSup i;
Inner Join Packtran b;
On i.ol_no=b.ol_no;
Where i.po_dt>={^2021/01/01};
Order by i.po_dt;
Into table Tempa
*Left Join Packtran b

Select PO_NO,OL_NO,QUALITY,DESIGN,COLOUR,spcl_inst,notes,skuno,comment,invno,packno,breadth,length,sqmt,buy_delidt,sup_delidt,po_dt,wevlastdt,issdt,fdate,issdtwash,rcddtwash,cstatus,expdt,;
custday,weverday,yarnday,loom,wevday,cutday,washday,pkday,(iif(yarnday>0,yarnday,0)+iif(wevday>0,wevday,0)+iif(cutday>0,cutday,0)+iif(washday>0,washday,0)+;
iif(pkday>0,pkday,0)) as totaldur,(iif(yarnday>0,yarnday,0)+iif(wevday>0,wevday,0)+iif(cutday>0,cutday,0)+iif(washday>0,washday,0)+iif(pkday>0,pkday,0))-custday as totaltime;
From Tempa;
Order by po_dt;
Into table Temp

Select Temp
brow

*((iif(yarnday>0,yarnday,0)+iif(wevday>0,wevday,0)+iif(cutday>0,cutday,0)+iif(washday>0,washday,0)+iif(pkday>0,pkday,0))- custday) as CutLateDay
*****Not Exported*******
Select i.PO_NO, i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.spcl_inst,i.notes,i.skuno,i.comment,i.packno,i.po_dt,i.breadth,i.length,i.sqmt,i.yrncaldt as buy_delidt,;
i.deliry_dt as sup_delidt,b.wev_last_dt as wevlastdt,b.fdate,b.issdt,b.issdtwash,b.rcddtwash,i.cstatus,i.yrncaldt-i.po_dt as custday,b.wev_last_dt-b.issdt as weverday,;
b.issdt-i.po_dt as yarnday,b.fdate-b.issdt as wevday,b.issdtwash-b.fdate as cutday,b.rcddtwash-b.issdtwash as washday,date()-b.rcddtwash as pkday,;
iif(empty(b.fdate) .and. !empty(b.issdt), date()-b.issdt,0.00) as Loom;
From cabuyord i;
Join casupord b;
On i.ol_no=b.ol_no;
Where i.cstatus<>"Exported" .and.  i.po_dt>={^2021/01/01};
Order by i.po_dt;
Into table Tempb


Select PO_NO,OL_NO,QUALITY,DESIGN,COLOUR,spcl_inst,notes,skuno,comment,packno,breadth,length,buy_delidt,sup_delidt,po_dt,wevlastdt,issdt,fdate,issdtwash,;
rcddtwash,cstatus,custday,weverday,yarnday,Loom,wevday,cutday,washday,pkday,(iif(yarnday>0,yarnday,0)+iif(wevday>0,wevday,0)+iif(cutday>0,cutday,0)+iif(washday>0,washday,0)+;
iif(pkday>0,pkday,0)) as totaldur;
From Tempb;
Order by po_dt;
Into table Temp1

Select Temp1
brow
close all

