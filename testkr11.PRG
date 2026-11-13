SELECT INVNO,ALLTRIM(PO_NO)+' '+alltrim(p.subbuyer) as PO_NO,p.Notes as Design,QltyInv as QUALITY,sum(SQMT) AS SQMT,count(carpetno) as pcs,Ratenpr,Ratedollar;
FROM Packtran p;
Inner Join Caqlty q;
On p.quality=q.code;
Group by Po_no,p.Notes,QltyInv;
Where alltrim(p.invno)=alltrim(m.invno);
Order by PO_NO;
Into cursor pd