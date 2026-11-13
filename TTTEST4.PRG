***Grouping Based on Acutal Quality
SELECT INVNO,q.QltyInv as QUALITY,sum(SQMT) Actualsqmt,sum(sqmtord) as StdSqmt,count(carpetno) as pcs;
FROM Packtran p;
Inner Join Caqlty q;
On p.quality=q.code;
Where invno='TFK-24/18';  &&m.invno
Group by q.QltyInv;
Order by q.QltyInv

*********Grouping Based on Knot wise
SELECT INVNO,q.QltyKnot as QUALITY,sum(SQMT) Actualsqmt,sum(sqmtord) as StdSqmt,count(carpetno) as pcs;
FROM Packtran p;
Inner Join Caqlty q;
On p.quality=q.code;
Where invno='TFK-24/18'; 
Group by q.QltyKnot;
Order by q.QltyKnot 
