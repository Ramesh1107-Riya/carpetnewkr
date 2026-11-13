***Detail Report Bill made
*******Mindate & Maxdate for data in Date Range 
Private m.Slipno
Select Min(date) from  REPSTOCK Where !empty(Slipno) into cursor mindate
select mindate
msdate=mindate->min_date
Select max(date),max(val(Slipno)) maxSlipno From  REPSTOCK Where !empty(Slipno) into cursor maxdate
select maxdate
medate=maxdate->Max_date
m.Slipno=maxdate->maxSlipno
*********************************************

SELECT PARTY,DATE,BILLNO,QUALITY,COLOUR,RETNQTY,ISSQTY,IRATE,RRATE,AMT,RCOD,SLIPNO,PO_No,j.CompName,Ol_no;	 
FROM REPSTOCK i,casupplr j;
Where Party=j.code .and. !empty(Slipno);
ORDER BY Date,BillNo,Quality,COLOUR,RCOD;
INTO CURSOR REP3

Select Rep3
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form wibillpartyd.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wibillpartyd.frx to printer prompt noconsole
Endcase
Endif

