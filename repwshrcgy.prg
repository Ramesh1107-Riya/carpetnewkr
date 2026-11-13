*Washing Received Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo7a      && Trim Information for Check Purpose !
*Open Database Carpet
Do Case
	Case m.Option=1 .and. m.PrnStat="V" && Make Payment
		SELECT Name,Carpetno,Design,Colour,Quality,IssBill,RecBill,RecDt,Szcode,Paysize,Sqmt,WashAmt,ClipAmt,TrimAmt,StretAmt,ChamAmt,BinAmt,HydroAmt,TotalAmt,Pay,slipno,wcomment,paiddate,allowpay,Rewash;
		From WashTran;
		WHERE RecDt>=m.Text1 .and. RecDt<=m.Text2 .and. Pay=.F. .and. Allowpay=.T. ;
		Order by Name,recdt; 
		INTO CURSOR RecdWash

	Case m.Option=1 .and. m.PrnStat="P" && Make Payment Update
		SELECT Name,Carpetno,Design,Colour,Quality,IssBill,RecBill,RecDt,Szcode,Paysize,Sqmt,WashAmt,ClipAmt,TrimAmt,StretAmt,ChamAmt,BinAmt,HydroAmt,TotalAmt,Pay,slipno,wcomment,paiddate,allowpay,Rewash;
		From WashTran;
		WHERE RecDt>=m.Text1 .and. RecDt<=m.Text2 .and. Pay=.F. .and. Allowpay=.T. ;
		Order by Name,Carpetno;
		INTO CURSOR RecdWash
				
		SELECT *;
		FROM RecdWash;
		WHERE ccsMatch7a(Name,Carpetno,Design,Colour,Quality,Szcode,IssBill,RecBill);
		ORDER BY Name,Carpetno;
		Into Cursor Temp1a

		Update WashTran;
		Set Pay=.T.,Paiddate=date();
		Where CARPETNO IN (SELECT CARPETNO FROM Temp1a)
	
	Case m.Option=2 && Paid 
		SELECT Name,Carpetno,Design,Colour,Quality,IssBill,RecBill,RecDt,Szcode,Paysize,Sqmt,WashAmt,ClipAmt,TrimAmt,StretAmt,ChamAmt,BinAmt,HydroAmt,TotalAmt,Pay,slipno,wcomment,paiddate,allowpay,Rewash;
		From WashTran;
		WHERE RecDt>=m.Text1 .and. RecDt<=m.Text2 .and. Pay=.T. .and. Allowpay=.T.;
		Order by Name,recdt;
		INTO CURSOR RecdWash

	Case m.Option=3 && Pending Payment
		SELECT Name,Carpetno,Design,Colour,Quality,IssBill,RecBill,RecDt,Szcode,Paysize,Sqmt,WashAmt,ClipAmt,TrimAmt,StretAmt,ChamAmt,BinAmt,HydroAmt,TotalAmt,Pay,slipno,wcomment,paiddate,allowpay,Rewash;
		From WashTran;
		WHERE RecDt>=m.Text1 .and. RecDt<=m.Text2 .and. Pay=.F. .and. Allowpay=.F.;
		Order by Name,recdt;
		INTO CURSOR RecdWash
EndCase

SELECT *;
FROM RecdWash;
WHERE ccsMatch7a(Name,Carpetno,Design,Colour,Quality,Szcode,IssBill,RecBill);
ORDER BY Name,recdt;
Into Cursor Temp1a

***Date Min and Max ***********************************************
Private m.StartDt,m.EndDt
Select Min(RecDt) as Min_Date from  Temp1a into cursor mindate
select mindate
m.StartDt=mindate->Min_Date
Select max(RecDt) as Max_Date from Temp1a into cursor maxdate 
select maxdate
m.EndDt=maxdate->Max_Date
********************************************************************
** For Company head Pema Rug (2) or Kamal Rug *2) on bill top**** 12/03/2025
Select k.compname;
From Casupplr i;
Join Temp1a j;
On i.code=j.name;
Join packhead k;
On i.compcode=k.compcode;
Into Cursor billhead
Select billhead
pcname=billhead->compname
************************	
	
Select Temp1a
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option2=0
		Report form repwshrcgy.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option2=0
		Report form repwshrcgy.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.Option2=1
		Report form repwshrcgyvat.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option2=1
		Report form repwshrcgyvat.frx to printer prompt noconsole
Endcase
Endif
Return

