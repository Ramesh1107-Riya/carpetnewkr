*Total Order in Hand
Select sum(sqmt) Sqmt,b.washtype;
From Cabuyord b,Cabuyer c;
Where b.bcode=c.bcode .and. b.cstatus<>'Exported' .and. c.stkord='O';
Group by b.washtype;
Order by b.washtype;
Into cursor ordhand

Select sqmt as ohandtt,washtype;
From ordhand;
Where washtype='TTC'

Select sum(sqmt) as ohandJ,washtype;
From ordhand;
Where washtype='JW' .or. washtype='PCI' .or. washtype='MTRF'

*Total Order in Current Stock
Select sum(sqmt) Sqmt,b.washtype;
From Cabuyord b,Cabuyer c;
Where b.bcode=c.bcode .and. b.cstatus<>'Exported' .and. c.stkord='S';
Group by b.washtype;
Order by b.washtype;
Into Cursor curord

Select sqmt as curordtt,washtype;
From curord;
Where washtype='TTC'

Select sum(sqmt) as curordjw,washtype;
From curord;
Where washtype='JW' .or. washtype='PCI' .or. washtype='MTRF'

*Total Old Stock
Select sum(sqmt) Sqmt,washtype;
From Stkcarpet;
Where cstatus<>'Exported';
Group by washtype;
Order by washtype;
Into Cursor oldstk

Select sqmt as oldstktt,washtype;
From oldstk;
Where washtype='TTC'

Select sum(sqmt) as oldstkj,washtype;
From oldstk;
Where washtype='JW' .or. washtype='PCI' .or. washtype='MTRF'



