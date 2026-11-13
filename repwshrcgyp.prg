*Washing Received Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo7a      && Trim Information for Check Purpose !
Open Database Carpet
	SELECT Name,Carpetno,Design,Colour,Quality,IssBill,RecBill,RecDt,Szcode,Paysize,Sqmt,WashAmt,ClipAmt,TrimAmt,StretAmt,ChamAmt,BinAmt,HydroAmt,TotalAmt,Pay,slipno,wcomment,paiddate;
	From WashTran;
	WHERE RecDt>=m.Text1 .and. RecDt<=m.Text2 .and. empty(paiddate);
	Order by Name,Carpetno;
	INTO CURSOR RecdWash

SELECT *;
FROM RecdWash;
WHERE ccsMatch7a(Name,Carpetno,Design,Colour,Quality,Szcode,IssBill,RecBill);
ORDER BY Name,Carpetno;
Into Cursor Temp1a

IF(puPaidUpdate=.T.) 
	Update WashTran;
	Set Pay=.T.,Paiddate=date();
	Where CARPETNO IN (SELECT CARPETNO FROM Temp1a)
	puPaidUpdate=.F.
Endif	

IF(puPaidRevert=.T.) 
	Update WashTran;
	Set Pay=.F.;
	Where CARPETNO IN (SELECT CARPETNO FROM Temp1a)
	puPaidRevert=.F.
Endif			


***Date Min and Max ***********************************************
Private m.StartDt,m.EndDt
Select Min(RecDt) as Min_Date from  Temp1a into cursor mindate
select mindate
m.StartDt=mindate->Min_Date
Select max(RecDt) as Max_Date from Temp1a into cursor maxdate 
select maxdate
m.EndDt=maxdate->Max_Date
********************************************************************
	
Select Temp1a
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repwshrcgy.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repwshrcgy.frx to printer prompt noconsole
Endcase
Endif
Return


