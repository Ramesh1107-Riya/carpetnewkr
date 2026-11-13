SELECT OL_NO,SQMT,SPCL_INST,CSTATUS, WASHTYPE,SCODE;
FROM  Stkcarpet;
WHERE cstatus<>"Exported";
UNION ALL;
SELECT b.OL_NO,b.SQMT,b.SPCL_INST,b.CSTATUS,b.WASHTYPE,SCODE;
FROM  Cabuyord b;
Inner Join Casupord s;
On b.ol_no=s.ol_no;
WHERE b.cstatus<>"Exported" .and. !empty(fdate);
Into cursor temp7

select * ;
FROM Temp7;
Where spcl_inst='JWSTK' .AND. WASHTYPE='TTC'

Select Washtype,Sum(sqmt) Sqmt,scode;
From temp7;
Group by Washtype,scode;
Into Cursor temp8

Select t.Washtype,c.item,t.scode,t.Sqmt;
From temp8 t;
Join caordhnd c;
on t.scode=c.scode

Select t.Washtype,sum(t.Sqmt) sqmt;
From temp8 t;
Join caordhnd c;
on t.scode=c.scode;
Group by t.Washtype
