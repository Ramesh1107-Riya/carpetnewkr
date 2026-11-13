*Rprcfinionln.prg is for printing online supplier carept recd bill
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
		do billautonln
	SELECT b.BCODE, b.QUALITY, s.WEAVER, b.OL_NO, s.ISSDT, s.GRADE, s.FDate, b.PO_NO, b.NOTES,s.BILLonln as BILLNO, s.ALLOWPAY,s.PAIDSTATUS,s.PAIDDATE,s.CARPETNO,b.washtype;
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no;
	Having !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2;
	Into Cursor TEMP1

	If !Empty(m.psWashType)
		SELECT *;
		FROM TEMP1;
		WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes,BillNo,Carpetno) .and.  ALLOWPAY=.T. .AND. (PAIDSTATUS=.F. .OR. PAIDDATE=Date()) .AND. WASHTYPE=m.psWashType;
		ORDER BY Weaver,FDate ASC;
		INTO CURSOR Temp2	
	Else
		SELECT *;
		FROM TEMP1;
		WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes,BillNo,Carpetno) .and.  ALLOWPAY=.T. .AND. (PAIDSTATUS=.F. .OR. PAIDDATE=Date());
		ORDER BY Weaver,FDate ASC;
		INTO CURSOR Temp2
	Endif	
	
	UPDATE Carpet!Casupord;
	SET Billonln=alltrim(m.billautonln);
	WHERE ol_no IN (SELECT Ol_no FROM Temp2)

Endif

**Report Generation*******************************(s.fdate-(s.wev_last_dt)) as Lateday
SELECT b.BCODE,b.QUALITY,s.WEAVER,s.CARPETNO,b.DESIGN,b.COLOUR,s.BTHWEAV,b.qty*100 as Lateday,s.LTHWEAV,s.FINSQMT,b.OL_NO,b.washtype,;
s.ISSDT,s.GRADE,s.FDate,s.wev_last_dt,b.PO_NO,b.NOTES,s.Rate,s.amt,s.wages,s.Penalamt,s.extramt,s.BILLonln as Billno,s.ALLOWPAY,s.PAIDSTATUS,s.PAIDDATE,b.szcode,alltrim(str(s.brActual))+'X'+alltrim(str(s.lnActual)) as ActlSize;
FROM  Carpet!Cabuyord b, Carpet!Casupord s;
WHERE b.ol_no=s.ol_no;
Having !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2;
Into Cursor temprepview2

SELECT BCODE,QUALITY,WEAVER,CARPETNO,DESIGN,COLOUR,BTHWEAV,iif(fdate>wev_last_dt,fdate-wev_last_dt,0.00) as Lateday,LTHWEAV,FINSQMT,OL_NO,ISSDT,GRADE,FDate,PO_NO,NOTES,Rate,amt,wages,Penalamt,extramt,;
BILLNO,ALLOWPAY,PAIDSTATUS,PAIDDATE,wev_last_dt,szcode,ActlSize,washtype;
FROM temprepview2;
Into Cursor temprepview1 

If !Empty(m.psWashType)
	SELECT BCODE,QUALITY,WEAVER,CARPETNO,DESIGN,COLOUR,BTHWEAV,Lateday,LTHWEAV,FINSQMT,OL_NO,ISSDT,GRADE,FDate,PO_NO,NOTES,Rate,int(amt) as amt,int(wages) as wages,Penalamt,extramt,;
	BILLNO,ALLOWPAY,PAIDSTATUS,PAIDDATE,iif(Lateday>0,Lateday*finsqmt*20,0.000) as LateRs,wev_last_dt,Szcode,ActlSize;
	FROM temprepview1;
	WHERE ccsMatch10(Bcode,Quality,Weaver,Grade,Po_no,Notes,BillNo,Carpetno) .and.  ALLOWPAY=.T. .AND. (PAIDSTATUS=.F. .OR. PAIDDATE=Date()) .AND. WASHTYPE=m.psWashType;
	ORDER BY Carpetno,ol_no;
	Into Cursor temprepview	
Else
	SELECT BCODE,QUALITY,WEAVER,CARPETNO,DESIGN,COLOUR,BTHWEAV,Lateday,LTHWEAV,FINSQMT,OL_NO,ISSDT,GRADE,FDate,PO_NO,NOTES,Rate,int(amt) as amt,int(wages) as wages,Penalamt,extramt,;
	BILLNO,ALLOWPAY,PAIDSTATUS,PAIDDATE,iif(Lateday>0,Lateday*finsqmt*20,0.000) as LateRs,wev_last_dt,Szcode,ActlSize;
	FROM temprepview1;
	WHERE ccsMatch10(Bcode,Quality,Weaver,Grade,Po_no,Notes,BillNo,Carpetno) .and.  ALLOWPAY=.T. .AND. (PAIDSTATUS=.F. .OR. PAIDDATE=Date());
	ORDER BY Carpetno,ol_no;
	Into Cursor temprepview	
Endif

***Date Min and Max for Bill Made
Private m.StartDt,m.EndDt
Select Min(Fdate) as Min_Date from  temprepview into cursor mindate
select mindate
m.StartDt=mindate->Min_Date
Select max(Fdate) as Max_Date from  temprepview into cursor maxdate 
select maxdate
m.EndDt=maxdate->Max_Date
*********************************************
Select temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prcfinionln.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcfinionln.frx to printer prompt noconsole
Endcase
Endif
Return


