*1)BCODE,PO_NO,QUALITY Old Stok Summary (rstcarpetq.prg)
	SELECT s.BCODE,alltrim(b.NAME) as Name, PO_NO,QUALITY, sum(SQMT) as SQMT,count(ol_no) as pcs;
 	FROM  Stkcarpet s;
 	LEFT JOIN Cabuyer b;
 	ON s.BCODE=b.BCODE;
	WHERE cstatus<>'Exported';
	Order by s.BCODE,po_no,QUALITY;
	Group by s.BCODE,po_no,QUALITY
	
*2)BCODE,SPCL_INST,QUALITY Old Stok Summary	(rstcarpets.prg)
	SELECT s.BCODE,alltrim(b.NAME) as Name,SPCL_INST,QUALITY, sum(SQMT) as SQMT,count(ol_no) as pcs;
	FROM  Stkcarpet s;
 	LEFT JOIN Cabuyer b;
 	ON s.BCODE=b.BCODE;
	WHERE cstatus<>'Exported';
	Order by s.BCODE,SPCL_INST,QUALITY;
	Group by s.BCODE,SPCL_INST,QUALITY
	
*3)BCODE Old Stok Summary (rstcarpetp.prg)
	SELECT s.BCODE,alltrim(b.NAME) as Name, sum(SQMT) as SQMT,count(ol_no) as pcs;
 	FROM  Stkcarpet s;
 	LEFT JOIN Cabuyer b;
 	ON s.BCODE=b.BCODE;
	WHERE cstatus<>'Exported';
	Order by s.BCODE;
	Group by s.BCODE
	
