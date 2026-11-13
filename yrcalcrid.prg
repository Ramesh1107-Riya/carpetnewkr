*Cacluate maximum value of Yrcalc.dbf field rid, increase by 1  
Public prid
Private maxrid
Select max(rid) as mrid;
From Carpet!yrcalc;
Into Cursor curmax

select curmax
maxrid=curmax->mrid
if m.maxrid>=1
	prid=STR(m.maxrid+1,4,0)
else
	prid=STR(1,4,0)
endif