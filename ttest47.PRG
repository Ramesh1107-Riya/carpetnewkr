*1)
select i.*;
From stkcarpet i,stksize3 s;
where i.carpetno=s.carpetno

*s.carpetno as cpno,s.breadth as breadth2,s.length as length2,s.sqmt as s.sqmt2,s.szcode as szcode2;

*select j.*;
*From stkcarpet j,casupord s;
*where j.carpetno=s.carpetno


****************************
SELECT s.*;
FROM Stksize3 s;
WHERE .NOT. EXISTS (SELECT p.carpetno FROM stkcarpet p;
					WHERE p.carpetno=s.carpetno);
into table ctemp1

*2)
select j.*;
From ctemp1 j,casupord s;
where j.carpetno=s.carpetno
