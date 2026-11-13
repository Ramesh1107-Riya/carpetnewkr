clea
Local m.maxno,m.pIssdtWash,m.cIssdtWash,m.cWashIslip,m.pWashIslip
m.cIssdtWash={^2019/07/16}

Select Max(Int(val(WashIslip))) as maxno;
From casupord;
Into Cursor maxval
Select maxval
m.maxno=maxval->maxno

Select Distin WashIslip,Issdtwash;
From Casupord;
Where Int(val(WashIslip))=m.maxno;
Into Cursor CWISP

Select CWISP
m.pIssdtWash=CWISP->IssdtWash
m.pWashIslip=CWISP->WashIslip
*m.pWashIslip=''
Do Case
	Case m.pIssdtWash=m.cIssdtWash
		If !empty(m.cWashIslip)
			?"Ist Case"
			m.cWashIslip=m.pWashIslip
		else	
			?"2nd Case"
			m.cWashIslip='5001'
		Endif
	Case m.pIssdtWash<>m.cIssdtWash
			?"3rd Case"
		m.cWashIslip=Int(val(WashIslip))+1
Endcase
?m.cWashIslip