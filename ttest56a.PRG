Select b.ol_no,b.cstatus,b.exported,p.lastatus,p.invno;
From Cabuyord b,Packtran p;
Where b.ol_no=p.ol_no .and. b.cstatus<>p.lastatus .and. b.cstatus<>'Exported';
Into Cursor stsupdt && status update


Select i.PO_NO,i.OL_NO,i.CARPETNO,i.QUALITY,i.DESIGN,i.COLOUR,i.SHIPBRTH,i.SHIPLNGTH,i.sqmt,i.NOTES,i.invno,i.expdt,b.yrncaldt as deli_date,b.yrncaldt-i.expdt as expLate,b.po_dt;
From packtran i;
Right Join Cabuyord b;
On i.ol_no=b.ol_no; 
Where b.bcode="36" ;
Into Cursor pack2

