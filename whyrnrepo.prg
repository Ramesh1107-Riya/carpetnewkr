*******White Yarn Stock - White Yarn Stock Detail and Summary Report
Procedure Querygen
SET TALK OFF
SET SAFE OFF
SET DATE TO BRITI
**11/02/2025 Added for white yarn stock
Local msdate
msdate={^2024/07/16}
open database carpet
CREAT CURSOR REPSTK(QUALITY C(10),COLOUR C(10),OPQTY N(12,3),PURQTY N(12,3),ISSDYQTY N(12,3),ISSUPQTY N(12,3),RETSUPQTY N(12,3), RCOD C(4))
*******Calculate total till date, say if start date is 3/3/2014 all data previous to this date will go to opening ok 26/10/2014 Ramesh
*1) White Yarn Opening
SELECT QUALITY,COLOUR,NETWT,PADR('YOP1',4) as RCOD;
FROM YRNOP;
INTO CURSOR YOP

*2) White Yarn Purchase
SELECT QUALITY,COLOUR,SUM(NETWT) NETWT,PADR('YPU1',4) as RCOD;
FROM YRNRECVD;
WHERE recdt>=msdate .and. recdt<=medate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR YPU

*5) White Yarn Issue to Dyeing
SELECT QUALITY,COLOUR, SUM(QUANTITY) NETWT,PADR('YID1',4) as RCOD;
FROM YRNISSDY ;
WHERE date>=msdate .and. date<=medate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR YID

*6) White Yarn Issue to Supplier where Wash='N'
SELECT i.QUALITY,i.COLOUR,SUM(i.QUANTITY) NETWT,PADR('WIS1',4) as RCOD;
FROM WIISSUE i,  YRNOP j;
WHERE i.QUALITY=j.QUALITY .AND. i.COLOUR=j.COLOUR .AND. i.date>=msdate .and. i.date<=medate;
GROUP BY i.QUALITY,i.COLOUR;
ORDER BY i.QUALITY,i.COLOUR;
INTO CURSOR WIS

*7) White Yarn Return From Supplier where Wash='N'
SELECT i.QUALITY,i.COLOUR,SUM(i.QUANTITY) NETWT,PADR('WIR1',4) as RCOD;
FROM WIRETURN i, YRNOP j;
WHERE i.QUALITY=j.QUALITY .AND. i.COLOUR=j.COLOUR .AND. i.date>=msdate .and. i.date<=medate;
GROUP BY i.QUALITY,i.COLOUR;
ORDER BY i.QUALITY,i.COLOUR;
INTO CURSOR WIR
***************************************************************************************************************************
*---all data in same container distinguished by rcode
SELECT QUALITY,COLOUR,NETWT,RCOD;
FROM YOP;
UNION ALL;
SELECT QUALITY,COLOUR,NETWT,RCOD;
FROM YPU;
UNION ALL;
SELECT QUALITY,COLOUR,NETWT,RCOD;
FROM YID;
UNION ALL;
SELECT QUALITY,COLOUR,NETWT,RCOD;
FROM WIS;
UNION ALL;
SELECT QUALITY,COLOUR,NETWT,RCOD;
FROM WIR;
INTO CURSOR STK1

***** distribute all data according to fields
SELECT  STK1
DO WHILE .NOT. EOF()
SELECT REPSTK
APPEN BLANK
repl quality with  STK1->quality,colour with STK1->colour,rcod with  STK1->rcod
do case
	case rcod='YOP1'
		repl REPSTK->OPQTY with stk1->netwt
	case rcod='YPU1'
		repl REPSTK->PURQTY with stk1->netwt
	case rcod='YID1'
		repl REPSTK->ISSDYQTY with stk1->netwt	
	case rcod='WIS1'
		repl REPSTK->ISSUPQTY with stk1->netwt
	case rcod='WIR1'
		repl REPSTK->RETSUPQTY with stk1->netwt
  endcase
   SELECT STK1
	IF .NOT. EOF()
	   SKIP
	ENDIF
ENDDO

***smmation on quality
SELECT QUALITY,COLOUR,SUM(OPQTY) OPQTY, SUM(PURQTY) PURQTY, SUM(ISSDYQTY) ISSDYQTY,SUM(ISSUPQTY) ISSUPQTY,SUM(RETSUPQTY) RETSUPQTY;
FROM REPSTK;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR REPSTOCKY2

SELECT QUALITY,COLOUR,OPQTY,PURQTY,ISSDYQTY,OPQTY+PURQTY-ISSDYQTY-ISSUPQTY+RETSUPQTY AS BALANCE;
FROM REPSTOCKY2;
ORDER BY QUALITY,COLOUR;
INTO CURSOR REPSTOCKY1
RETURN
**END OF Querygen

Procedure whitestk
SELECT QUALITY,COLOUR,sum(BALANCE) as Balance;
FROM REPSTOCKY1;
Group by Quality;
ORDER BY QUALITY,COLOUR;
INTO CURSOR WhtStock
RETURN

****all Quality -ve,+ve all stock report
Procedure Detailrep
Do Case
  Case !Empty(m.QUALITY) .and. !empty(m.Colour) .and.  m.chk1=0 
	SELECT QUALITY,COLOUR,OPQTY,PURQTY,ISSDYQTY,BALANCE;
	FROM REPSTOCKY1;
	WHERE QUALITY=m.QUALITY .and. COLOUR=m.COLOUR .and. !empty(Balance);
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR REP3A
	
	SELECT r.QUALITY,r.Colour,r.BALANCE,w.RATE,w.DESC,w.YTYPE;
	FROM REP3A r;
	LEFT JOIN WIQLTY w;
	ON r.QUALITY=w.QUALITY;
	ORDER BY w.YTYPE;
	INTO CURSOR REP3B	

  Case !Empty(m.QUALITY)  .and. empty(m.Colour) .and.  m.chk1=0 
	SELECT QUALITY,COLOUR,OPQTY,PURQTY,ISSDYQTY,BALANCE;
	FROM REPSTOCKY1;
	WHERE QUALITY=m.QUALITY .and. !empty(Balance) ;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR REP3A
	
	SELECT r.QUALITY,r.Colour,r.BALANCE,w.RATE,w.DESC,w.YTYPE;
	FROM REP3A r;
	LEFT JOIN WIQLTY w;
	ON r.QUALITY=w.QUALITY;
	ORDER BY w.YTYPE;
	INTO CURSOR REP3B	
	
  Case Empty(m.QUALITY)  .and. !empty(m.Colour) .and.  m.chk1=0 
	SELECT QUALITY,COLOUR,OPQTY,PURQTY,ISSDYQTY,BALANCE;
	FROM REPSTOCKY1;
	WHERE COLOUR=m.COLOUR .and. !empty(Balance);
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR REP3A
	
	SELECT r.QUALITY,r.Colour,r.BALANCE,w.RATE,w.DESC,w.YTYPE;
	FROM REP3A r;
	LEFT JOIN WIQLTY w;
	ON r.QUALITY=w.QUALITY;
	ORDER BY w.YTYPE;
	INTO CURSOR REP3B	

  Case Empty(m.QUALITY)  .and. empty(m.Colour) .and.  m.chk1=0 
	SELECT QUALITY,COLOUR,OPQTY,PURQTY,ISSDYQTY,BALANCE;
	FROM REPSTOCKY1;
	Where !empty(Balance);
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR REP3A
	
	SELECT r.QUALITY,r.Colour,r.BALANCE,w.RATE,w.DESC,w.YTYPE;
	FROM REP3A r;
	LEFT JOIN WIQLTY w;
	ON r.QUALITY=w.QUALITY;
	ORDER BY w.YTYPE Desc;
	INTO CURSOR REP3B	
Endcase  
SELECT REP3B

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"	
		Report form whyrnrepod.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form whyrnrepod.frx to printer prompt noconsole
	Case m.PrnStat="S"
		EXPORT TO &exclfile TYPE XL5 FIELDS QUALITY,Colour,BALANCE,RATE,DESC,YTYPE
		Messagebox("Search [Undyed Yarn Stock Summary] Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File")
Endcase
Endif
RETURN

**** Qualitywise Report
Procedure SummaryRep
Do Case
Case Empty(m.QUALITY) .and. empty(m.Colour) 
	SELECT QUALITY,COLOUR,sum(OPQTY) opqty,sum(PURQTY) purqty,sum(ISSDYQTY) issdyqty,sum(BALANCE) balance;
	FROM REPSTOCKY1;
	GROUP BY QUALITY;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR REP3A
	
	**For Rate we join with wiqlty
	SELECT r.QUALITY,r.BALANCE,w.RATE,w.DESC,w.YTYPE;
	FROM REP3A r;
	LEFT JOIN WIQLTY w;
	ON r.QUALITY=w.QUALITY;
	Where !empty(r.Balance);
	ORDER BY w.YTYPE;
	INTO CURSOR REP3		
	
Case !Empty(m.QUALITY)  	
	SELECT QUALITY,COLOUR,sum(OPQTY) opqty,sum(PURQTY) purqty,sum(ISSDYQTY) issdyqty,sum(BALANCE) balance;
	FROM REPSTOCKY1;
	WHERE QUALITY=m.QUALITY;
	GROUP BY QUALITY;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR REP3A
	
	SELECT r.QUALITY,r.BALANCE,w.RATE,w.DESC,w.YTYPE;
	FROM REP3A r;
	LEFT JOIN WIQLTY w;
	ON r.QUALITY=w.QUALITY;
	Where !empty(r.Balance);
	ORDER BY w.YTYPE;
	INTO CURSOR REP3	
Endcase
SELECT REP3
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		*Report form yarnstk.frx to console preview in screen
		Report form whyrnrepos.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form whyrnrepos.frx to printer prompt noconsole
	Case m.PrnStat="S"
		EXPORT TO &exclfile TYPE XL5 FIELDS QUALITY,BALANCE,RATE,DESC,YTYPE
		Messagebox("Search [Undyed Yarn Stock Summary] Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File")
Endcase
Endif
RETURN




