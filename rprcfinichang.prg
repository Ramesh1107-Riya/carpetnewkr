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
	 SELECT b.BCODE, b.QUALITY, s.CARD_NO, s.WEAVER, s.CARPETNO,  b.DESIGN, b.COLOUR, s.BTHWEAV,;
	 s.LTHWEAV, s.FINSQMT, b.OL_NO, s.ISSDT, s.GRADE, s.FDate, b.PO_NO, b.NOTES,s.rate,s.amt,s.Penalamt,s.extramt,b.FIELDCODE,s.BILLNO,;
	 s.DANDI,s.ALLOWPAY,PAIDSTATUS;
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) ;
	HAVING s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2  .and. !empty(m.psWeaver);
	INTO CURSOR TEMP1

	SELECT *;
	FROM TEMP1;
	WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes,BillNo) .and.  ALLOWPAY=.T. .and. empty(Billno);
	ORDER BY Weaver,FDate ASC;
	INTO CURSOR Temp2	

	UPDATE Carpet!Casupord;
	SET Billno=alltrim(m.billautno),PaidStatus=.T.,PaidDate=Date();
	WHERE ol_no IN (SELECT Ol_no FROM Temp2) 
Endif


**Report Generation*******************************
SELECT b.BCODE, b.QUALITY, s.CARD_NO, s.WEAVER, s.CARPETNO,  b.DESIGN, b.COLOUR, s.BTHWEAV,;
 s.LTHWEAV, s.FINSQMT, b.OL_NO, s.ISSDT, s.GRADE, s.FDate, b.PO_NO, b.NOTES,s.Rate,s.amt,s.Penalamt,s.extramt,b.FIELDCODE,s.BILLNO,;
 s.DANDI,s.ALLOWPAY,s.PAIDSTATUS,s.PAIDDATE;
FROM  Carpet!Cabuyord b, Carpet!Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2 ;
INTO CURSOR temprepview1

SELECT *;
FROM Carpet!temprepview1;
WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes,BillNo).and.  ALLOWPAY=.T. .AND. (PAIDSTATUS=.F. .OR. PAIDDATE=Date());
ORDER BY Weaver,FDate ASC;
INTO CURSOR temprepview


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
m.StartDt=mindate->Min_date
Select max(Fdate) as Max_Date from  temprepview  into cursor maxdate 
select maxdate
m.EndDt=maxdate->Max_Date
*********************************************

SELECT i.*,j.CompName;
FROM temprepview i,casupplr j;
WHERE i.Weaver=j.code;
ORDER BY i.Weaver,i.FDate ASC;
INTO CURSOR temprepviewf

SELECT temprepviewf  
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prcfini.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcfini.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	*Case m.PrnStat="P"
	*	Report form prcfini.frx to printer prompt noconsole
Endcase
Endif
Return


