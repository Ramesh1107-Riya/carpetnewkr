*Array Declaration
Dimension PoNo(4) 
Store ' ' to PoNo
Public  PoNo1,PoNo2,PoNo3,PoNo4
Local m.Invno
m.Invno='AI/0004/20'

Select Invno,PO_NO;
FROM Packtran p;
Where alltrim(invno)=alltrim(m.invno);
Order by PO_NO;
Into Cursor Inv1
	
Select Inv1
If !(RECNO()>RECCOUNT())
	Select Distinct Po_No;
	From Inv1;
	Where recno()<=4 .and. !empty(po_no);
	Order by po_no;
	Into Array PackSource
	
	ACOPY(PackSource,PoNo)				
	PoNo1=PoNo(1)
	PoNo2=PoNo(2)
	PoNo3=PoNo(3)
	PoNo4=PoNo(4)
Else
	*Initialize array PoNo(4) with blank
	Local m.start,m.end,cnt
	m.start=1
	m.end=4
	For cnt=m.start to m.end STEP 1
		PoNo(cnt)=' '
	Endfor
	
	PoNo1=PoNo(1)
	PoNo2=PoNo(2)
	PoNo3=PoNo(3)
	PoNo4=PoNo(4)
Endif

?PoNo1
?PoNo2
?PoNo3
?PoNo4