**Procedure to print Particular Customer form Material Purchased (Dyed Yarn Store)
SET DELETED ON
SET TALK OFF
SET SAFE OFF
	*Array Declaration
	Dimension IsuBil(48) 
	Store ' ' to IsuBil
	Public IsuBil1,IsuBil2,IsuBil3,IsuBil4,IsuBil5,IsuBil6,IsuBil7,IsuBil8,IsuBil9,IsuBil10,IsuBil11,IsuBil12,;
		   IsuBil13,IsuBil14,IsuBil15,IsuBil16,IsuBil17,IsuBil18,IsuBil19,IsuBil20,IsuBil21,IsuBil22,IsuBil23,IsuBil24,;
		   IsuBil25,IsuBil26,IsuBil27,IsuBil28,IsuBil29,IsuBil30,IsuBil31,IsuBil32,IsuBil33,IsuBil34,IsuBil35,IsuBil36,;
		   IsuBil37,IsuBil38,IsuBil39,IsuBil40,IsuBil41,IsuBil42,IsuBil43,IsuBil44,IsuBil45,IsuBil46,IsuBil47,IsuBil48


Private WhereString
Do Case 
	Case !Empty(m.suplier) .and. !empty(m.slipno)
		WhereString='suplier=m.suplier .and. slipno=m.slipno'
	Case !Empty(m.suplier) .and. empty(m.slipno)
		WhereString='suplier=m.suplier'
	Case Empty(m.suplier) .and. !empty(m.slipno)
		WhereString='slipno=m.slipno'
	Case Empty(m.suplier) .and. empty(m.slipno)
		WhereString='empty(m.suplier)'
	Otherwise
		Messagebox("Please Make Correct Selection!!!",0)
Endcase
******Yarn Purchase Report Supplierwise Detail
	SELECT Recdt,recno,suplier,quality,netwt,rate,amt,slipno;
	FROM carpet!yrnrecvd;
	WHERE recdt>=msdate .and. recdt<=medate ;
	Having &WhereString;
	ORDER BY recdt,recno;
	INTO CURSOR yrnpurd Nofilter

************Material Purchase Bill No. Listing ***************
SELECT Distinct recno,Slipno; 
From yrnpurd;
Where !empty(slipno);
Into Cursor cRecdWy
		
Select cRecdWy
If !(RECNO()>RECCOUNT())
	Select Distinct recno;
	From cRecdWy;
	Where recno()<=48 .and. !empty(slipno);
	Order by recno desc;
	Into Array IsuSource
	
	ACOPY(IsuSource,IsuBil)			
	IsuBil1=IsuBil(1)
	IsuBil2=IsuBil(2)
	IsuBil3=IsuBil(3)
	IsuBil4=IsuBil(4)
	IsuBil5=IsuBil(5)
	IsuBil6=IsuBil(6)
	IsuBil7=IsuBil(7)
	IsuBil8=IsuBil(8)
	IsuBil9=IsuBil(9)
	IsuBil10=IsuBil(10)
	IsuBil11=IsuBil(11)
	IsuBil12=IsuBil(12)
	IsuBil13=IsuBil(13)
	IsuBil14=IsuBil(14)
	IsuBil15=IsuBil(15)
	IsuBil16=IsuBil(16)
	IsuBil17=IsuBil(17)
	IsuBil18=IsuBil(18)
	IsuBil19=IsuBil(19)
	IsuBil20=IsuBil(20)
	IsuBil21=IsuBil(21)
	IsuBil22=IsuBil(22)
	IsuBil23=IsuBil(23)
	IsuBil24=IsuBil(24)	
	IsuBil25=IsuBil(25)
	IsuBil26=IsuBil(26)
	IsuBil27=IsuBil(27)
	IsuBil28=IsuBil(28)
	IsuBil29=IsuBil(29)
	IsuBil30=IsuBil(30)
	IsuBil31=IsuBil(31)
	IsuBil32=IsuBil(32)
	IsuBil33=IsuBil(33)
	IsuBil34=IsuBil(34)
	IsuBil35=IsuBil(35)
	IsuBil36=IsuBil(36)
	IsuBil37=IsuBil(37)
	IsuBil38=IsuBil(38)	
	IsuBil39=IsuBil(39)
	IsuBil40=IsuBil(40)
	IsuBil41=IsuBil(41)
	IsuBil42=IsuBil(42)
	IsuBil43=IsuBil(43)
	IsuBil44=IsuBil(44)
	IsuBil45=IsuBil(45)
	IsuBil46=IsuBil(46)
	IsuBil47=IsuBil(47)
	IsuBil48=IsuBil(48)	
Else
	*Initialize array IsuBil(48)
	Local m.start,m.end,cnt
	m.start=1
	m.end=48
	For cnt=m.start to m.end STEP 1
		IsuBil(cnt)=' '
	Endfor
	
	IsuBil1=IsuBil(1)
	IsuBil2=IsuBil(2)
	IsuBil3=IsuBil(3)
	IsuBil4=IsuBil(4)
	IsuBil5=IsuBil(5)
	IsuBil6=IsuBil(6)
	IsuBil7=IsuBil(7)
	IsuBil8=IsuBil(8)
	IsuBil9=IsuBil(9)
	IsuBil10=IsuBil(10)
	IsuBil11=IsuBil(11)
	IsuBil12=IsuBil(12)
	IsuBil13=IsuBil(13)
	IsuBil14=IsuBil(14)
	IsuBil15=IsuBil(15)
	IsuBil16=IsuBil(16)
	IsuBil17=IsuBil(17)
	IsuBil18=IsuBil(18)
	IsuBil19=IsuBil(19)
	IsuBil20=IsuBil(20)
	IsuBil21=IsuBil(21)
	IsuBil22=IsuBil(22)
	IsuBil23=IsuBil(23)
	IsuBil24=IsuBil(24)	
	IsuBil25=IsuBil(25)
	IsuBil26=IsuBil(26)
	IsuBil27=IsuBil(27)
	IsuBil28=IsuBil(28)
	IsuBil29=IsuBil(29)
	IsuBil30=IsuBil(30)
	IsuBil31=IsuBil(31)
	IsuBil32=IsuBil(32)
	IsuBil33=IsuBil(33)
	IsuBil34=IsuBil(34)
	IsuBil35=IsuBil(35)
	IsuBil36=IsuBil(36)
	IsuBil37=IsuBil(37)
	IsuBil38=IsuBil(38)	
	IsuBil39=IsuBil(39)
	IsuBil40=IsuBil(40)
	IsuBil41=IsuBil(41)
	IsuBil42=IsuBil(42)
	IsuBil43=IsuBil(43)
	IsuBil44=IsuBil(44)
	IsuBil45=IsuBil(45)
	IsuBil46=IsuBil(46)
	IsuBil47=IsuBil(47)
	IsuBil48=IsuBil(48)	
Endif
Return
	




**END OF Querygen - Very Important Note

* Do yrnpurcsmrymade -> White Yarn Purchase suplier Summary Bill Made
* Do yrnpurcsmrynot -> White Yarn Purchase suplier Summary Bill Not Made
* Do yrnpurcsmrymade -> suplier Detail Bill made
* Do yrnpurchdtlmade -> suplier Detail bILL Not mae