**Procedure to print Particular Customer form wicolour, For Particular Colour
SET DELETED ON
SET TALK OFF
SET PROCEDURE TO Catool
SET SAFE OFF
	*Array Declaration
	Dimension IsuBil(48) 
	Store ' ' to IsuBil
	Dimension RetBil(24) 
	Store ' ' to RetBil
	Public IsuBil1,IsuBil2,IsuBil3,IsuBil4,IsuBil5,IsuBil6,IsuBil7,IsuBil8,IsuBil9,IsuBil10,IsuBil11,IsuBil12,;
		   IsuBil13,IsuBil14,IsuBil15,IsuBil16,IsuBil17,IsuBil18,IsuBil19,IsuBil20,IsuBil21,IsuBil22,IsuBil23,IsuBil24,;
		   IsuBil25,IsuBil26,IsuBil27,IsuBil28,IsuBil29,IsuBil30,IsuBil31,IsuBil32,IsuBil33,IsuBil34,IsuBil35,IsuBil36,;
		   IsuBil37,IsuBil38,IsuBil39,IsuBil40,IsuBil41,IsuBil42,IsuBil43,IsuBil44,IsuBil45,IsuBil46,IsuBil47,IsuBil48

	Public RetBil1,RetBil2,RetBil3,RetBil4,RetBil5,RetBil6,RetBil7,RetBil8,RetBil9,RetBil10,RetBil11,RetBil12,;
		  RetBil13,RetBil14,RetBil15,RetBil16,RetBil17,RetBil18,RetBil19,RetBil20,RetBil21,RetBil22,RetBil23,RetBil24

Private WhereString

Do Case 
	Case !Empty(m.party) .and. !empty(m.slipno)
		WhereString='party=m.party .and. slipno=m.slipno'
	Case !Empty(m.party) .and. empty(m.slipno)
		WhereString='party=m.party'
	Case Empty(m.party) .and. !empty(m.slipno)
		WhereString='slipno=m.slipno'
	Case Empty(m.party) .and. empty(m.slipno)
		WhereString='empty(m.party)'
	Otherwise
		Messagebox("Please Make Correct Selection!!!",0)
Endcase
		
CREATE CURSOR REPSTOCK (PARTY C(20),DATE D(8),BILLNO C(6),QUALITY C(10),COLOUR C(10),RETNQTY N(11,3),ISSQTY N(11,3),RCOD C(3),IRATE N(8,2),RRATE N(8,2),AMT N(11,2),SLIPNO C(5),PO_NO C(18),DESIGN C(20))
SELECT PARTY,DATE,BILLNO,QUALITY,COLOUR,QUANTITY,RATE,AMT,PADR('RTN',3) as RCOD,SLIPNO,PO_No,DESIGN;
FROM WIRETURN;
WHERE date>=msdate .and. date<=medate .AND. ccsMatch4A(WASHTYPE);
HAving &WhereString;
ORDER BY QUALITY,COLOUR;
INTO CURSOR RETN	

SELECT PARTY,DATE,BILLNO,QUALITY,COLOUR,QUANTITY,RATE,AMT,PADR('ISS',3) as RCOD,SLIPNO,PO_NO,DESIGN;
FROM WIISSUE;
WHERE date>=msdate .and. date<=medate .AND. ccsMatch4A(WASHTYPE);
HAVING &WhereString;
ORDER BY QUALITY,COLOUR;
INTO CURSOR ISSUE

SELECT Distinct Billno,Slipno; 
From Issue;
Where !empty(slipno);
Into Cursor Issue1
		
Select Issue1
If !(RECNO()>RECCOUNT())
	Select Distinct Billno;
	From Issue1;
	Where recno()<=48 .and. !empty(slipno);
	Order by billno desc;
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
	
**************Return Bill No. Listing************************************************
SELECT Distinct Billno,Slipno; 
From RETN;
Where !empty(slipno);
Into Cursor RETN1

SELECT RETN1
If !(RECNO()>RECCOUNT())
	Select Distinct Billno;
	From Retn1;
	Where recno()<=24 .and. !empty(slipno);
	Order by billno desc;
	Into Array RetSource

	ACOPY(RetSource,RetBil)
	
	RetBil1=RetBil(1)
	RetBil2=RetBil(2)
	RetBil3=RetBil(3)
	RetBil4=RetBil(4)
	RetBil5=RetBil(5)
	RetBil6=RetBil(6)
	RetBil7=RetBil(7)
	RetBil8=RetBil(8)
	RetBil9=RetBil(9)
	RetBil10=RetBil(10)
	RetBil11=RetBil(11)
	RetBil12=RetBil(12)	
	RetBil13=RetBil(13)
	RetBil14=RetBil(14)
	RetBil15=RetBil(15)
	RetBil16=RetBil(16)
	RetBil17=RetBil(17)
	RetBil18=RetBil(18)
	RetBil19=RetBil(19)
	RetBil20=RetBil(20)
	RetBil21=RetBil(21)
	RetBil22=RetBil(22)
	RetBil23=RetBil(23)
	RetBil24=RetBil(24)
Else
	*Array Initialization
	Local m.start,m.end,cnt
	m.start=1
	m.end=24
	For cnt=m.start to m.end STEP 1
		RetBil(cnt)=' '
	Endfor
	
	RetBil1=RetBil(1)
	RetBil2=RetBil(2)
	RetBil3=RetBil(3)
	RetBil4=RetBil(4)
	RetBil5=RetBil(5)
	RetBil6=RetBil(6)
	RetBil7=RetBil(7)
	RetBil8=RetBil(8)
	RetBil9=RetBil(9)
	RetBil10=RetBil(10)
	RetBil11=RetBil(11)
	RetBil12=RetBil(12)	
	RetBil13=RetBil(13)
	RetBil14=RetBil(14)
	RetBil15=RetBil(15)
	RetBil16=RetBil(16)
	RetBil17=RetBil(17)
	RetBil18=RetBil(18)
	RetBil19=RetBil(19)
	RetBil20=RetBil(20)
	RetBil21=RetBil(21)
	RetBil22=RetBil(22)
	RetBil23=RetBil(23)
	RetBil24=RetBil(24)
ENDIF
*********************************************************************************
*---all data in same container distinguished by rcode
SELECT PARTY,DATE,BILLNO,QUALITY,COLOUR,QUANTITY,RATE,AMT,RCOD,SLIPNO,PO_NO,DESIGN;
FROM RETN;
UNION ALL;
SELECT PARTY,DATE,BILLNO,QUALITY,COLOUR,QUANTITY,RATE,AMT,RCOD,SLIPNO,PO_NO,DESIGN;
FROM ISSUE;
INTO CURSOR wstk1

***** distribute all data according to fields
SELECT wstk1
DO WHILE .NOT. EOF()
SELECT REPSTOCK
APPEN BLANK

REPL quality with wstk1->quality,colour with wstk1->colour,rcod with wstk1->rcod, party with wstk1->party,date with wstk1->date,billno with wstk1->billno,;
	amt with wstk1->amt,slipno with wstk1->slipno,po_no with wstk1->po_no,design with wstk1->design 
do case
	case rcod='RTN'
		repl repstock->RETNQTY with wstk1->Quantity,repstock->RRATE with wstk1->Rate
	case rcod='ISS'
		repl repstock->ISSQTY with wstk1->Quantity,repstock->IRATE with wstk1->Rate
endcase
   SELECT wstk1
	IF .NOT. EOF()
	   SKIP
	ENDIF
ENDDO



**END OF Querygen

* Do wibillsmrymade -> Party Summary Bill Made
* Do wibillsmryNot  -> Party Summary Bill Not Made
* Do Wibilldetlmade -> Party Detail Bill made
* Do WibilldetlNot  -> party Detail bILL Not made
* Do Wibillissue    -> Issue Yarnt to Party detail
* Do Wibillreturn   -> Return Yarn form Party detail