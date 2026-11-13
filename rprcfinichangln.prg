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
If (m.PrnStat="V" .and. !empty(m.psWeaver))
		do billautonln
	SELECT b.BCODE, b.QUALITY, s.WEAVER, b.OL_NO, s.ISSDT, s.GRADE, s.FDate, b.PO_NO, b.NOTES,s.BILLonln as BILLNO, s.ALLOWPAY,s.PAIDSTATUS,s.PAIDDATE,s.Carpetno;
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate);
	Having s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2  .and. !empty(m.psWeaver);
	INTO CURSOR TEMP1

	SELECT *;
	FROM TEMP1;
	WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes,BillNo,Carpetno) .and. empty(Billautonln); && NOT EMPTY BILL DO 
	ORDER BY Weaver,FDate ASC;
	INTO CURSOR Temp2	

	UPDATE Carpet!Casupord;
	SET Billonln=alltrim(m.billautonln);
	WHERE ol_no IN (SELECT Ol_no FROM Temp2) 
	
	Messagebox("Record Updated for paid!!!")	
Endif

**Report Generation*******************************
SELECT b.BCODE, b.QUALITY, s.CARD_NO, s.WEAVER, s.CARPETNO,  b.DESIGN, b.COLOUR, s.BTHWEAV,;
 s.LTHWEAV, s.FINSQMT, b.OL_NO, s.ISSDT, s.GRADE, s.FDate, b.PO_NO, b.NOTES,s.Rate,int(s.amt) as amt,int(s.wages) as wages,s.Penalamt,s.extramt,b.FIELDCODE,s.BILLonln as BILLNO,;
 s.DANDI,s.ALLOWPAY,s.PAIDSTATUS,s.PAIDDATE;
FROM  Carpet!Cabuyord b, Carpet!Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2 .and. s.PAIDSTATUS=.F. ;
INTO CURSOR temprepview1

SELECT *;
FROM temprepview1;
WHERE ccsMatch10(Bcode,Quality,Weaver,Grade,Po_no,Notes,BillNo,Carpetno) .and.  ALLOWPAY=.T. .AND. PaidDate=Date() ;
ORDER BY Weaver,FDate ASC;
INTO CURSOR temprepview

***Date Min and Max for Bill Made
Private m.StartDt,m.EndDt
Select Min(Fdate) as Min_Date from  temprepview into cursor mindate
select mindate
m.StartDt=mindate->Min_date
Select max(Fdate) as Max_Date from  temprepview  into cursor maxdate 
select maxdate
m.EndDt=maxdate->Max_Date
*********************************************
	
SELECT temprepview  
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prcfinionln.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcfinionln.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	*Case m.PrnStat="P"
	*	Report form prcfini.frx to printer prompt noconsole
Endcase
Endif
Return


