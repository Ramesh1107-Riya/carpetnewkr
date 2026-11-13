*******Wool Stock - Wool Qualitywise Detail and Summary Report
SET DELETED ON
SET TALK OFF
SET SAFE OFF

Procedure Querygen
open database carpet
CREATE CURSOR WOOLSTK (WQLTY C(10), WTYPE C(10), BALES N(6), PBALES N(6), IBALES N(6),PMBALES N(6),IMBALES N(6),;
	NETWT N(12,3), RECQTY N(12,3),ISSQTY N(12,3),RECQTYM N(12,3),ISSQTYM N(12,3),COD C(2))

*******Calculate SUM till date
SELECT WQLTY,WTYPE,BALES,NETWT,PADR('WO',2) as cod;
FROM WOOLOP;
INTO CURSOR WOP

SELECT WQLTY,WTYPE,SUM(BALES) BALES, SUM(NETWT) NETWT,PADR('PU',2) as cod;
FROM carpet!WOOLPU SHARE;
WHERE date<msdate;
GROUP BY WQLTY,WTYPE;
ORDER BY WQLTY,WTYPE;
INTO CURSOR WPU

SELECT WQLTY,WTYPE,SUM(BALES) BALES, SUM(NETWT) NETWT,PADR('IS',2) as cod;
FROM carpet!WOOLISSU SHARE;
WHERE issdt<msdate;
GROUP BY WQLTY,WTYPE;
ORDER BY WQLTY,WTYPE;
INTO CURSOR WISS

***CALCULATE MONTH TOTAL
SELECT WQLTY,WTYPE,SUM(BALES) BALES, SUM(NETWT) NETWT,PADR('MP',2) as cod;
FROM WOOLPU SHARE;
WHERE date>=msdate .and. date<=medate;
GROUP BY WQLTY,WTYPE;
ORDER BY WQLTY,WTYPE;
INTO CURSOR WPUM

SELECT WQLTY,WTYPE,SUM(BALES) BALES, SUM(NETWT) NETWT,PADR('MI',2) as cod;
FROM WOOLISSU SHARE;
WHERE issdt>=msdate .and. issdt<=medate;
GROUP BY WQLTY,WTYPE;
ORDER BY WQLTY,WTYPE;
INTO CURSOR WISSM


*****PUT ALL THE DATA IN ONE CONTAINER****************
SELECT WQLTY,WTYPE,BALES,NETWT,COD;
FROM WPU;
UNION ALL;
SELECT WQLTY,WTYPE,BALES,NETWT,COD;
FROM WOP;
UNION ALL;
SELECT WQLTY,WTYPE,BALES,NETWT,COD;
FROM WISS;
UNION ALL;
SELECT WQLTY,WTYPE,BALES,NETWT,COD;
FROM WPUM;
UNION ALL;
SELECT WQLTY,WTYPE,BALES,NETWT,COD;
FROM WISSM;
INTO CURSOR wstk

Select wstk
do while .not. eof()
SELECT WOOLSTK
appen blank
repl wqlty with wstk->wqlty,cod with wstk->cod
repl wtype with wstk->wtype

do case 
	case cod='WO'
		repl woolstk->BALES with wstk->Bales, woolstk->NETWT with wstk->Netwt
   case cod='PU'
   		repl PBALES with wstk->Bales, RECQTY with wstk->Netwt
	case cod='IS'
		repl IBALES with wstk->Bales, ISSQTY with wstk->Netwt
	case cod='MP'
		repl PMBALES with wstk->Bales, RECQTYM with wstk->Netwt
	case cod='MI'
		repl IMBALES with wstk->Bales, ISSQTYM with wstk->Netwt
endcase
sele wstk
IF .NOT. EOF()
   SKIP
ENDIF
enddo

SELECT  WQLTY,WTYPE,SUM(BALES) BALES, SUM(PBALES) PBALES, SUM(IBALES) IBALES, SUM(PMBALES)PMBALES,SUM(IMBALES) IMBALES,;
		SUM(NETWT) NETWT, SUM(RECQTY) RECQTY, SUM(ISSQTY) ISSQTY, SUM(RECQTYM) RECQTYM, SUM(ISSQTYM) ISSQTYM;
FROM WOOLSTK;
GROUP BY WQLTY,WTYPE;
ORDER BY WQLTY,WTYPE;
INTO CURSOR WOOLSTK1

RETURN
**END OF Querygen


****all Quality -ve,+ve all stock report
Procedure Detailrep
Do Case
  Case !Empty(m.WQLTY) 
	SELECT * ;
	FROM WOOLSTK1;
	HAVING WQLTY=m.wqlty;
	ORDER BY WQLTY,WTYPE;
	INTO CURSOR REP3

  Case Empty(m.WQLTY) 
	SELECT * ;
	FROM WOOLSTK1;
	ORDER BY WQLTY,WTYPE;
	INTO CURSOR REP3
Endcase  

Select REP3
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		*Report form woolstk.frx to console preview in screen
		Report form woolstk.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form woolstk.frx to printer prompt noconsole
Endcase
Endif
RETURN

