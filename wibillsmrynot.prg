***Summaprty Report Bill [NOT] Made
Select Min(date) from  REPSTOCK Where empty(Slipno) into cursor mindate
select mindate
msdate=mindate->min_date
Select max(date) from  REPSTOCK Where empty(Slipno) into cursor maxdate
select maxdate
medate=maxdate->Max_date
*********************************************

*Procedure Querygen
********************Slip No. Update  ***************************
If (m.PrnStat="P" .and. !empty(m.party))
	do slipauto
	UPDATE Carpet!wiissue;
	SET slipno=m.pslipauto;
	WHERE date>=msdate .and. date<=medate .and. party=m.party .and. empty(slipno)
	
	UPDATE Carpet!wireturn;
	SET slipno=m.pslipauto;
	WHERE date>=msdate .and. date<=medate .and. party=m.party .and. empty(slipno)
Endif
*******************Endi of Slip No. Update***************************	

SELECT PARTY,QUALITY,RCOD,RRATE,SUM(RETNQTY) AS RETNQTY,IRATE,SUM(ISSQTY) AS ISSQTY,SUM(AMT) AS AMT,SLIPNO;
FROM REPSTOCK;
Where empty(Slipno);
GROUP BY RCOD,QUALITY;
ORDER BY RCOD,QUALITY;
INTO CURSOR REP3
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form wibillpartysnot.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wibillpartysnot.frx to printer prompt noconsole
Endcase
Endif
