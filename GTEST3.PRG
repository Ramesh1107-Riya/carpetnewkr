SELECT INVNO,p.CARPETNO,ALLTRIM(PO_NO)+' '+alltrim(p.subbuyer) as PO_NO,p.Notes as Design,QltyInv as QUALITY,SQMT,SqmtOrd as StdSqmt,carpetno as pcs;
			FROM Packtran p;
			Left Join Caqlty q;
			On p.quality=q.code;
			Where alltrim(p.invno)='INV100'