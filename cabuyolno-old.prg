*Cacluate maximum value of Cabuyord Number, increase by 1 seeing no. of copy 
Public m.autol_no
Private maxol_no
Select max(val(ol_no)) as maxno;
From cabuyord;
Into Cursor curmax

select curmax
maxol_no=curmax->maxno
if m.maxol_no>=1
	m.autol_no=STR(m.maxol_no+1,10,0)
else
	m.autol_no=STR(10001,10,0)
endif
*Wait Window "New Ol_NO Begins From  "+alltrim(m.autol_no)
