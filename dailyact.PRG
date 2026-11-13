SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

*Public m.date,m.day
*m.date=date()-7
*m.day=CDOW(date()-7)
*m.PrnStat="V"
***CARPET******************
***Carpet (Daily Activity)
Private m.bsqmt,m.bsqmtj,m.isqmt,m.isqmtj,m.nmsqmt,m.nmsqmtJ,m.finsqmt,m.finsqmtJ,m.wisqmt,m.wisqmtJ,m.wrsqmt,m.wrsqmtJ,m.expsqmt,m.expsqmt

***Carpet Status Till Date***
Private m.Ordhnd,m.OrdhndJ,m.NotDist,m.NotDist,m.SupOrd,m.SupOrdJ,m.NoLoom,m.NoLoomJ,m.OnLoom,m.OnLoomJ,m.LatLoom,m.LatLoomJ,m.WashLate,m.WashLateJ,;
m.LBuyDeli,m.LBuyDeliJ,m.StkSqmt,m.StkSqmtJ

***Yarn (Daily Activity)
Private m.PurQty,m.PurQtyJ,m.IdyeQty,m.IdyeQtyJ,m.RdyeQty,m.RdyeQtyJ,m.ISupQty,m.ISupQtyJ,m.RSupQty,m.RSupQtyJ

***Yarn Stock Till Date Public define in yarnstkwht.prg, yarnstkdye.prg
*m.USilk,m.USilkJ,m.UYarn,m.UYarnJ,m.Cotton,m.CottonJ,m.DSilk,m.DSilkJ,m.Dyarn,m.DyarnJ,;

******Graphs******* Puvlic variable defined in Graphrep.prg
*Private m.DGmade,m.DGmadeJ,m.Pgraph,m.PgraphJ

*1)Buyer Order Received Today
Select sum(sqmt) as bsqmt;
From Cabuyord;
Where po_dt=m.date .and. Washtype='TTC';
Group by po_dt;
Into Cursor buy1

Select buy1
m.bsqmt=buy1->bsqmt

Select sum(sqmt) as bsqmtJ;
From Cabuyord;
Where po_dt=m.date .and. (Washtype='JW' .or. Washtype='PCI' .or. Washtype='MTRF');
Group by po_dt;
Into Cursor buy2

Select buy2
m.bsqmtJ=buy2->bsqmtJ

*2)Order Issued to Supplier Today
Select sum(b.sqmt) as isqmt;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where s.issdt=m.date .and. b.Washtype='TTC';
Group by s.issdt;
Into Cursor buy3

Select buy3
m.isqmt=buy3->isqmt

Select sum(b.sqmt) as isqmtJ;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where s.issdt=m.date .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Group by s.issdt;
Into Cursor buy4

Select buy4
m.isqmtJ=buy4->isqmtJ

*3)Received From Suppplier [Not Measured]
Select sum(b.sqmt) as sqmt;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where paintdt=m.date .and. b.Washtype='TTC';
Group by paintdt;
Into Cursor buy5
Select buy5
m.nmsqmt=buy5->sqmt

Select sum(b.sqmt) as sqmtJ;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where paintdt=m.date .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Group by paintdt;
Into Cursor buy6

Select buy6
m.nmsqmtJ=buy6->SqmtJ

*4)Received From Suppplier [Measured]
Select sum(finsqmt) as finsqmt;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where fdate=m.date .and. b.Washtype='TTC';
Group by fdate;
Into Cursor buy5

Select buy5
m.finsqmt=buy5->finsqmt

Select sum(finsqmt) as finsqmtJ;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where fdate=m.date .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Group by fdate;
Into Cursor buy6

Select buy6
m.finsqmtJ=buy6->finsqmtJ

*5)*Sent to Washing
Select sum(finsqmt) as wisqmt;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where issdtwash=m.date .and. b.Washtype='TTC';
Group by issdtwash;
Into Cursor buy7

Select buy7
m.wisqmt=buy7->wisqmt

Select sum(finsqmt) as wisqmtJ;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where issdtwash=m.date .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Group by issdtwash;
Into Cursor buy8

Select buy8
m.wisqmtj=buy8->wisqmtj

*6)*Received From Washing
Select sum(washsqmt) as wrsqmt;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where rcddtwash=m.date .and. b.Washtype='TTC';
Group by rcddtwash;
Into Cursor buy9

Select buy9
m.wrsqmt=buy9->wrsqmt

Select sum(washsqmt) as wrsqmtJ;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where rcddtwash=m.date .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Group by rcddtwash;
Into Cursor buy10

Select buy10
m.wrsqmtJ=buy10->wrsqmtJ

*7)**Exported******
Select sum(p.sqmt) as expsqmt;
From Cabuyord b;
Join Packtran p;
On b.ol_no=p.ol_no;
Where p.expdt=m.date .and. b.Washtype='TTC';
Group by p.expdt;
Into Cursor buy11

Select buy11
m.expsqmt=buy11->expsqmt

Select sum(p.sqmt) as expsqmtJ;
From Cabuyord b;
Join Packtran p;
On b.ol_no=p.ol_no;
Where p.expdt=m.date .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Group by p.expdt;
Into Cursor buy12

Select buy12
m.expsqmtJ=buy12->expsqmtJ

****************************************************************
*Carpets Status Till Date*****
** Scode="C" .and. Scode="M" .and. Scode="G" .and. Scode="H" .and. Scode="T" .and. Scode="S" .and. Scode="J"	.and. Scode="P" Not included in stock
**1)*Total Order in Hand
*(Scode="O" .or. Scode="C")

Select sum(sqmt) as sqmt;
From Cabuyord;
Where cstatus<>"Packed" .and. cstatus<>"Exported" .and. Scode="O" .and. Washtype='TTC';
Into Cursor Ordhand

Select Ordhand
m.Ordhnd=Ordhand->Sqmt

Select sum(sqmt) as sqmt;
From Cabuyord;
Where cstatus<>"Packed" .and. cstatus<>"Exported" .and. Scode="O"  .and. (Washtype='JW' .or. Washtype='PCI' .or. Washtype='MTRF');
Into Cursor OrdhandJ

Select OrdhandJ
m.OrdhndJ=OrdhandJ->Sqmt

**2) Not Distributed Order
Select sum(sqmt) as sqmt;
From Cabuyord;
Where cstatus="NotDistri" .and. Washtype='TTC';
Into Cursor NDist

Select NDist
m.NotDist=NDist->Sqmt

Select NDist
m.NotDistJ=NDist->Sqmt

Select sum(sqmt) as sqmt;
From Cabuyord;
Where cstatus="NotDistri" .and. (Washtype='JW' .or. Washtype='PCI' .or. Washtype='MTRF');
Into Cursor NDistJ

Select NDistJ
m.NotDistJ=NDistJ->Sqmt

**3*Total Order with Supplier*********************
Select  sum(sqmt) as sqmt;
From Casupord s,Cabuyord b;
Where b.ol_no=s.ol_no .and. !empty(s.IssDt) .and. empty(s.fdate) .and. Washtype='TTC';
Into Cursor OrdSup

Select OrdSup
m.SupOrd=OrdSup->Sqmt

Select  sum(sqmt) as sqmt;
From Casupord s,Cabuyord b;
Where b.ol_no=s.ol_no .and. !empty(s.IssDt) .and. empty(s.fdate) .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Into Cursor OrdSupJ

Select OrdSupJ
m.SupOrdJ=OrdSupJ->Sqmt

**************Loom Order************************************************************
Select b.Sqmt,s.Issdt,s.loomdt,s.fdate,s.Wev_Last_Dt,b.Washtype;
From Casupord s,Cabuyord b;
Where b.ol_no=s.ol_no .and. !empty(s.IssDt) .and. empty(s.fdate);
Into Cursor OrdHand

*4**Order Not ON Loom (over 14 days)***********************************************
Select Washtype,sum(sqmt) NoLoom;
From OrdHand;
Where !empty(IssDt) .and. empty(Loomdt) .and. Washtype='TTC' .and. Date()-Issdt>14;
Group By Washtype;
Into Cursor Nostart

Select Nostart
m.NoLoom=Nostart->NoLoom

Select Washtype,sum(sqmt) NoLoomJ;
From OrdHand;
Where !empty(IssDt) .and. empty(Loomdt) .and. (Washtype='JW' .or. WashType='PCI' .or. WashType='MTRF') .and. Date()-Issdt>14;
Into Cursor Nostart1

Select Nostart1
m.NoLoomJ=Nostart1->NoLoomJ

*5**Order in Loom******************************************************************** 
Select Washtype,sum(sqmt) OnLoom;
From OrdHand;
Where !empty(Loomdt) .and. Washtype='TTC';
Into Cursor OnLoom2

Select OnLoom2
m.OnLoom=OnLoom2->OnLoom

Select Washtype,sum(sqmt) OnLoomJ;
From OrdHand;
Where !empty(Loomdt) .and. (Washtype='JW' .or. WashType='PCI' .or. WashType='MTRF');
Into Cursor OnLoom2J

Select OnLoom2J
m.ONLoomJ=OnLoom2J->ONLoomJ

*6**Late On Loom, Wev_Last_Dt
Select sum(sqmt) LLoom,Washtype;
From OrdHand;
Where !empty(Loomdt) .and. Wev_Last_Dt<=m.Date .and. Washtype='TTC';
Into Cursor LateLoom

Select LateLoom
m.LLoom=LateLoom->LLoom

Select sum(sqmt) LLoomJ,Washtype;
From OrdHand;
Where !empty(Loomdt) .and. Wev_Last_Dt<=m.Date .and. (Washtype='JW' .or. WashType='PCI' .or. WashType='MTRF'); 
Into Cursor LateLoomJ;

Select LateLoomJ
m.LLoomJ=LateLoomJ->LLoomJ

*7)**Washing Late, more than 20 days is late**********************
Select sum(s.finsqmt) as washLate;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where !empty(s.issdtwash) .and. empty(s.Rcddtwash) .and. b.Washtype='TTC';
Having date()-s.issdtwash>20;
Into Cursor wlate

Select wlate
m.washLate=wlate->washLate

Select sum(s.finsqmt) as washLateJ;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where s.issdtwash=m.date .and. empty(s.Rcddtwash) .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Having date()-s.issdtwash>20;
Into Cursor wlateJ

Select wlate
m.washLateJ=wlateJ->washLateJ

*8)**Late Buyer Delivery***************************************************************************************
Select ol_no,sqmt,washtype,cstatus,bcode,yrncaldt;
From Cabuyord;
Where cstatus<>'Exported' .and. cstatus<>'NotDistri' .and. yrncaldt<=m.date .and. yrncaldt>={^2022/01/01};
Into Cursor Latedeli2

*8)*Late Buyer Delivery TTc
Select sum(sqmt) LBuyDeli,washtype;
From Latedeli2;
Where bcode<>'74' .and. bcode<>'80' .and. bcode<>'169' .and. bcode<>'197' .and. washtype='TTC';
Into Cursor Latedeli2c

Select Latedeli2c
m.LBuyDeli=Latedeli2c->LBuyDeli

Select sum(sqmt) LBuyDeliJ,washtype;
From Latedeli2;
Where bcode<>'74' .and. bcode<>'80' .and. bcode<>'169' .and. bcode<>'197' .and. (Washtype='JW' .or. WashType='PCI' .or. WashType='MTRF'); 
Into Cursor Latedeli2d

Select Latedeli2d
m.LBuyDeliJ=Latedeli2d->LBuyDeliJ

*9)****Total Stock Carpets********TTC********
Select sum(s.finsqmt) as sqmt;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where b.cstatus<>"Packed" .and. b.cstatus<>"Exported" .and. b.Scode<>"O"  .and. b.Washtype='TTC';
Into Cursor Stock1

Select sum(sqmt) as sqmt;
From Stkcarpet;
Where Washtype='TTC';
Into Cursor Stock2

Select sqmt;
From Stock1;
Union;
Select sqmt;
From Stock2;
Into Cursor Stock3

Select sum(sqmt) as Sqmt;
From Stock3;
Into Cursor Stock3c

Select Stock3c
m.StkSqmt= Stock3c->Sqmt

*****Total Stock Carpets********************* JW,PCI,MTRF*********************
Select sum(s.finsqmt) as sqmt;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where b.cstatus<>"Packed" .and. b.cstatus<>"Exported" .and. b.Scode<>"O"  .and. (Washtype='JW' .or. WashType='PCI' .or. WashType='MTRF'); 
Into Cursor Stock1a

Select sum(sqmt) as sqmt;
From Stkcarpet;
Where Washtype='JW' .or. WashType='PCI' .or. WashType='MTRF';
Into Cursor Stock2a

Select sqmt;
From Stock1a;
Union; 
Select sqmt;
From Stock2a;
Into Cursor Stock3a

Select sum(sqmt) as Sqmt;
From Stock3a;
Into Cursor Stock3b

Select Stock3b
m.StkSqmtJ= Stock3b->Sqmt
***EOF() Carpet Reports

***YARN (Daily Activity)****
*1)**White Yarn Purchase************************
Select sum(Netwt) as PurQty;
From Yrnrecvd;
Where Recdt=m.date .and. Washtype='TTC';
Group by Recdt;
Into Cursor yrn1

Select yrn1
m.PurQty=yrn1->PurQty

Select sum(Netwt) as PurQtyJ;
From Yrnrecvd;
Where Recdt=m.date .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Group by Recdt;
Into Cursor yrn2

Select yrn2
m.PurQtyJ=yrn2->PurQtyJ

*2**White Yarn Issue to Dyeing***************************
Select sum(Quantity) as IdyeQty;
From Yrnissdy;
Where date=m.date .and. Washtype='TTC';
Group by Date;
Into Cursor yrn3

Select yrn3
m.IdyeQty=yrn3->IdyeQty

Select sum(Quantity) as IdyeQtyJ;
From Yrnissdy;
Where date=m.date .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Group by Date;
Into Cursor yrn4

Select yrn4
m.IdyeQtyJ=yrn4->IdyeQtyJ

*3**Dyed Yarn Recd from Dyeing**************************
Select sum(Quantity) as RdyeQty;
From Wirecv;
Where date=m.date .and. Washtype='TTC';
Group by Date;
Into Cursor yrn5

Select yrn5
m.RdyeQty=yrn5->RdyeQty

Select sum(Quantity) as RdyeQtyJ;
From Wirecv;
Where date=m.date .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Group by Date;
Into Cursor yrn6

Select yrn6
m.RdyeQtyJ=yrn6->RdyeQtyJ

*4**Dyed Yarn Issue to Supplier*****************************
Select sum(Quantity) as ISupQty;
From Wiissue;
Where date=m.date .and. Washtype='TTC';
Group by Date;
Into Cursor yrn7

Select yrn7
m.ISupQty=yrn7->ISupQty

Select sum(Quantity) as ISupQtyJ;
From Wiissue;
Where date=m.date .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Group by Date;
Into Cursor yrn8

Select yrn8
m.ISupQtyJ=yrn8->ISupQtyJ

*5**Dyed Yarn Return From Supplier*****************************
Select sum(Quantity) as RSupQty;
From Wireturn;
Where date=m.date .and. Washtype='TTC';
Group by Date;
Into Cursor yrn9

Select yrn9
m.RSupQty=yrn9->RSupQty

Select sum(Quantity) as RSupQtyJ;
From Wireturn;
Where date=m.date .and. (b.Washtype='JW' .or. b.Washtype='PCI' .or. b.Washtype='MTRF');
Group by Date;
Into Cursor yrn10

Select yrn10
m.RSupQtyJ=yrn10->RSupQtyJ

**Enof() 
**Yarn Daily Activity
*
**Yarn Stock Till Date******
*1) Total Undyed Silk in Stock
*2) Total Undyed Yarn in Stock
*3) Total Cotton in Stock
do yarnstkwht

*4) Total Dyed Silk in Stock
*5) Total Dyed Yarn in Stock
do yarnstkdye

***Graphs***
*1)Daily Graphs Made
*2)Total Pending Graphs
do GrapRep

Select OrdSup
*Select buy12
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form dailyact.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form dailyact.frx to printer prompt noconsole
Endcase
Endif
Return


