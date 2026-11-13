***Summaprty Report Bill [NOT] Made - Yarn Purchase
Select Min(recdt) as min_date from  YRNPURD  Into cursor mindate
select mindate
msdate=mindate->min_date
Select max(recdt) as Max_date from  YRNPURD  Into cursor maxdate
select maxdate
medate=maxdate->Max_date

*Procedure To update slipno in yrnrecvd.dbf
********************Slip No. Printing***************************
If (m.PrnStat="P" .and. !empty(m.suplier))
	do slipautowy
	UPDATE yrnrecvd;
	SET slipno=m.pslipautowy; && change reqd
	WHERE recdt>=msdate .and. recdt<=medate .and. suplier=ALLTRIM(m.suplier) .and. empty(slipno)
Endif
**********end of slip update*************************************

SELECT SUPLIER,QUALITY,RATE,SUM(NETWT) AS NETWT,SUM(AMT) AS AMT,SLIPNO;	 
FROM YRNPURD;
Where empty(Slipno);
GROUP BY QUALITY;
ORDER BY QUALITY;
INTO CURSOR REP3


Select REP3
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrnpursmrynot.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrnpursmrynot.frx to printer prompt noconsole
Endcase
Endif

