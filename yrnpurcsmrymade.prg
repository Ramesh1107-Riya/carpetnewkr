***Summaprty Report Bill Made  - Yarn Purchase
Select Min(recdt) as min_date from  YRNPURD Where !empty(Slipno) Into cursor mindate
select mindate
msdate=mindate->min_date
Select max(recdt) as Max_date from  YRNPURD Where !empty(Slipno) Into cursor maxdate
select maxdate
medate=maxdate->Max_date
********************************************* Need to Do
SELECT SUPLIER,RECDT,RECNO,QUALITY,RATE,sum(NETWT) as NETWT,sum(AMT) as AMT,SLIPNO;	 
FROM YRNPURD;
Where !empty(Slipno);
GROUP BY QUALITY;
ORDER BY Slipno Desc, QUALITY;
INTO CURSOR REP3

Select Rep3
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrnpursmrymade.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnpursmrymade.frx to printer prompt noconsole
Endcase
Endif

