public ptotalpage

Open Database Carpet share
SELECT p.buyerno,p.subbuyer,d.dgndesc as Design,p.colour,p.shipbrth as bthweav,p.shiplngth as lthweav,p.baleno,p.slno;
FROM packtran p,Cadesign d ;
Where p.Design=d.Code;
Having p.invno=alltrim(m.invno);
Into Cursor temp1a

SELECT p.buyerno,p.subbuyer,p.Design,d.Desc as colour,p.bthweav,p.lthweav,p.baleno;
FROM temp1a p,CaColour d ;
Where p.colour=d.Code;
Order by p.slno;
Into Cursor temp1


SELECT max(recno()) as maxrecno;
FROM temp1 ;
Where invno=alltrim(m.invno);
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
		Label form label1.lbx to console preview in screen
	Case m.PrnStat="P"
		Label form label1.lbx to printer prompt noconsole
Endcase
Endif
Return