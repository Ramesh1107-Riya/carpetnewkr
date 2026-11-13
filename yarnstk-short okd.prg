*******White Yarn Stock - White Yarn Stock Detail and Summary Report
Procedure Querygen
SET TALK OFF
SET SAFE OFF
SET DATE TO BRITI
open database carpet

*1) White Yarn Opening
SELECT QUALITY,COLOUR,NETWT AS OPQTY;
FROM YRNOP;
INTO CURSOR YOP

*2) White Yarn Purchase
SELECT QUALITY,COLOUR,SUM(NETWT) PURQTY;
FROM YRNRECVD;
WHERE recdt<msdate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR YPU

*3) White Yarn Issue to Washing
SELECT QUALITY,COLOUR,SUM(QTY) WSHIQTY;
FROM YRNWSHISS ;
WHERE date<msdate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR YWI

*4) White Yarn Received From Washing
SELECT QUALITY,COLOUR,SUM(QTY) WSHRQTY;
FROM YRNWSHRCD ;
WHERE date<msdate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR YWR

*5) White Yarn Issue to Dyeing
SELECT QUALITY,COLOUR, SUM(QUANTITY) ISSDYQTY;
FROM YRNISSDY SHARE;
WHERE date<msdate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR YID

*6) White Yarn Issue to Supplier where Wash='N'
SELECT QUALITY,COLOUR,SUM(QUANTITY) ISSUPQTY;
FROM WIISSUE;
WHERE date<msdate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR WIS

*7) White Yarn Return From Supplier where Wash='N'
SELECT QUALITY,COLOUR,SUM(QUANTITY) RETSUPQTY;
FROM WIRETURN;
WHERE date<msdate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR WIR
*******************************************************************
*
***CALCULATE MONTH TOTAL, we are calculating inbetween data ok 26/10/2014
*2M) White Yarn Purchase
SELECT QUALITY,COLOUR,SUM(NETWT) PURQTYM;
FROM YRNRECVD;
WHERE recdt>=msdate .and. recdt<=medate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR YPUM

*3M) White Yarn Issue to Washing
SELECT QUALITY,COLOUR,SUM(QTY) WSHIQTYM;
FROM YRNWSHISS ;
WHERE date>=msdate .and. date<=medate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR YWIM

*4M) White Yarn Received From Washing
SELECT QUALITY,COLOUR,SUM(QTY) WSHRQTYM;
FROM YRNWSHRCD ;
WHERE date>=msdate .and. date<=medate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR YWRM

*5M) White Yarn Issue to Dyeing
SELECT QUALITY,COLOUR, SUM(QUANTITY) ISSDYQTYM;
FROM YRNISSDY SHARE;
WHERE date>=msdate .and. date<=medate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR YIDM

*6M) White Yarn Issue to Supplier where Wash='N'
SELECT QUALITY,COLOUR,SUM(QUANTITY) ISSUPQTYM;
FROM WIISSUE;
WHERE date>=msdate .and. date<=medate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR WISM

*7M) White Yarn Return From Supplier where Wash='N'
SELECT QUALITY,COLOUR,SUM(QUANTITY) RETSUPQTYM;
FROM WIRETURN;
WHERE date>=msdate .and. date<=medate;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR WIRM
******************************************************************************************************
SELECT p.QUALITY,p.COLOUR,p.OPQTY,d.PURQTY,q.WSHIQTY,c.WSHRQTY,i.ISSDYQTY ,j.ISSUPQTY,k.RETSUPQTY;
FROM YOP p;  											
LEFT OUTER JOIN YPU d;								
	ON p.Colour=d.Colour .and. p.Quality=d.Quality;
LEFT OUTER JOIN YWI q;							
	ON p.Colour=q.Colour .and. p.Quality=q.Quality;
LEFT OUTER JOIN YWR c;							
	ON p.Colour=c.Colour .and. p.Quality=c.Quality;
LEFT OUTER JOIN YID i;							    
	ON p.Colour=i.Colour .and. p.Quality=i.Quality;
LEFT OUTER JOIN WIS j;								
	ON p.Colour=j.Colour .and. p.Quality=j.Quality;
LEFT OUTER JOIN WIR k;								
	ON p.Colour=k.Colour .and. p.Quality=k.Quality;
ORDER BY p.QUALITY,p.COLOUR;
INTO CURSOR STK1

**********************Monthly Calculation***************************************************************
SELECT p.QUALITY,p.COLOUR,d.PURQTYM,q.WSHIQTYM,c.WSHRQTYM,i.ISSDYQTYM,j.ISSUPQTYM,k.RETSUPQTYM;
FROM YOP p;  							 				
LEFT OUTER JOIN YPUM d;								
	ON p.Colour=d.Colour .and. p.Quality=d.Quality;
LEFT OUTER JOIN YWIM q;							
	ON p.Colour=q.Colour .and. p.Quality=q.Quality;
LEFT OUTER JOIN YWRM c;							
	ON p.Colour=c.Colour .and. p.Quality=c.Quality;
LEFT OUTER JOIN YIDM i;							    
	ON p.Colour=i.Colour .and. p.Quality=i.Quality;
LEFT OUTER JOIN WISM j;								
	ON p.Colour=j.Colour .and. p.Quality=j.Quality;
LEFT OUTER JOIN WIRM k;								
	ON p.Colour=k.Colour .and. p.Quality=k.Quality;
ORDER BY p.QUALITY,p.COLOUR;
INTO CURSOR STK2

SELECT i.QUALITY,i.COLOUR,i.OPQTY,i.PURQTY,i.WSHIQTY,i.WSHRQTY,i.ISSDYQTY,i.ISSUPQTY,i.RETSUPQTY,j.PURQTYM,j.WSHIQTYM,j.WSHRQTYM,j.ISSDYQTYM,j.ISSUPQTYM,j.RETSUPQTYM;
FROM STK1 i, STK2 j;
Where i.QUALITY=J.QUALITY .and. i.Colour=j.Colour;
INTO Cursor Repstocky2

SELECT QUALITY,COLOUR,OPQTY,PURQTY,WSHIQTY,WSHRQTY,ISSDYQTY,ISSUPQTY,RETSUPQTY,PURQTYM,WSHIQTYM,WSHRQTYM,ISSDYQTYM,ISSUPQTYM,RETSUPQTYM,;
		OPQTY+PURQTY-WSHIQTY+WSHRQTY-ISSDYQTY-ISSUPQTY+RETSUPQTY+PURQTYM-WSHIQTYM+WSHRQTYM-ISSDYQTYM-ISSUPQTYM+RETSUPQTYM AS BALANCE;
FROM REPSTOCKY2;
ORDER BY QUALITY,COLOUR;
INTO CURSOR REPSTOCKY1
RETURN
**END OF Querygen
****all Quality -ve,+ve all stock report
Procedure Detailrep
Do Case
  Case !Empty(m.QUALITY) .and. !empty(m.Colour) .and.  m.chk1=0 
	SELECT QUALITY,COLOUR,OPQTY,PURQTY,WSHIQTY,WSHRQTY,ISSDYQTY,ISSUPQTY,RETSUPQTY,PURQTYM,WSHIQTYM,WSHRQTYM,ISSDYQTYM,ISSUPQTYM,RETSUPQTYM,BALANCE;
	FROM REPSTOCKY1;
	WHERE QUALITY=m.QUALITY .and. COLOUR=m.COLOUR;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR REP3

  Case !Empty(m.QUALITY)  .and. empty(m.Colour) .and.  m.chk1=0 
	SELECT QUALITY,COLOUR,OPQTY,PURQTY,WSHIQTY,WSHRQTY,ISSDYQTY,ISSUPQTY,RETSUPQTY,PURQTYM,WSHIQTYM,WSHRQTYM,ISSDYQTYM,ISSUPQTYM,RETSUPQTYM,BALANCE;
	FROM REPSTOCKY1;
	WHERE QUALITY=m.QUALITY;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR REP3
	
  Case Empty(m.QUALITY)  .and. !empty(m.Colour) .and.  m.chk1=0 
	SELECT QUALITY,COLOUR,OPQTY,PURQTY,WSHIQTY,WSHRQTY,ISSDYQTY,ISSUPQTY,RETSUPQTY,PURQTYM,WSHIQTYM,WSHRQTYM,ISSDYQTYM,ISSUPQTYM,RETSUPQTYM,BALANCE;
	FROM REPSTOCKY1;
	WHERE COLOUR=m.COLOUR;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR REP3

  Case Empty(m.QUALITY)  .and. empty(m.Colour) .and.  m.chk1=0 
	SELECT QUALITY,COLOUR,OPQTY,PURQTY,WSHIQTY,WSHRQTY,ISSDYQTY,ISSUPQTY,RETSUPQTY,PURQTYM,WSHIQTYM,WSHRQTYM,ISSDYQTYM,ISSUPQTYM,RETSUPQTYM,BALANCE;
	FROM REPSTOCKY1;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR REP3
Endcase  
SELECT REP3
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yarnstk.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yarnstk.frx to printer prompt noconsole
Endcase
Endif
RETURN

**** Qualitywise Report
Procedure SummaryRep
Do Case
Case Empty(m.QUALITY) .and. empty(m.Colour) 
	SELECT QUALITY,COLOUR,sum(OPQTY) opqty,sum(PURQTY) purqty,sum(WSHIQTY) wshiqty,sum(WSHRQTY) wshrqty,sum(ISSDYQTY) issdyqty,sum(ISSUPQTY) issupqty,sum(RETSUPQTY) retsupqty,;
	sum(PURQTYM) purqtym,sum(WSHIQTYM) wshiqtym,sum(WSHRQTYM) wshrqtym,sum(ISSDYQTYM) issdyqtym,sum(ISSUPQTYM) issupqtym, sum(RETSUPQTYM) retsupqtym,sum(BALANCE) balance;
	FROM REPSTOCKY1;
	GROUP BY QUALITY;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR REP3
Case !Empty(m.QUALITY)  	
	SELECT QUALITY,COLOUR,sum(OPQTY) opqty,sum(PURQTY) purqty,sum(WSHIQTY) wshiqty,sum(WSHRQTY) wshrqty,sum(ISSDYQTY) issdyqty,sum(ISSUPQTY) issupqty,sum(RETSUPQTY) retsupqty,;
	sum(PURQTYM) purqtym,sum(WSHIQTYM) wshiqtym,sum(WSHRQTYM) wshrqtym,sum(ISSDYQTYM) issdyqtym,sum(ISSUPQTYM) issupqtym, sum(RETSUPQTYM) retsupqtym,sum(BALANCE) balance;
	FROM REPSTOCKY1;
	WHERE QUALITY=m.QUALITY;
	GROUP BY QUALITY;
	ORDER BY QUALITY,COLOUR;
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
		Report form yarnstksmry.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yarnstksmry.frx to printer prompt noconsole
Endcase
Endif
RETURN




