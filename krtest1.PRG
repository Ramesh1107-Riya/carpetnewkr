Select Invno,bcode,count(carpetno) as Pcs,sum(Sqmt) as Sqmt,RateSqmt,curntype;
FROM Packtran p;
Group by Po_no,Rcode,Quality;
Order by PO_NO;
Into Cursor Invoice1

Select Invno,bcode,Pcs,Round((Sqmt*RateSqmt),2) as AmtSqmt,curntype;
From Invoice1;
Into Cursor Invoice

Select Invno,bcode,sum(Amtsqmt) as gtamtsqmt,curntype,sum(pcs) as pcs;
From Invoice;
Group by invno;
Into Cursor InvTot

Select i.Invno,i.Invdt,i.Tsqmt,i.tsqmt,disextamt,
From Expackingnp i,

Select InvTot
brow

*Where alltrim(invno)=alltrim(m.invno);