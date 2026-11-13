*Cacluate maximum value of master graph no
Public m.masterno
Private m.maxmastno
Select max(val(master_nr)) as master_nr  ;
From grmaster;
Into Cursor crmaxno

Select crmaxno
m.maxmastno=crmaxno->master_nr
If m.maxmastno>1
	m.masterno=STR(m.maxmastno+1,10,0)
Else
	m.masterno=STR(1001,10,0)
Endif
*Wait Window "New Master Graph No is  "+alltrim(m.masterno)

