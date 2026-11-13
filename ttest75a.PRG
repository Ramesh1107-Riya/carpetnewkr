Local m.Date
m.Date=Date()
Select b.Sqmt,s.Issdt,s.loomdt,s.fdate,s.Wev_Last_Dt,b.Washtype;
From Casupord s,Cabuyord b;
Where b.ol_no=s.ol_no .and. !empty(s.IssDt) .and. empty(s.fdate);
Into Cursor OrdHand

Select OrdHand
Brow

**Order Issued to Supplier but Not Started
Select Washtype,sum(sqmt) NSsqmt;
From OrdHand;
Where !empty(IssDt) .and. empty(Loomdt) .and. Washtype='TTC';
Into Cursor Nostart

Select Nostart
Brow

**Order Issued to Supplier but Not Started
Select Washtype,sum(sqmt) NSsqmt;
From OrdHand;
Where !empty(IssDt) .and. empty(Loomdt) .and. (Washtype='JW' .or. WashType='PCI' .or. WashType='MTRF');
Into Cursor NostartJ

Select NostartJ
Brow

**Late On Loom, Wev_Last_Dt
Select sum(sqmt) NSsqmt,Washtype;
From OrdHand;
Where !empty(Loomdt) .and. Wev_Last_Dt<=m.Date .and. Washtype='TTC';
Into Cursor LateLoom

Select LateLoom
brow

Select sum(sqmt) NSsqmt,Washtype;
From OrdHand;
Where !empty(Loomdt) .and. Wev_Last_Dt<=m.Date .and. (Washtype='JW' .or. WashType='PCI' .or. WashType='MTRF'); 
Into Cursor LateLoomJ;

Select LateLoomJ
brow

**Late Buyer Deliver
Select ol_no,sqmt,washtype,cstatus,bcode,yrncaldt;
From Cabuyord;
Where cstatus<>'Exported' .and. cstatus<>'NotDistri' .and. yrncaldt<=m.date .and. yrncaldt>={^2022/01/01};
Into Cursor Latedeli2

*Select sum(sqmt)
Select sum(sqmt) sqmt,washtype;
From Latedeli2;
Where bcode<>'74' .and. bcode<>'80' .and. bcode<>'169' .and. bcode<>'197' .and. washtype='TTC';
Into Cursor Latedeli2c

Select Latedeli2c
brow

Select sum(sqmt) sqmt,washtype;
From Latedeli2;
Where bcode<>'74' .and. bcode<>'80' .and. bcode<>'169' .and. bcode<>'197' .and. (Washtype='JW' .or. WashType='PCI' .or. WashType='MTRF'); 
Into Cursor Latedeli2d

Select Latedeli2d
brow

