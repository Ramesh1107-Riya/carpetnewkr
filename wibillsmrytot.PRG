***Summaprty Report Bill Made
Select Min(date) from  REPSTOCK Where !empty(Billno) into cursor mindate
select mindate
msdate=mindate->min_date
Select max(date) from  REPSTOCK Where !empty(Billno) into cursor maxdate
select maxdate
medate=maxdate->Max_date
*********************************************
SELECT PARTY,DATE,BILLNO,SUM(RETNQTY) AS RETNQTY,SUM(ISSQTY) AS ISSQTY,SUM(AMT) AS AMT;
FROM REPSTOCK;
Where !empty(Billno);
GROUP BY BILLNO,Date,Party;
ORDER BY Billno,Date,Party;
INTO CURSOR REP3
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form wibillsmrytot.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wibillsmrytot.frx to printer prompt noconsole
Endcase
Endif
