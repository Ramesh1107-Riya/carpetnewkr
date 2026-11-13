*Washing Received Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century OFF
SET ANSI ON

DO csTrimInfo7a      && Trim Information for Check Purpose !
Open Database Carpet

SELECT Name,Carpetno,Design,Colour,Quality,IssBill,IssDt,RecBill,RecDt,Szcode,Paysize,Sqmt,WashAmt,ClipAmt,TrimAmt,StretAmt,ChamAmt,BinAmt,HydroAmt,TotalAmt,;
Pay,slipno,wcomment,paiddate,allowpay,rewash;
From WashTran;
WHERE IssDt>=m.Text1 .and. IssDt<=m.Text2;
Order by Name,Carpetno;
INTO CURSOR IssueWash

*14-2-2025 Ramesh Changed
*WHERE IssDt>=m.Text1 .and. IssDt<=m.Text2 .and. empty(RecDt);

SELECT *;
FROM IssueWash;
WHERE ccsMatch7a(Name,Carpetno,Design,Colour,Quality,Szcode,IssBill,RecBill);
ORDER BY Name,Carpetno;
Into Cursor TempIss

***Date Min and Max ***********************************************
Private m.StartDt,m.EndDt
Select Min(IssDt) as Min_Date from  TempIss into cursor mindate
select mindate
m.StartDt=mindate->Min_Date
Select max(IssDt) as Max_Date from  TempIss into cursor maxdate 
select maxdate
m.EndDt=maxdate->Max_Date
********************************************************************

**** For Company head Pema Rug (2) or Kamal Rug *2) on bill top**** 12/03/2025
Select k.compname;
From Casupplr i;
Join TempIss j;
On i.code=j.name;
Join packhead k;
On i.compcode=k.compcode;
Into Cursor billhead
Select billhead
pcname=billhead->compname
************************	
	
Select TempIss
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repwshissgy.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repwshissgy.frx to printer prompt noconsole
Endcase
Endif
Return


