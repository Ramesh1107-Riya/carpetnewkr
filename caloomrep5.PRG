*Supplier's Loom Available For Our Not Distributed Carpet
SET ANSI ON

Open Database carpet

SELECT s.supplier,b.szcode,sum(b.Qty) Uqty;
FROM Casupord s,Cabuyord b;
WHERE b.ol_no=s.ol_no .and. b.cstatus="On-Loom";
GROUP BY s.supplier, b.szcode;
ORDER BY s.supplier,b.szcode;
INTO CURSOR LoomUse
select LoomUse
brow

SELECT a.Suplier,a.szcode,a.qty,IIF(ISNULL(b.uqty),0,b.uqty) AS uqty;				
FROM caloomsz a;
Left Join LoomUse b;
ON a.suplier=b.supplier .and. a.szcode=b.szcode; 
Order by a.Suplier,a.szcode;
INTO CURSOR Loomavail
Select Loomavail
brow
*UPDATE Loomavail;
*SET uqty=0;
*WHERE uqty=.NULL.


**b.uqty;
