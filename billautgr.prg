*Graph Order & Recvd Devi Ram TT 23/07/2020
*Cacluate maximum value of Bill No., increase by 1 seeing no. of copy 
*This ol no not used instead carpet no is used, Field Washtype=billautogr storage
Public m.billautgr
Private m.maxol_no
Select max(val(isuslip)) as maxno;
From graphord;
Into Cursor curmax1

select curmax1
m.maxol_no=curmax1->maxno
if m.maxol_no>1
	m.billautgr=STR(m.maxol_no+1,6,0)
else
	m.billautgr=STR(2001,6,0)
endif

