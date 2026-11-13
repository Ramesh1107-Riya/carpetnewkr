*Washing Issue Slip auto generated
Public m.pWhISlip
Private m.maxIslip
Select max(whislip) as maxno;
From casupord;
Into Cursor curmaxi

select curmaxi
m.maxIslip=curmaxi->maxno
if m.maxIslip>1
	m.pWhISlip=m.maxIslip+1
else
	m.pWhISlip=500001
endif

