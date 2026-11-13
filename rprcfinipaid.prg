*FINISHED PRC report Payment Report, Paid
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo5      && Trim Information for Check Purpose !
Open Database Carpet
IF !empty(m.psCarpetNo)
	SELECT b.BCODE, b.QUALITY, s.CARD_NO, s.WEAVER, s.CARPETNO,  b.DESIGN, b.COLOUR, s.BTHWEAV,s.LTHWEAV, s.FINSQMT, b.OL_NO, s.ISSDT, s.GRADE, s.FDate,;
	 b.PO_NO, b.NOTES,s.rate,s.amt,s.Penalamt,s.extramt,b.FIELDCODE,s.billno,s.DANDI,s.ALLOWPAY,PAIDSTATUS,s.PAIDDATE,b.code,b.code1,b.code2,b.Washtype;
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2 .and. !empty(billno) .and. carpetno=m.psCarpetNo;
	INTO CURSOR temprepview1 
ELSE
	SELECT b.BCODE, b.QUALITY, s.CARD_NO, s.WEAVER, s.CARPETNO,  b.DESIGN, b.COLOUR, s.BTHWEAV,	s.LTHWEAV, s.FINSQMT, b.OL_NO, s.ISSDT, s.GRADE, s.FDate,;
	b.PO_NO, b.NOTES,s.rate,s.amt,s.Penalamt,s.extramt,b.FIELDCODE,s.billno,s.DANDI,s.ALLOWPAY,PAIDSTATUS,s.PAIDDATE,b.code,b.code1,b.code2,b.Washtype;
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2 .and. !empty(billno);
	INTO CURSOR temprepview1 
ENDIF

SELECT *;
FROM temprepview1;
WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes, BillNo,Carpetno).AND. ALLOWPAY=.T. .and. ccsMatch4A(WASHTYPE);
ORDER BY Carpetno,ol_no;
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
		Report form prcfinipaid.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcfinipaid.frx to printer prompt noconsole
	Case  m.PrnStat="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS WASHTYPE,BCODE,QUALITY,WEAVER,CARPETNO,DESIGN,COLOUR,BTHWEAV,LTHWEAV,FINSQMT,ISSDT,GRADE,FDate,PO_NO,rate,amt,Penalamt,extramt,billno,PAIDDATE
		Messagebox("Purchase Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
Endcase
Endif
Return


