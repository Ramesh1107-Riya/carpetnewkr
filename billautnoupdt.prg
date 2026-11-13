*Cacluate Min value of Bill No., increase by 1 seeing no. of copy 
*This ol no not used instead carpet no is used, Field Washtype=billautono storage
Public m.billautnomin
Private m.minol_no
Select min(val(billno)) as minno;
From casupord;
Into Cursor curmin

select curmin
 m.minol_no=curmin->minno
if m.minol_no>1
	m.billautnomin=STR(m.maxol_no-1,7,0)
else
	m.billautnomin=STR(1000,7,0)
endif

