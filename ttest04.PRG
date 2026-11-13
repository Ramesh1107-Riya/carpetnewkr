	SELECT BCODE, PO_NO, sum(SQMT) as SQMT,count(ol_no) as pcs;
 	FROM  Stkcarpet;
	WHERE cstatus<>'Exported';
	Order by BCODE,po_no;
	Group by BCODE,po_no;
	Into Cursor Stk1
	
	SELECT s.BCODE,b.name,s.PO_NO,s.SQMT,s.pcs;
 	FROM  Stk1 s;
 	Join Cabuyer b;
 	on s.Bcode=b.Bcode;
	Into Table Stkpono
	
	
	SELECT BCODE,sum(SQMT) as SQMT,count(ol_no) as pcs;
 	FROM  Stkcarpet;
	WHERE cstatus<>'Exported';
	Order by BCODE;
	Group by BCODE;
	Into Cursor Stk2
	
	SELECT s.BCODE,b.name,s.SQMT,s.pcs;
 	FROM  Stk2 s;
 	Join Cabuyer b;
 	on s.Bcode=b.Bcode;
	Into Table Stkbcode
	
	
	
	