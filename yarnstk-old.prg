*******White Yarn Stock - White Yarn Stock Detail and Summary Report
Procedure Querygen
SET TALK OFF
SET SAFE OFF
SET DATE TO BRITI
open database carpet

CREATE CURSOR REPSTOCKY (QUALITY C(10), LOCATION C(10), NETWT N(12,3), INQTY N(12,3), ORDQTY N(12,3), RECQTY N(12,3), ISSQTY N(12,3),;
                         INQTYM N(12,3), ORDQTYM N(12,3), RECQTYM N(12,3), ISSQTYM N(12,3), RCODE C(3))

*******Calculate total till date, say if start date is 3/3/2014 all data previous to this date will go to opening ok 26/10/2014 Ramesh
SELECT QUALITY,NETWT,RCODE;
FROM YRNOP;
INTO CURSOR YOP

SELECT QUALITY, SUM(NETWT) NETWT,RCODE;
FROM YRECP SHARE;  && Inter yarn received for wool given
WHERE date<msdate;
GROUP BY QUALITY;
ORDER BY QUALITY;
INTO CURSOR YRR

SELECT QUALITY, SUM(NETWT) NETWT,RCODE;
FROM YRNORDER SHARE;
WHERE date<msdate;
GROUP BY QUALITY;
ORDER BY QUALITY;
INTO CURSOR YRO

SELECT QUALITY, SUM(NETWT) NETWT,RCODE;
FROM YRNRECVD SHARE;
WHERE recdt<msdate;
GROUP BY QUALITY;
ORDER BY QUALITY;
INTO CURSOR YRD

SELECT QUALITY, SUM(Quantity) NETWT,RCODE ;
FROM YRNISSDY SHARE;
WHERE date<msdate;
GROUP BY QUALITY;
ORDER BY QUALITY;
INTO CURSOR YRI

***CALCULATE MONTH TOTAL, we are calculating inbetween data ok 26/10/2014
SELECT QUALITY, SUM(NETWT) NETWT,PADR('MYR',3) as COD;
FROM YRECP SHARE;
WHERE date>=msdate .and. date<=medate;
GROUP BY QUALITY;
ORDER BY QUALITY;
INTO CURSOR YRRM

SELECT QUALITY, SUM(NETWT) NETWT,PADR('MOR',3) as COD;
FROM YRNORDER SHARE;
WHERE date>=msdate .and. date<=medate;
GROUP BY QUALITY;
ORDER BY QUALITY;
INTO CURSOR YROM

SELECT QUALITY, SUM(NETWT) NETWT,PADR('MPU',3) as COD;
FROM YRNRECVD SHARE;
WHERE recdt>=msdate .and. recdt<=medate;
GROUP BY QUALITY;
ORDER BY QUALITY;
INTO CURSOR YRDM

SELECT QUALITY, SUM(QUANTITY) NETWT,PADR('MIS',3) as COD;
FROM YRNISSDY SHARE;
WHERE date>=msdate .and. date<=medate;
GROUP BY QUALITY;
ORDER BY QUALITY;
INTO CURSOR YRIM

*---all data in same container distinguished by rcode
SELECT QUALITY,NETWT,RCODE;
FROM YOP;
UNION ALL;
SELECT QUALITY,NETWT,RCODE;
FROM YRR;
UNION ALL;
SELECT QUALITY,NETWT,RCODE;
FROM YRO;
UNION ALL;
SELECT QUALITY,NETWT,RCODE;
FROM YRD;
UNION ALL;
SELECT QUALITY,NETWT,RCODE;
FROM YRI;
UNION ALL;
SELECT QUALITY,NETWT,COD;
FROM YRRM;
UNION ALL;
SELECT QUALITY,NETWT,COD;
FROM YROM;
UNION ALL;
SELECT QUALITY,NETWT,COD;
FROM YRDM;
UNION ALL;
SELECT QUALITY,NETWT,COD;
FROM YRIM;
INTO CURSOR ystk

***** distribute all data according to fields
SELECT ystk 
DO WHILE .NOT. EOF()
SELECT REPSTOCKY
APPEN BLANK
repl quality with ystk->quality,rcode with ystk->rcode

do case
	case rcode='Opn'
		repl repstocky->NETWT with ystk->netwt
	case rcode='Rec'
		repl repstocky->INQTY with ystk->netwt
	case rcode='Ord'
		repl repstocky->ORDQTY with ystk->netwt
	case rcode='Pur'
		repl repstocky->RECQTY with ystk->netwt
	case rcode='Dye'
		repl repstocky->ISSQTY with ystk->netwt
	case rcode='MYR'
		repl repstocky->INQTYM with ystk->netwt
	case rcode='MOR'
		repl repstocky->ORDQTYM with ystk->netwt
	case rcode='MPU'
		repl repstocky->RECQTYM with ystk->netwt
	case rcode='MIS'
		repl repstocky->ISSQTYM with ystk->netwt
  endcase
   SELECT ystk
	IF .NOT. EOF()
	   SKIP
	ENDIF
ENDDO

***smmation on quality
SELECT QUALITY,LOCATION, SUM(NETWT) NETWT, SUM(INQTY) INQTY, SUM(ORDQTY) ORDQTY, SUM(RECQTY) RECQTY, SUM(ISSQTY) ISSQTY,;
								SUM(INQTYM) INQTYM, SUM(ORDQTYM) ORDQTYM, SUM(RECQTYM) RECQTYM,SUM(ISSQTYM) ISSQTYM;
FROM REPSTOCKY;
GROUP BY QUALITY;
ORDER BY QUALITY;
INTO CURSOR REPSTOCKY1
RETURN
**END OF Querygen

****all Quality -ve,+ve all stock report
Procedure Detailrep
Do Case
  Case !Empty(m.QUALITY) .and. m.chk2=0 
	SELECT * ;
	FROM REPSTOCKY1;
	HAVING QUALITY=m.QUALITY;
	ORDER BY QUALITY;
	INTO CURSOR REP3

  Case Empty(m.QUALITY) .and. m.chk2=0 
	SELECT * ;
	FROM REPSTOCKY1;
	ORDER BY QUALITY;
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

****Only -ve Stock Balance
Procedure Detailrep1
Do Case
  Case !Empty(m.QUALITY) .and. m.chk2=1
	SELECT * ;
	FROM REPSTOCKY1;
	WHERE NETWT+RECQTY+RECQTYM+INQTY-ISSQTY-ISSQTYM<0 ;
	HAVING QUALITY=m.QUALITY;
	ORDER BY QUALITY;
	INTO CURSOR REP3

Case Empty(m.QUALITY) .and. m.chk2=1
	SELECT * ;
	FROM REPSTOCKY;
	WHERE NETWT+RECQTY+RECQTYM+INQTY-ISSQTY-ISSQTYM<0 ;
	HAVING QUALITY=m.QUALITY;
	ORDER BY QUALITY;
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
		Report form yarnstk.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yarnstk.frx to printer prompt noconsole
Endcase
Endif
RETURN




