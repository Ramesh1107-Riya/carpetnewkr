***Detail Report Bill [NOT] made
SET PROCEDURE TO Catool
Select Min(date) from  REPSTOCK Where empty(Slipno) into cursor mindate
select mindate
msdate=mindate->min_date
Select max(date) from  REPSTOCK Where empty(Slipno) into cursor maxdate
select maxdate
medate=maxdate->Max_date
*********************************************

*Procedure Querygen
********************Slip No. Update  ***************************
If (m.PrnStat="P" .and. !empty(m.psparty))
	do slipauto
	UPDATE wiissue;
	SET slipno=m.pslipauto;
	WHERE date>=msdate .and. date<=medate .and. party=m.psparty .and. empty(slipno) 
	
	UPDATE wireturn;
	SET slipno=m.pslipauto;
	WHERE date>=msdate .and. date<=medate .and. party=m.psparty .and. empty(slipno) 
Endif
*******************Endi of Slip No. Update***************************	

SELECT PARTY,DATE,BILLNO,QUALITY,COLOUR,RETNQTY,ISSQTY,IRATE,RRATE,AMT,RCOD,SLIPNO,OL_NO;	 
FROM REPSTOCK;
Where empty(Slipno);
ORDER BY Date,BillNo,Quality,COLOUR,RCOD;
INTO CURSOR REP3

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form wibillpartydnot.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wibillpartydnot.frx to printer prompt noconsole
Endcase
Endif



