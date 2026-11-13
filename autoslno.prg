*Cacluate maximum value of Bill No., increase by 1 seeing no. of copy 
*This ol no not used instead carpet no is used, Field Washtype=billautono storage
Public m.autslno
Local m.slno
Select max(slno) as maxno;
From calot;
Into Cursor curmax

select curmax
m.slno=curmax->maxno
if m.slno>1
	 m.autslno=m.slno+1
else
	 m.autslno=1
endif

