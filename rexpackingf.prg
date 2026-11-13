* SEA PACKING LIST report 
SET TALK OFF
SET SAFE OFF
OPEN DATABASE CARPET
Private m.invdt,m.bcode,m.termpay,m.lcno,m.dtd,m.goodsdesc,m.panno,m.name,m.add1,m.add2,m.add3,m.add4,m.add5,m.add6,m.add6,m.add7,m.add8,;
	m.sqmt1,m.sqmt2,m.sqmt3,m.sqmt4,m.sqmt5,m.sqmt6,m.knot1,m.knot2,m.knot3,m.knot4,m.knot5,m.knot6,m.twt,m.tsqmt,m.banker

Select *;
From expackingf;
where invno=m.invno ;
into cursor expk

**These variable for display in report
m.invdt = expk.invdt
m.bcode = expk.bcode
m.termpay = expk.termpay
m.lcno = expk.lcno
m.panno = expk.panno
m.dtd  = expk.dtd
m.banker = expk.banker
m.goodsdesc = expk.goodsdesc

m.name = expk.name
m.add1 = expk.add1
m.add2 = expk.add2
m.add3 = expk.add3
m.add4 = expk.add4
m.add5 = expk.add5
m.add6 = expk.add6
m.add7 = expk.add7
m.add8 = expk.add8

m.knot1 = expk.knot1	
m.knot2 = expk.knot2		
m.knot3 = expk.knot3	
m.knot4 = expk.knot4
m.knot5 = expk.knot5	
m.knot6 = expk.knot6
			
m.sqmt1 = expk.tsqmt1
m.sqmt2 = expk.tsqmt2
m.sqmt3 = expk.tsqmt3
m.sqmt4 = expk.tsqmt4
m.sqmt5 = expk.tsqmt5
m.sqmt6 = expk.tsqmt6
	
m.tsqmt = expk.tsqmt
m.twt   = expk.twt

CREATE SQL VIEW temprepview AS SELECT INVNO, BALENO, SLNO, PO_NO, OL_NO, DESIGN, COLOUR, SHIPBRTH, SHIPLNGTH, SQMT, BALEWT, FIELDCODE ;
FROM Carpet!Packtran;
Where Invno = m.invno;
ORDER BY SLNO

USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.chk1=0
		Report form expackingf.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.chk1=0
		Report form expackingf.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.chk1=1
		Report form expackingf1.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.chk1=1
		Report form expackingf1.frx to printer prompt noconsole
	Otherwise
		Messagebox("Invalid choice, make correct Choice!!")
Endcase
Endif
Return