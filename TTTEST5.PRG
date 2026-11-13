SELECT INVNO,PO_NO,d.Dgndesc as Design,QltyInv as QUALITY,sum(SQMT) sQMT,count(carpetno) as pcs;
FROM Packtran p;
Inner Join CaDesign d;
On p.design=d.code;
Inner Join Caqlty q;
On p.quality=q.code;
Group by Po_no,Dgndesc,QltyInv;
Where invno="TFK-24/18";
Order by PO_NO