*Washing Received Slip auto generated
Public m.pWhRSlip
Private m.maxRslip
Select max(whislip) as maxno;
From casupord;
Into Cursor curmaxr

select curmaxr
m.maxRslip=curmaxi->maxno
if m.maxIslip>1
	m.pWhRSlip=m.maxRslip+1
else
	m.pWhRSlip=100001
endif

