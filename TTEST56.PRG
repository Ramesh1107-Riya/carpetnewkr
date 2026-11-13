SELECT s_inv_no,s_inv_date,o_run_num,O_cust_num,o_desg_no,o_base_no,o_size_1,o_size_2,s_size_cm1,s_size_cm2;
FROM ordrsold;
WHERE s_inv_date>={^2019/08/01} .and. s_inv_date<={^11/06/2020} .and. o_size_1=267 .and. o_size_2=351;
Order by s_inv_date;
Into table sold01

SELECT s_inv_no,s_inv_date,o_run_num,O_cust_num,o_desg_no,o_base_no,o_size_1,o_size_2,s_size_cm1,s_size_cm2;
FROM ordrsold;
WHERE s_inv_date>={^2019/08/01} .and. s_inv_date<={^2019/08/01} .and. o_size_1=267 .and. o_size_2=351;
HAVING S_size_CM1<267 .OR. S_size_CM2<351;
Order by s_inv_date;
into table sold02


SELECT s_inv_no,s_inv_date,o_run_num,O_cust_num,o_desg_no,o_base_no,o_size_1,o_size_2,s_size_cm1,s_size_cm2,o_size_1-s_size_cm1 as size1,o_size_2-s_size_cm2 as size2;
FROM ordrsold;
WHERE s_inv_date>={^2019/08/01} .and. s_inv_date<={^2019/08/01} .and. o_size_1=267 .and. o_size_2=351;
Order by s_inv_date;
Into table sold03


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

