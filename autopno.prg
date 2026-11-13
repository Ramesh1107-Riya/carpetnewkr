*Cacluate maximum value of Pono, increase by 1  
Public m.Pautopono
Local m.ThisYear, m.StoreYear, NewPono
m.ThisYear='18'
m.StoreYear='29'
m.Maxno=1

Select max(val(po_no)) as maxno;
From cabuyord;
Into Cursor cpono

Do case
	case (year(date())=2018)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif
	Case (year(date())=2019)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif
	Case (year(date())=2020)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif
	Case (year(date())=2021)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif
	Case (year(date())=2021)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif	
	Case (year(date())=2022)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif	
	Case (year(date())=2023)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif	
	Case (year(date())=2024)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif	
	Case (year(date())=2025)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif					
	Case (year(date())=2026)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif					
	Case (year(date())=2027)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif					
	Case (year(date())=2028)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif					
	Case (year(date())=2029)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif					
	Case (year(date())=2030)
		if !empty(cpono->maxno) 
			m.StoreYear=Substr(Alltrim(Str(cpono->maxno)),1,2)
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		else
			m.ThisYear=Substr(alltrim(str(year(date()))),3)
		endif					
Endcase

if(m.ThisYear=m.StoreYear)
	NewPono=Alltrim(Str(int(cpono->maxno+1)))
else
	NewPono=m.ThisYear+PADL(1,4,'0')
endif
m.Pautopono=NewPono