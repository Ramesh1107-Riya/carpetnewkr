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
If (m.PrnStat="P")
	do billautnotmea
	SELECT b.BCODE, b.QUALITY, s.WEAVER, b.OL_NO, s.ISSDT, s.GRADE, s.FDate, b.PO_NO, b.NOTES,s.Location as BILLNO,s.Location,s.Paintdt,s.Carpetno,b.WashType,s.Comment;
	FROM  Cabuyord b, Casupord s;
	WHERE b.ol_no=s.ol_no .and.  s.PaintDt>=m.Text1 .and. s.PaintDt<=m.Text2  .and. empty(s.FDate);
	INTO CURSOR TEMP1

	SELECT *;
	FROM TEMP1;
	WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes, BillNo, Carpetno)  .and. empty(Location); 
	ORDER BY Weaver,FDate ASC;
	INTO CURSOR Temp2	

	UPDATE Casupord;
	SET Location=alltrim(m.billautnm),PaintDt=Date();
	WHERE ol_no IN (SELECT Ol_no FROM Temp2) 
Endif

**Report Generation********
IF !empty(m.psCarpetNo)
	SELECT b.BCODE,b.QUALITY,s.WEAVER,b.DESIGN,b.COLOUR,b.BREADTH,b.LENGTH,b.OL_NO,b.SZCODE,s.CARPETNO,s.GRADE,s.FDate, b.PO_NO,b.NOTES,s.BILLNO,;
		s.Paintdt,b.Deliry_dt,s.bthweav,s.lthweav,s.FinSqmt,s.bractual,s.lnactual;
	FROM Cabuyord b,Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Paintdt) .and. s.Paintdt>=m.Text1 .and. s.Paintdt<=m.Text2  .and. carpetno=m.psCarpetNo;
	Into Cursor tempbar 
Else
	SELECT b.BCODE,b.QUALITY,s.WEAVER,b.DESIGN,b.COLOUR,b.BREADTH,b.LENGTH,b.OL_NO,b.SZCODE,s.CARPETNO,s.GRADE,s.FDate, b.PO_NO,b.NOTES,s.BILLNO,;
		s.Paintdt,b.Deliry_dt,s.bthweav,s.lthweav,s.FinSqmt,s.bractual,s.lnactual;
	FROM Cabuyord b,Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.Paintdt) .and. s.Paintdt>=m.Text1 .and. s.Paintdt<=m.Text2;
	Into Cursor tempbar Nofilter
Endif

SELECT b.BCODE,b.QUALITY,b.WEAVER,b.DESIGN,d.Dgndesc,b.COLOUR,b.BREADTH,b.LENGTH,ALLTRIM(b.OL_NO) AS OL_NO,b.SZCODE,b.CARPETNO,b.GRADE,b.FDate, b.PO_NO,b.NOTES,b.BILLNO,;
	b.Paintdt,b.Deliry_dt,b.bthweav,b.lthweav,b.FinSqmt,b.bractual,b.lnactual,d.matcomp;
FROM tempbar b;
Join Cadesign d;
On alltrim(d.code)=alltrim(b.design);
Into Cursor tempbar1a

SELECT b.BCODE,b.QUALITY,b.WEAVER,b.DESIGN,b.Dgndesc,b.COLOUR,b.BREADTH,b.LENGTH,b.OL_NO,b.SZCODE,b.CARPETNO,b.GRADE,b.FDate, b.PO_NO,b.NOTES,b.BILLNO,;
	b.Paintdt,b.Deliry_dt,b.bthweav,b.lthweav,b.FinSqmt,b.bractual,b.lnactual,b.matcomp,d.acno,d.supcode,ALLTRIM(STR(bthweav)) + "X" + ALLTRIM(STR(lthweav)) as wsize;
FROM tempbar1a b;
Join Casupplr d;
On alltrim(d.code)=alltrim(b.weaver);
Where ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes, BillNo, Carpetno) .and. empty(b.FDate);
Into Cursor temprepview

***Date Min and Max for Bill Made
Private m.StartDt,m.EndDt
Select Min(Paintdt) as Min_Date from  temprepview into cursor mindate
select mindate
m.StartDt=mindate->Min_Date
Select max(Paintdt) as Max_Date from  temprepview into cursor maxdate 
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
		Report form prcfininm.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcfininm.frx to printer prompt noconsole
Endcase
Endif
Return


