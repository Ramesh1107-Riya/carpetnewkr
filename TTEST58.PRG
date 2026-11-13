Select i.PO_NO,i.OL_NO,i.CARPETNO,i.QUALITY,i.DESIGN,i.COLOUR,b.SZCODE,b.BREADTH,b.LENGTH,i.SHIPBRTH,i.SHIPLNGTH,b.Breadth-i.shipbrth as ShipBrdiff,i.Length-Shiplngth as ShipLndiff,b.sqmt,i.NOTES,i.invno,i.expdt,b.cstatus;
From packtran i;
Right Join Cabuyord b;
On i.ol_no=b.ol_no; 
Where b.bcode='36' .and. i.expdt>={^2019/01/01} .and. i.expdt<={^2020/08/01};
Order by i.expdt;
Into table pack5.dbf

Select i.PO_NO,i.OL_NO,i.CARPETNO,i.QUALITY,i.DESIGN,i.COLOUR,i.SZCODE,i.BREADTH,i.LENGTH,b.BTHWEAV,b.LTHWEAV,b.BTHWASH,b.LTHWASH,i.SHIPBRTH,i.SHIPLNGTH,i.ShipBrdiff,i.ShipLndiff,i.sqmt,i.NOTES,i.invno,i.expdt,i.cstatus;
From Pack5 i;
Inner Join  Casupord b;
On i.ol_no=b.ol_no; 
Into table pack6.dbf

Use pack6
brow