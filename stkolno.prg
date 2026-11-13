*Cacluate maximum value of Stkcarpet Ol No. Number, increase by 1 seeing no. of copy 
*This ol no not used instead carpet no is used
Public m.sautol_no
Private maxol_no
Select max(val(carpetno)) as maxno;
From Carpet!stkcarpet;
Into Cursor curmax

select curmax
maxol_no=curmax->maxno
if m.maxol_no>1
	m.sautol_no=STR(m.maxol_no+1,10,0)
else
	m.sautol_no=STR(500001,10,0)
endif
