*FINISHED PRC report Payment Report, Paid
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo5      && Trim Information for Check Purpose !
Open Database Carpet
* Assumption Before Bill is is Printed, we update Bill No. Starting 1001, Done for Numbering Bill
If (m.PrnStat="P" .and. !empty(m.psWeaver))
		do billautno
	SELECT b.BCODE, b.QUALITY, s.WEAVER, b.OL_NO, s.ISSDT, s.GRADE, s.FDate, b.PO_NO, b.NOTES,s.BILLNO, s.ALLOWPAY,s.PAIDSTATUS,s.PAIDDATE,s.Carpetno;
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2  .and. !empty(m.psWeaver);
	INTO CURSOR TEMP1

	SELECT *;
	FROM TEMP1;
	WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes,BillNo,Carpetno) .and.  ALLOWPAY=.T. .and. empty(Billno); && NOT EMPTY BILL DO 
	ORDER BY Weaver,FDate ASC;
	INTO CURSOR Temp2	

	UPDATE Carpet!Casupord;
	SET Billno=alltrim(m.billautno),PaidStatus=.T.,PaidDate=Date();
	WHERE ol_no IN (SELECT Ol_no FROM Temp2) 
Endif

**Report Generation*******************************(s.fdate-(s.wev_last_dt)) as Lateday
SELECT b.BCODE,b.QUALITY,s.WEAVER,s.CARPETNO,b.DESIGN,b.COLOUR,s.BTHWEAV,b.qty*100 as Lateday,s.LTHWEAV,s.FINSQMT,b.OL_NO,s.ISSDT,s.GRADE,s.FDate,s.wev_last_dt,;
b.PO_NO,b.NOTES,s.Rate,s.amt,s.Penalamt,s.extramt,s.BILLNO,s.ALLOWPAY,s.PAIDSTATUS,s.PAIDDATE,b.szcode,s.dandi,b.code,b.code1,b.code2;
FROM  Carpet!Cabuyord b, Carpet!Casupord s;
WHERE b.ol_no=s.ol_no;
Having !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2;
Into Cursor temprepview2

SELECT BCODE,QUALITY,WEAVER,CARPETNO,DESIGN,COLOUR,BTHWEAV,iif(fdate>wev_last_dt,fdate-wev_last_dt,0.00) as Lateday,LTHWEAV,FINSQMT,OL_NO,ISSDT,GRADE,FDate,PO_NO,NOTES,Rate,amt,Penalamt,extramt,dandi,;
BILLNO,ALLOWPAY,PAIDSTATUS,PAIDDATE,wev_last_dt,szcode,code,code1,code2;
FROM temprepview2;
Into Cursor temprepview1 

SELECT BCODE,QUALITY,WEAVER,CARPETNO,DESIGN,COLOUR,BTHWEAV,Lateday,LTHWEAV,FINSQMT,OL_NO,ISSDT,GRADE,FDate,PO_NO,NOTES,Rate,int(amt) as amt,Penalamt,extramt,;
BILLNO,ALLOWPAY,PAIDSTATUS,PAIDDATE,iif(Lateday>0,Lateday*finsqmt*20,0.000) as LateRs,wev_last_dt,Szcode,dandi,code,code1,code2;
FROM temprepview1;
WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes,BillNo,Carpetno).and.  ALLOWPAY=.T. .AND. (PAIDSTATUS=.F. .OR. PAIDDATE=Date());
ORDER BY Carpetno,ol_no;
Into Cursor temprepview	

**** For Company head Pema Rug or Kamal Rug on bill top**** 6/10/2021
Select k.compname;
From cabuyer i;
Join temprepview j;
On i.bcode=j.bcode;
Join packhead k;
On i.compcode=k.compcode;
Into Cursor billhead
Select billhead
pcname=billhead->compname
************************

***Date Min and Max for Bill Made
Private m.StartDt,m.EndDt
Select Min(Fdate) as Min_Date from  temprepview into cursor mindate
select mindate
m.StartDt=mindate->Min_Date
Select max(Fdate) as Max_Date from  temprepview into cursor maxdate 
select maxdate
m.EndDt=maxdate->Max_Date
*********************************************

SELECT i.*,j.CompName;
FROM temprepview i,casupplr j;
WHERE i.Weaver=j.code;
ORDER BY i.Carpetno;
INTO CURSOR temprepviewf

Select temprepviewf
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prcfini.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcfini.frx to printer prompt noconsole
Endcase
Endif
Return


