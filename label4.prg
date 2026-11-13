Set Talk off
Set Safe off
Set Ansi off

public ptotalpage

SELECT b.BCODE,s.CARPETNO,b.PO_NO,b.CTRL_NO as BUYERNO,b.DESIGN,QUALITY,COLOUR,b.Packno,b.shbr,b.shln,b.blno,notes,skuno;
FROM  Cabuyord b;
Inner Join Casupord s;
On b.ol_no=s.ol_no;
WHERE !empty(fdate) .and. Packno=m.Packno ;
UNION ALL;
SELECT BCODE,CARPETNO,PO_NO,CTRL_NO as BUYERNO,DESIGN,QUALITY,SUBSTR(COLOUR,1,10) AS COLOUR,Packno,shbr,shln,blno,SUBSTR(NOTES,1,40) AS NOTES,skuno;
FROM  Stkcarpet;
WHERE Packno=m.Packno;		
Into cursor buysupstk

SELECT p.BCODE,p.CARPETNO,p.PO_NO,p.BUYERNO,p.DESIGN,q.QltyInv as QUALITY,p.COLOUR,p.Packno,p.shbr,p.shln,p.blno,p.NOTES,p.skuno;
FROM buysupstk p;
Inner Join Caqlty q;
On p.quality=q.code;
order by blno,carpetno;
Into Cursor temp1

SELECT max(recno()) as maxrecno;
FROM buysupstk;
Where Packno=alltrim(m.Packno);
Into Cursor temp2

Select temp2
ptotalpage=temp2->maxrecno

Select temp1
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Label form label4.lbx to console preview in screen
	Case m.PrnStat="P"
		Label form label4.lbx to printer prompt noconsole
Endcase
Endif
Return

