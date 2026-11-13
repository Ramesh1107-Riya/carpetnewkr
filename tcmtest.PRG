**25/01/2019
*Excel Packing List of TCM Inserted directly to packtran.dbf by Ramesh Basnet, on request to Mr.Chomphel excel list

Select b.mbcode as po_no,b.ol_no,s.carpetno,b.Quality,b.Design,b.Colour,b.Szcode,b.fringes, b.Breadth,b.Length,b.sqmt,b.fieldcode,b.flddesc,s.bthweav,s.lthweav,s.finsqmt,;
	b.bcode,b.ship_inst,b.notes,b.comment,b.cstatus, s.Card_no, b.sl_no, b.wash, b.washtype,b.spcl_inst as subbuyer,Ctrl_no as buyerno,b.silkpr,b.spcl_inst;
From Cabuyord b, Casupord s;
where b.ol_no=s.ol_no;
Into Cursor buysup

Select i.*,j.invno,j.remark;
From buysup i,tcmpack j;
where i.carpetno=j.carpetno;
Into Table Pack1

SELECT i.carpetno,i.invno,i.remark;
FROM tcmpack i;
WHERE .NOT. EXISTS (SELECT carpetno FROM buysup p;
					WHERE p.carpetno=i.carpetno);
Into Table packnot

