clea
Local m.StartId,m.EndId,m.NewId1,m.NewId2
m.puAutno='100000'
m.StartId=val(m.autno)+1
m.EndId=m.StartId+12-1
For m.NewId1=m.StartId TO m.EndId STEP 1
	m.NewId2=PADL(Alltrim(STR(NewId1,6,0)),6,'0')
	?m.NewId2
Endfor

*Cacluate maximum value of Bill No., increase by 1 seeing no. of copy 
*autoid.prg used in Availabe stock to give automatic Id to Yarn return from supplier

Public m.puAutoID
Private m.max_id
Select max(val(id)) as maxno;
From Available;
Into Cursor curmax1

select curmax1
m.maxId=curmax1->maxno
if m.maxId>1
	m.puAutoId=STR(m.max_id+1,6,0)
else
	m.puAutoId=STR(100001,6,0)
endif

