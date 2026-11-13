Local m.invno
m.invno='T-13/18'
SELECT INVNO,ALLTRIM(PO_NO)+' '+alltrim(p.subbuyer) as PO_NO,d.Dgndesc as Design,QltyInv as QUALITY,sum(SQMT) AS SQMT,count(carpetno) as pcs;
			FROM Packtran p;
			Inner Join CaDesign d;
			On p.design=d.code;
			Inner Join Caqlty q;
			On p.quality=q.code;
			Group by Po_no,Dgndesc,QltyInv;
			Where invno=m.invno;
			Order by PO_NO;
			Into cursor pd
			
			
Select Invno,po_no,subbuyer;
From Packtran;
Group by Po_no,Design,Quality;
Where invno=m.invno

			
Select OL_NO, Invno,po_no,subbuyer;
From Packtran;
Where invno=m.invno
