Select a.PO_No,a.Party,sum(a.Quantity) as QtyIss,a.ytype,b.PO_no,b.Party,sum(b.Quantity) as QtyRet;
From Wiissue a;
Left Join Wireturn b; 
On a.po_no=b.po_no ;
Where a.party=b.party;
Group by a.PO_No,a.Party,a.Ytype;
Order by a.PO_No,a.Party,a.ytype
*Into Cursor wis
	
	
	
