*Autobillprinting for carpet
*Cacluate maximum value of Bill No., increase by 1 seeing no. of copy 
*This ol no not used instead carpet no is used, Field Washtype=billautono storage
Public m.billautonln
Private m.maxol_no
Select max(val(billonln)) as maxno;
From Carpet!casupord;
Into Cursor curmax1

select curmax1
m.maxol_no=curmax1->maxno
if m.maxol_no>1
	m.billautonln=STR(m.maxol_no+1,7,0)
else
	m.billautonln=STR(30001,7,0)
endif

