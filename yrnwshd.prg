*******Procedure to print Particular Customer form wicolour, For Particular Colour
**Repstock same in both
SET DELETED ON
SET TALK OFF
SET SAFE OFF

Procedure Querygen
CREATE CURSOR REPSTOCK (SUPPLIER C(20),IDATE D(8),RDATE D(8),DELINO C(8),BILLNO C(8),QUALITY C(10),COLOUR C(10),IHANK N(5),RHANK N(5),RCDQTY N(11,3),;
		ISSQTY N(11,3),RCOD C(3),IRATE N(8,2),AMT N(11,2))

SELECT SUPPLIER,DATE,DELINO,PADR('',8) AS BILLNO,QUALITY,COLOUR,HANK,QTY,WSHRATE,AMT,PADR('ISS',3) as RCOD;
FROM YRNWSHISS;
WHERE date>=msdate .and. date<=medate .and. SUPPLIER=m.SUPPLIER;
ORDER BY DELINO,QUALITY,COLOUR;
INTO CURSOR ISSUE

SELECT SUPPLIER,DATE,DELINO,BILLNO,QUALITY,COLOUR,HANK,QTY, 0.00 AS WSHRATE, 0.00 AS AMT, PADR('RCD',3) as RCOD;
FROM YRNWSHRCD;
WHERE date>=msdate .and. date<=medate .and. SUPPLIER=m.SUPPLIER;
ORDER BY DELINO,QUALITY,COLOUR;
INTO CURSOR RETN
*BILLNO,WSHRATE,AMT,PAYDT,PAYYN,
*---all data in same container distinguished by rcode
SELECT SUPPLIER,DATE,DELINO,BILLNO,QUALITY,COLOUR,HANK,QTY,WSHRATE,AMT,PADR('ISS',3) as RCOD;
FROM ISSUE;
UNION ALL;
SELECT SUPPLIER,DATE,DELINO,BILLNO,QUALITY,COLOUR,HANK,QTY,WSHRATE,AMT,PADR('RCD',3) as RCOD;
FROM RETN;
INTO CURSOR wshstk

***** distribute all data according to fields
SELECT wshstk
DO WHILE .NOT. EOF()
SELECT REPSTOCK
APPEN BLANK

REPL quality with wshstk->quality,colour with wshstk->colour,rcod with wshstk->rcod, SUPPLIER with wshstk->SUPPLIER,delino with wshstk->delino
do case
	case rcod='ISS'
		repl repstock->IHank with wshstk->Hank, repstock->ISSQTY with wshstk->Qty,repstock->IRATE with wshstk->WshRate,;
					repstock->Amt with wshstk->amt,repstock->IDATE with wshstk->date
	case rcod='RCD'
		repl repstock->RHank with wshstk->Hank, repstock->RCDQTY with wshstk->Qty, repstock->BILLNO with wshstk->Billno,repstock->RDATE with wshstk->date
endcase
   SELECT wshstk
	IF .NOT. EOF()
	   SKIP
	ENDIF
ENDDO
RETURN
**END OF Querygen

***Summaprty Report
Procedure SumaryRep
SELECT SUPPLIER,QUALITY,DELINO,COLOUR,SUM(IHANK) IHANK,SUM(RHANK) RHANK,IRATE,SUM(RCDQTY) AS RCDQTY,SUM(ISSQTY) AS ISSQTY,SUM(AMT) AS AMT;
FROM REPSTOCK;
GROUP BY DELINO,QUALITY;
ORDER BY DELINO,QUALITY;
INTO CURSOR REP3

***Bill update removed 26/10/2017
*If (m.PrnStat="P" .and. !empty(m.supplier))
*	do autonowash
*UPDATE YrnWshIss;
*SET Slipno=alltrim(m.slipautno);
*WHERE delino IN (SELECT delino FROM Temp2) 
*Endif


If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrnwshsmy.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnwshsmy.frx to printer prompt noconsole
Endcase
Endif
RETURN

***Detail Report
Procedure DetailRep
SELECT SUPPLIER,QUALITY,RCOD,DELINO,COLOUR,IDATE,RDATE,IHANK,RHANK,BILLNO,IRATE,RCDQTY,ISSQTY,AMT;
FROM REPSTOCK;
INTO CURSOR REP3

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrnwshdtl.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnwshdtl.frx to printer prompt noconsole
Endcase
Endif
RETURN

