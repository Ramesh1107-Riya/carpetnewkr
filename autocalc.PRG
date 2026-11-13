*Yarn Chart Calculation auto no
Public m.pautycalid
Local m.ycid
Select max(rid) as maxno;
From yrcalc;
Into Cursor crid

select crid
m.ycid=crid->maxno
if m.ycid>1
	 m.pautycalid=m.ycid+1
else
	 m.pautycalid=1
endif
