*Cacluate maximum value of Cabuyord Number, increase by 1 seeing no. of copy 
*In ol_no we mix lotno/ctrl_no which is full carpet no. for TCM
Public m.autol_no
Local m.maxol_no

Select max(val(ctrl_no)) as maxno;
From cabuyord;
Into Cursor curmax

select curmax
m.maxol_no=int(curmax->maxno)
if m.maxol_no>=1
	m.autol_no=padl(Alltrim(str(m.maxol_no+1)),5,'0')
else
	m.autol_no='00001'
endif
*?m.autol_no