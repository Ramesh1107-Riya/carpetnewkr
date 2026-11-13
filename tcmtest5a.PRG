close all

Select b.po_no,b.ol_no,s.carpetno,b.Quality,b.Design,b.Colour,b.Szcode,b.fringes, b.Breadth,b.Length,b.sqmt,b.fieldcode,b.flddesc,s.bthweav,s.lthweav,s.finsqmt,;
	b.bcode,b.ship_inst,b.notes,b.comment,b.cstatus, s.Card_no, b.sl_no, b.wash, b.washtype,b.spcl_inst as subbuyer,Ctrl_no as buyerno,b.silkpr,b.spcl_inst;
From Cabuyord b, Casupord s;
where b.ol_no=s.ol_no;
into Cursor buy1

Select b.*,p.ol_no as ol_no1,p.date as invdate,p.invno,b.Breadth as shipbrth,b.length as shiplngth,b.sqmt as sqmtord;
From buy1 b,pptcm p;
Where b.ol_no=p.ol_no;
Into table pack1

use pack1
brow

