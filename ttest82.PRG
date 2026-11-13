select  * from yrcalc where design like [%933%] into table yrn933
select design,basecolour,quality,date,colour01,colour02,colour03,ply01,ply02,ply03,Rod01,Rod02,Rod03,Qlty01,Qlty02,Qlty03 from yrn933 into  table yrn933b
Select y.*,b.po_no,b.po_dt,b.notes,b.szcode,b.sqmt,b.cstatus,b.ol_no From yrn933b y,cabuyord b where y.design=b.design .and. y.basecolour=b.colour into table yrnbuy
select i.*,j.invno,j.expdt From yrnbuy i,packtran j where i.ol_no=j.ol_no
