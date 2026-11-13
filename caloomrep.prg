*Supplier's Loom Available For Our Not Distributed Carpet
SET ANSI ON
Open Database carpet

SELECT s.supplier,b.szcode,sum(b.Qty) Uqty;
FROM Casupord s,Cabuyord b;
WHERE b.ol_no=s.ol_no .and. b.cstatus="On-Loom";
GROUP BY s.supplier, b.szcode;
ORDER BY s.supplier,b.szcode;
INTO CURSOR LoomUse

IF EMPTY(m.szcode)
SELECT a.Suplier,a.szcode,a.qty,IIF(ISNULL(b.uqty),0,b.uqty) AS uqty;				
FROM caloomsz a;
Left Join LoomUse b;
ON a.suplier=b.supplier .and. a.szcode=b.szcode; 
Order by a.Suplier,a.szcode;
INTO CURSOR Loomavail
ELSE
SELECT a.Suplier,a.szcode,a.qty,IIF(ISNULL(b.uqty),0,b.uqty) AS uqty;				
FROM caloomsz a;
Left Join LoomUse b;
ON a.suplier=b.supplier .and. a.szcode=b.szcode; 
Order by a.Suplier,a.szcode;
WHERE a.szcode=ALLTRIM(m.szcode);
INTO CURSOR Loomavail
ENDIF

IF RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
ELSE
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		REPORT FORM caloomrep.frx PREVIEW WINDOW wReport 
		*Report form yrnorderd.frx to console preview in screen
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form caloomrep.frx to printer prompt noconsole
Endcase
ENDIF
RETURN


