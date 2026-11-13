select *;
from packtran;
where subbuyer='ST';
INTO CURSOR PACK1

Select i.PO_NO,i.OL_NO,i.CARPETNO,i.QUALITY,i.DESIGN,i.COLOUR,i.SHIPBRTH,i.SHIPLNGTH,i.sqmt,i.NOTES,i.invno,i.expdt,b.yrncaldt as deli_date,b.yrncaldt-i.expdt as days;
From pack1 i,cabuyord b;
Where i.ol_no=b.ol_no