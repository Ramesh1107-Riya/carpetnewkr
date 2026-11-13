*Washing Received Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century OFF
SET ANSI ON

DO csTrimInfo7a      && Trim Information for Check Purpose !
Open Database Carpet

SELECT Name,Carpetno,Design,Colour,Quality,IssBill,IssDt,RecBill,RecDt,Szcode,Sqmt,WhCode,ClCode,TmCode,StCode,ChCode,BiCode,HyCode,PaySize;
From WashTran;
WHERE IssDt>=m.Text1 .and. IssDt<=m.Text2 .and. empty(RecDt);
Order by Name,Carpetno;
INTO CURSOR IssueWash

SELECT *;
FROM IssueWash;
WHERE ccsMatch7a(Name,Carpetno,Design,Colour,Quality,Szcode,IssBill,RecBill);
ORDER BY Name,Carpetno;
Into Cursor TempIsPen

***Date Min and Max ***********************************************
Private m.StartDt,m.EndDt
Select Min(IssDt) as Min_Date from  TempIsPen into cursor mindate
select mindate
m.StartDt=mindate->Min_Date
Select max(IssDt) as Max_Date from  TempIsPen into cursor maxdate 
select maxdate
m.EndDt=maxdate->Max_Date
********************************************************************
	
Select TempIsPen
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repwshispengy.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repwshispengy.frx to printer prompt noconsole
Endcase
Endif
Return


