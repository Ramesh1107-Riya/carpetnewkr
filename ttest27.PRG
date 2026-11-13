close all

select a.ol_no,a.carpetno;
From Casupord a,oldstktt b;
Where a.carpetno=b.carpetno;
Having !empty(a.carpetno) .or. !empty(b.carpetno);
order by a.carpetno;
into table temp1

Close all
USE oldstktt IN 0
USE Temp1 IN 0
select Temp1 && values come FROM this table 
scan
Delete From Oldstktt;
Where oldstktt.carpetno=temp1.carpetno
endscan
select oldstktt
pack
USE IN oldstktt
USE IN Temp1

***********************
Select * from oldstktt