select *;
from packtran;
where subbuyer='NONE';
INTO CURSOR PACK1

Select i.PO_NO,i.OL_NO,i.CARPETNO,i.QUALITY,i.DESIGN,i.COLOUR,i.SHIPBRTH,i.SHIPLNGTH,i.sqmt,i.NOTES,i.invno,i.expdt,b.yrncaldt as deli_date,b.yrncaldt-i.expdt as expLate,b.po_dt;
From pack1 i;
Right Join Cabuyord b;
On i.ol_no=b.ol_no; 
Where b.bcode="36" ;
Into Cursor pack2

Select i.PO_NO,i.OL_NO,i.CARPETNO,i.QUALITY,i.DESIGN,i.COLOUR,i.SHIPBRTH,i.SHIPLNGTH,i.sqmt,i.NOTES,b.fdate,b.loomdt,b.fdate-b.loomdt as pdurn,;
			b.rcddtwash,b.issdtwash,b.rcddtwash-b.issdtwash as washdurn,i.expdt-b.rcddtwash as pkdurndeli_date,i.invno,i.expdt,deli_date,explate,po_dt;
From pack2 i,casupord b;
Where i.ol_no=b.ol_no

*.and. b.cstatus<>"Exported"

*Not Exported*
Select i.PO_NO,i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.szcode,i.sqmt,i.NOTES,i.yrncaldt as deli_date,i.po_dt;
From Cabuyord i;
Where i.bcode="36" .and. i.cstatus<>"Exported" ;
Into Cursor pack2

Select i.PO_NO,i.OL_NO,b.CARPETNO,i.QUALITY,i.DESIGN,i.COLOUR,i.szcode,i.sqmt,i.NOTES,b.fdate,b.loomdt,b.fdate-b.loomdt as pdurn,;
			b.rcddtwash,b.issdtwash,b.rcddtwash-b.issdtwash as washdurn,po_dt;
From pack2 i;
Left Join casupord b;
On i.ol_no=b.ol_no
