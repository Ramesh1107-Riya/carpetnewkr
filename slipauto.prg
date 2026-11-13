*Cacluate maximum value Slipno, increase by 1 seeing no. of copy 
*Must find Highest slip no from both wiissue.dbf/ wireturn.dbf
Public m.pslipauto 
Private m.maxol_no,maxretuno,m.highiss,m.highrcd

Select max(val(slipno)) as maxiss;
From Carpet!wiissue;
Into Cursor cmaxiss

Select max(val(slipno)) as maxretn;
From Carpet!wireturn;
Into Cursor cretn

select cmaxiss
m.highiss=cmaxiss->maxiss
select cretn
m.highrcd=cretn->maxretn

if m.highiss>m.highrcd
	m.maxol_no=m.highiss
else
	m.maxol_no=m.highrcd
endif

if m.maxol_no>1 
	m.pslipauto =STR(m.maxol_no+1,5,0)
else
	m.pslipauto =STR(10001,5,0)
endif


