*Cacluate maximum value of Register Number, increase by 1 seeing no. of copy 
Public m.pureg_no
Private m.maxreg_no
Select max(val(reg_nr)) as mreg_nr;
From Carpet!grregstr;
Into cursor curmaxr

Select curmaxr
m.maxreg_no=curmaxr->mreg_nr
If m.maxreg_no>1
	m.pureg_no=STR(m.maxreg_no+1,10,0)
else
	m.pureg_no=STR(20001,10,0)
endif

*Wait Window "New Register No. Begins From  "+alltrim(m.pureg_no)

