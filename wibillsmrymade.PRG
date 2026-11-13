***Summaprty Report Bill Made
Select Min(date) from  REPSTOCK Where !empty(Slipno) into cursor mindate
select mindate
msdate=mindate->min_date
Select max(date) from  REPSTOCK Where !empty(Slipno) into cursor maxdate
select maxdate
medate=maxdate->Max_date
*********************************************
SELECT PARTY,QUALITY,RCOD,RRATE,SUM(RETNQTY) AS RETNQTY,IRATE,SUM(ISSQTY) AS ISSQTY,SUM(AMT) AS AMT,SLIPNO;
FROM REPSTOCK;
Where !empty(Slipno);
GROUP BY RCOD,QUALITY;
ORDER BY Slipno Desc, RCOD,QUALITY;
INTO CURSOR REP3
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form wibillpartys.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wibillpartys.frx to printer prompt noconsole
Endcase
Endif
