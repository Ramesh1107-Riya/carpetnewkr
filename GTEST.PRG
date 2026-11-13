Private m.Requdno, m.DesignR, m.SzcodeR, m.QualityR, m.FullHalfR
m.Requdno=ThisForm.RequdNo1.Value
m.DesignR=ThisForm.Design1.value
m.SzcodeR=ThisForm.Szcode1.value
m.Quality=ThisForm.Quality1.value
m.FullHalf=ThisForm.FullHalf.value

SELECT Count(design) as ctndgn;
From grregster;
WHERE ir='S' .and. Design=m.DesignR;
Into Cursor cDegn

IF cDegn->ctndgn>m.Requdno
	Messagebox("Graph for this Design is Insufficent in Stock")
	ThisForm.RequdNo1.Setfocus()
Else
	Local m.Startno, m.Endno, grpCount
	m.Startno=1
	m.Endno=ThisForm.RequdNo1.value-1
 FOR grpCount=m.Startno to m.Endno STEP 1
 Select Grregstr
 Locate For Alltrim(Design)= m.DesignR .and. Alltrim(Szcode)=m.SzcodeR .and. Alltrim(Quality)=m.QualityR .and. Alltrim(FullHalf)=m.FullHalfR .and. Alltrim(IR)='S'
	If Found() .and. m.allow=.T.
		m.reg_nr=Grregstr.reg_nr
		Replace Ir with "I"
		Select GrSupTran
		Insert Into GrSupTran(Reg_nr, Supplier, Issdt,IssRate, Remark, SupIr);
	        	 	 VALUES (m.reg_nr, m.supplier, m.issdt, m.IRate, m.remark, m.SupIr)
	    Wait Window "Graph Register and Supplier Transaction Updated!!" Timeout 3
	Else
		Wait Window"Register No. Not Found/ Can Not Cross Max Limit of Graph to Supplier , Data Not Updated" Timeout 3
	Endif
 ENDFOR
ENDIF