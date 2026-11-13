*billautnotmea*.prg
*Cacluate maximum value of Bill No., increase by 1 seeing no. of copy 
*This ol no not used instead carpet no is used, Field Washtype=billautono storage
Public m.billautnm
Private m.maxol_no
Select max(val(location)) as maxno;
From casupord;
Into Cursor curmax1

select curmax1
m.maxol_no=curmax1->maxno
if m.maxol_no>1
	m.billautnm=STR(m.maxol_no+1,7,0)
else
	m.billautnm=STR(100001,7,0)
endif

