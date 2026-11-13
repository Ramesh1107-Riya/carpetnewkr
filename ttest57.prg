Select i.PO_NO,i.OL_NO,i.CARPETNO,i.QUALITY,i.DESIGN,i.COLOUR,b.SZCODE,b.BREADTH,b.LENGTH,i.SHIPBRTH,i.SHIPLNGTH,b.Breadth-i.shipbrth as Brdiff,i.Length-Shiplngth as Lndiff,b.sqmt,i.NOTES,i.invno,i.expdt,b.cstatus;
From packtran i;
Right Join Cabuyord b;
On i.ol_no=b.ol_no; 
Where b.szcode="267X351" .and. b.bcode='36' .and. i.expdt>={^2019/08/01} .and. i.expdt<={^2020/08/01};
Order by i.expdt;
Into table pack3.dbf

