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

SELECT a.Suplier,a.szcode,a.qty,b.uqty;				
FROM caloomsz a, LoomUse b;
WHERE EXISTS(SELECT * FROM LoomUse b;
			WHERE a.suplier=b.supplier .and.;
					a.szcode=b.szcode);
UNION ALL;
SELECT a.suplier,a.szcode,a.qty,a.qty-a.qty;
FROM Cabuyord b, caloomsz a;
WHERE b.szcode=a.szcode .AND. b.cstatus!="On-Loom";
INTO CURSOR Loomavail
Select Loomavail
brow
**b.uqty;
