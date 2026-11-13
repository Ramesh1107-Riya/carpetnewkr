***Detail Report Bill made
*******Mindate & Maxdate for data in Date Range 
Select Min(date) from  REPSTOCK into cursor mindate
select mindate
msdate=mindate->min_date
Select max(date) from  REPSTOCK into cursor maxdate
select maxdate
medate=maxdate->Max_date
*********************************************

SELECT PARTY,DATE,BILLNO,QUALITY,COLOUR,RETNQTY,ISSQTY,IRATE,RRATE,AMT,RCOD,SLIPNO,PO_NO,Ol_NO;	 
FROM REPSTOCK;
Where DATE>=MSDATE .AND. DATE<=medate .AND. RCOD<>'ISS';
ORDER BY BillNo,Quality,COLOUR;
INTO CURSOR REP3

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form wibillreturnd.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wibillreturnd.frx to printer prompt noconsole
Endcase
Endif
