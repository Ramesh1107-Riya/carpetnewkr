select *;
from packtran;
where subbuyer='ST';
INTO CURSOR PACK1

Select i.PO_NO,i.OL_NO,i.CARPETNO,i.QUALITY,i.DESIGN,i.COLOUR,i.SHIPBRTH,i.SHIPLNGTH,i.sqmt,i.NOTES,i.invno,i.expdt,b.yrncaldt as deli_date,i.expdt-b.yrncaldt as expLate,b.po_dt;
From pack1 i,cabuyord b;
Where i.ol_no=b.ol_no .and. b.bcode="36" ;
Into Cursor pack2

Select i.PO_NO,i.OL_NO,i.CARPETNO,i.QUALITY,i.DESIGN,i.COLOUR,i.SHIPBRTH,i.SHIPLNGTH,i.sqmt,i.NOTES,b.fdate,b.loomdt,b.fdate-b.loomdt as prdurn,;
			b.rcddtwash,b.issdtwash,b.rcddtwash-b.issdtwash as washdurn,i.expdt-b.rcddtwash as pkdurn,i.invno,i.expdt,deli_date,explate,po_dt;
From pack2 i,casupord b;
Where i.ol_no=b.ol_no

*.and. b.cstatus<>"Exported"