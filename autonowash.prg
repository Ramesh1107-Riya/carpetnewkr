*Cacluate maximum value of slip No., increase by 1 seeing no. of copy 
Public m.slipautno
Private m.maxol_no
Select max(val(slipno)) as maxno;
From Carpet!yrnwshiss;
Into Cursor curmax1

select curmax1
m.maxol_no=curmax1->maxno
if m.maxol_no>1
	m.slipautno=STR(m.maxol_no+1,7,0)
else
	m.slipautno=STR(5001,7,0)
endif

