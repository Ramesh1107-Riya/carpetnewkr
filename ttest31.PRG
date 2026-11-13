Local m.invno
m.invno='JW-158/19'

	*SELECT INVNO,ALLTRIM(PO_NO)+' '+alltrim(p.subbuyer) as PO_NO,p.Notes as Design,QltyInv as QUALITY,SQMT,count(carpetno) as pcs
	*		FROM Packtran p;
	*		Inner Join Caqlty q;
	*		ON p.quality=q.code;
	*		Where alltrim(p.invno)=alltrim(m.invno);
	*		Order by PO_NO;
	*		Into cursor pd02


			SELECT INVNO,ALLTRIM(PO_NO)+' '+alltrim(p.subbuyer) as PO_NO,p.Notes as Design,QUALITY,SQMT;
			FROM Packtran p;
			Where alltrim(p.invno)=alltrim(m.invno);
			Into cursor pack1
			
			Select pack1
			brow
					
			SELECT INVNO,PO_NO,Design,q.QltyInv as QUALITY,SQMT;
			FROM Pack1 p;
			Inner Join Caqlty q;
			ON p.quality=q.code;
			Where alltrim(p.invno)=alltrim(m.invno);
			Order by PO_NO;
			Into cursor pd01
			
			
			SELECT INVNO,PO_NO,Design,QUALITY,sum(SQMT) AS SQMT,count(sqmt) as pcs;
			FROM pd01;
			Group by Po_no,Design,Quality;
			Where invno=m.invno;
			Order by PO_NO;
			Into cursor pd	
			
			Select pd
			brow
			
		
			SELECT INVNO,PO_NO,Design,QUALITY,sum(SQMT) AS SQMT,sum(pcs) as pcs;
			FROM pd;
			Group by INVNO;
			Order by PO_NO;
			Into cursor pda
			
			SELECT pda
			brow
			
			
			
				







