Local m.maxno,m.maxdt,m.preIssdtWash,m.crrIssdtWash,m.curWashIslip,m.preWashIslip
m.maxno=''
m.maxdt={}
m.curIssdtWash={}  
m.curIssdtWash=Date()  

*a) Max WashIslip
	Select Max(Int(val(WashIslip))) as maxno;
	From casupord;
	Into Cursor maxval

	Select maxval
	brow
	m.maxno=maxval->maxno
*b) Max Issdtwash 	
	Select Max(Issdtwash) as maxdt;
	From casupord;
	Into Cursor maxdate

	Select maxdate
	brow
	m.maxdt=maxdate->maxdt

Do Case
	Case Empty(m.maxdt)
		**Start New SlipNo
		ThisForm.WashIslip1.value='20001'
		
	Case m.maxdt=m.curIssdtWash
		**Find SlipNo for maxdt
		*Select Distin Issdtwash,WashIslip
		Select Distin Issdtwash,WashIslip;
		From Casupord;
		Where Issdtwash=m.maxdt;
		Into Cursor maxdate1
	
		Select maxdate1
		brow
		ThisForm.WashIslip1.value=alltrim(maxdate1->WashIslip)
	
	Case m.maxdt<m.curIssdtWash
		**Find SlipNo=SlipNo+1
		Select Distin WashIslip,Issdtwash;
		From Casupord;
		Where Int(val(WashIslip))=m.maxno;
		Into Cursor maxwis
		Select maxwis
		brow
		m.curWashIslip=Int(val(maxwis->WashIslip))+1  
		ThisForm.WashIslip1.value=Alltrim(STR(m.curWashIslip,5,0))

	Case m.maxdt>m.curIssdtWash
		**Find Old SlipNo for date Entered
		Select Distin Issdtwash,WashIslip;
		From Casupord;
		Where Issdtwash=m.curIssdtWash;
		Into Cursor oldslip
					
		Select oldslip
		brow
		*ThisForm.WashIslip1.value=alltrim(oldslip->WashIslip)
Endcase
***************************************************************
	
