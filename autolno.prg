*Cacluate maximum value of Pono, increase by 1  
Public m.Pautopono
Local m.ThisYear, m.StoreYear, NewPono
m.ThisYear='18'
m.StoreYear='29'
m.Maxno=1

Select max(val(po_no)) as maxno;
From capo;
Into Cursor cpono

if !empty(cpono->maxno)
	m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
	m.ThisYear=Substr(alltrim(str(year(date()))),3)
else
	m.ThisYear=Substr(alltrim(str(year(date()))),3)
endif

if(m.ThisYear=m.StoreYear)
	NewPono=Alltrim(Str(int(cpono->maxno+1)))
else
	NewPono=m.ThisYear+PADL(1,4,'0')
endif

m.Pautopono=NewPono