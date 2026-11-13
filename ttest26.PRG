select a.ol_no,a.carpetno,b.carpetno;
From Casupord a,oldstktt b;
Where a.carpetno=b.carpetno;
Having !empty(a.carpetno) .or. !empty(b.carpetno);
order by a.carpetno;
into cursor temp1

select b.ol_no,b.design,b.quality,b.colour,b.cstatus;
From temp1 a,Cabuyord b;
Where a.ol_no=b.ol_No;
order by a.ol_no
**********************************************
*Exported not included
select b.ol_no,b.design,b.quality,b.colour,b.cstatus;
From temp1 a,Cabuyord b;
Where a.ol_no=b.ol_No;
Having b.cstatus<>'Exported';
order by a.ol_no;
Into Cursor temp2
**********************************
***Exported only
select b.ol_no,b.design,b.quality,b.colour,b.cstatus,b.sqmt;
From temp1 a,Cabuyord b;
Where a.ol_no=b.ol_No;
Having b.cstatus='Exported';
order by a.ol_no;
Into Cursor temp3

select b.ol_no,b.design,b.quality,b.colour,b.cstatus,b.Invno,b.sqmt;
From temp3 a,Packtran b;
Where a.ol_no=b.ol_No;
Having b.cstatus<>'Exported';
order by a.ol_no


