*CANOTMEAS Report Not Measured Carpet
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo5      && Trim Information for Check Purpose !
Open Database Carpet
** PaintDt used for Date of Not Measured Carpet From Supplier
** Location used for Not Measured Billno
* Assumption Before Bill is is Printed, we update Bill No. Starting 1001, Done for Numbering Bill
If (m.PrnStat="P" .and. !empty(m.psWeaver))
		do billautnotmea
	SELECT b.BCODE, b.QUALITY, s.WEAVER, b.OL_NO, s.ISSDT, s.GRADE, s.FDate, b.PO_NO, b.NOTES,s.Location as BILLNO,s.Location,s.Paintdt,s.Carpetno,b.WashType;
	FROM  Cabuyord b, Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Paintdt) .and. s.PaintDt>=m.Text1 .and. s.PaintDt<=m.Text2  .and. !empty(m.psWeaver);
	INTO CURSOR TEMP1

	SELECT *;
	FROM TEMP1;
	WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes, BillNo, Carpetno)  .and. empty(Location) .AND. ccsMatch4A(WASHTYPE); 
	ORDER BY Weaver,FDate ASC;
	INTO CURSOR Temp2	

	UPDATE Casupord;
	SET Location=alltrim(m.billautnotm),PaintDt=Date();
	WHERE ol_no IN (SELECT Ol_no FROM Temp2) 
Endif

**Report Generation*******************************(s.fdate-(s.wev_last_dt)) as Lateday
SELECT b.BCODE,b.QUALITY,s.WEAVER,s.CARPETNO,b.DESIGN,b.COLOUR,b.SQMT,b.OL_NO,b.WashType,b.PO_NO,b.NOTES,s.BILLNO,b.szcode,s.Location as BILLNO,s.Location,s.Paintdt;
FROM Cabuyord b,Casupord s;
WHERE b.ol_no=s.ol_no;
Having !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2 .AND. AND. ccsMatch4A(WASHTYPE);
Into Cursor temprepview2

SELECT BCODE,QUALITY,WEAVER,CARPETNO,DESIGN,COLOUR,SQMT,OL_NO,WashType,PO_NO,NOTES,BILLNO,szcode,Location,Paintdt;
FROM temprepview2;
Into Cursor temprepview1 

If !Empty(m.psWashType)
	SELECT BCODE,QUALITY,WEAVER,CARPETNO,DESIGN,COLOUR,SQMT,OL_NO,WashType,PO_NO,NOTES,BILLNO,szcode,Location,Paintdt;
	FROM temprepview1;
	WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes, BillNo, Carpetno) .AND. ccsMatch4A(WASHTYPE);
	ORDER BY Carpetno,ol_no;
	Into Cursor temprepview	
Else
	SELECT BCODE,QUALITY,WEAVER,CARPETNO,DESIGN,COLOUR,SQMT,OL_NO,WashType,PO_NO,NOTES,BILLNO,szcode,Location,Paintdt;
	FROM temprepview1;
	WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes, BillNo, Carpetno) .AND. ccsMatch4A(WASHTYPE);
	ORDER BY Carpetno,ol_no;
	Into Cursor temprepview	
Endi

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
		Report form prcfini.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcfini.frx to printer prompt noconsole
Endcase
Endif
Return


