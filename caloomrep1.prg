SET ANSI ON
Open Database carpet

SELECT s.supplier,b.szcode,sum(b.Qty) Uqty;
FROM Casupord s,Cabuyord b;
WHERE b.ol_no=s.ol_no;
HAVING cstatus="On-Loom";
GROUP BY s.supplier, b.szcode;
ORDER BY s.supplier,b.szcode;
INTO CURSOR LoomUse
select LoomUse
brow

SELECT a.Suplier,a.szcode,a.qty,b.uqty;				
ORDER BY a.Suplier,a.szcode;
FROM caloomsz a, LoomUse b;
WHERE EXISTS(SELECT * FROM LoomUse b;
			WHERE a.suplier=b.supplier .and.;
					a.szcode=b.szcode);
INTO CURSOR loomrep
select loomrep
brow

SELECT a.suplier,a.szcode,a.qty;
FROM Cabuyord b, caloomsz a;
ORDER BY a.Suplier,a.szcode;
WHERE b.szcode=a.szcode;
HAVING b.cstatus!="On-Loom";
INTO CURSOR Loomavail
Select Loomavail
brow
**b.uqty;
