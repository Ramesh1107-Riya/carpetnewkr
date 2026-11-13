*CANOTMEAS Report Measured Carpet NOT PAID
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
* Assumption Before Bill is is Printed, we update Bill No. Starting 100001, Done for Numbering Bill

**Report Generation********
SELECT b.BCODE,b.QUALITY,s.WEAVER,s.CARPETNO,b.DESIGN,b.COLOUR,b.SQMT,b.OL_NO,b.WashType,b.PO_NO,b.NOTES,b.szcode,s.Location as BILLNO,s.Paintdt,s.Comment;
FROM Cabuyord b,Casupord s;
WHERE b.ol_no=s.ol_no .and.  s.PaintDt>=m.Text1 .and. s.PaintDt<=m.Text2  .and. !empty(s.Location) .and. !empty(s.PaintDt);
Into Cursor temprepview2

SELECT BCODE,QUALITY,WEAVER,CARPETNO,DESIGN,COLOUR,SQMT,OL_NO,WashType,PO_NO,NOTES,BILLNO,szcode,Paintdt,Comment;
FROM temprepview2;
WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes, BillNo, Carpetno) .AND. ccsMatch4A(WASHTYPE);
ORDER BY Carpetno,ol_no;
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
		Report form prcfininmbm.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcfininmbm.frx to printer prompt noconsole
Endcase
Endif
Return


