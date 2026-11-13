*Cacluate maximum value Slipno, increase by 1 seeing no. of copy 
*Must find Highest slip no from both wiissue.dbf/ wireturn.dbf
********************************************
Public m.pslipautowy 
Private m.maxSlipno

Select max(val(slipno)) as maxSlip;
From yrnrecvd;
Into Cursor cRecd

select cRecd
m.maxSlipno=cRecd->maxSlip

if m.maxSlipno>1 
	m.pslipautowy=STR(m.maxSlipno+1,5,0)
else
	m.pslipautowy=STR(10001,5,0)
endif
********************************************
