***Detail Report Bill made - Yarn Purchase
*******Mindate & Maxdate for data in Date Range 
Select Min(recdt) as min_date from  YRNPURD Where !empty(Slipno) into cursor mindate
select mindate
msdate=mindate->min_date
Select max(recdt) as Max_date from  YRNPURD Where !empty(Slipno) into cursor maxdate
select maxdate
medate=maxdate->Max_date
*********************************************

SELECT SUPLIER,RECDT,RECNO,QUALITY,RATE,NETWT,AMT,SLIPNO;	 
FROM YRNPURD;
Where !empty(Slipno);
ORDER BY RecDt desc,Recno desc,Quality;
INTO CURSOR REP3

Select Rep3
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrnpurdtlmade.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnpurdtlmade.frx to printer prompt noconsole
Endcase
Endif


