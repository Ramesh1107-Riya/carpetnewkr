**Only in Order DYINLOAD is taken, in Wool Receive Quantity, Here it change is not required
*Dyeing Statment of DyeRecd Not Paid, Pending, All
SET DELETED ON
SET TALK OFF
SET SAFE OFF
Set Procedure to catool

Local m.DyeHead
m.DyeHead=' '

*Dyeing Loss Billwise
*Do csTriminfo22
Do Case
  Case m.Option='A'
	m.DyeHead='Dyeing Received (NOT Paid)'
	SELECT w.PARTY,w.QUALITY,w.DATE,w.BILLNO,w.DYINGLOAD,w.QUANTITY,w.COLOUR,t.DATE AS ISSDATE,w.CARD_NO AS RCDBILL,t.RATE,t.AMT,w.DyePaid,w.Quantity as RecdQty,w.Billno as Card_no;
	FROM WIRECV w;
	RIGH JOIN Witrnord t;
	ON w.billno=t.billnO;
	WHERE w.QUALITY=t.Quality .and. w.COLOUR=t.Colour .AND. w.DATE>=msdate .and. w.DATE<=medate .and. w.Party=m.Supplier .and. w.DyePaid=.F.; 
	ORDER BY w.Date,w.BILLNO,w.QUALITY;
	INTO CURSOR DyeStatment1
	
	SELECT PARTY,QUALITY,DATE,BILLNO,DYINGLOAD,QUANTITY,COLOUR,ISSDATE,CARD_NO,RCDBILL,RATE,AMT,DyePaid,RecdQty;
	FROM DyeStatment1;
	Where ccsMatch22(PARTY,CARD_NO);
	INTO CURSOR DyeStatment

  Case m.Option='B'
	m.DyeHead='Dyeing Received (PAID)'
	SELECT w.PARTY,w.QUALITY,w.DATE,w.BILLNO,w.DYINGLOAD,w.QUANTITY,w.COLOUR,t.DATE AS ISSDATE,w.CARD_NO AS RCDBILL,t.RATE,t.AMT,w.DyePaid,w.Quantity as RecdQty,w.Billno as Card_no;
	FROM WIRECV w;
	RIGH JOIN Witrnord t;
	ON w.billno=t.billnO;
	WHERE w.QUALITY=t.Quality .and. w.COLOUR=t.Colour .AND. w.DATE>=msdate .and. w.DATE<=medate .and. w.Party=m.Supplier .and. w.DyePaid=.T.;
	ORDER BY w.Date,w.BILLNO,w.QUALITY;
	INTO CURSOR DyeStatment1
	
	SELECT PARTY,QUALITY,DATE,BILLNO,DYINGLOAD,QUANTITY,COLOUR,ISSDATE,CARD_NO,RCDBILL,RATE,AMT,DyePaid,RecdQty;
	FROM DyeStatment1;
	Where ccsMatch22(PARTY,CARD_NO);
	INTO CURSOR DyeStatment

  Case m.Option='C'
	m.DyeHead='Dyeing Issued But Not Recd (DETAIL)'
	SELECT w.DATE,w.BILLNO,w.PARTY,w.QUALITY,w.COLOUR,w.QUANTITY,w.Rate,w.Amt;
	FROM Witrnord w;
	WHERE .NOT. EXISTS (SELECT * FROM WIRECV r;
					WHERE w.billno=r.billno .and. w.QUALITY=r.Quality .and. w.COLOUR=r.Colour) .and. w.DATE>=msdate .and. w.DATE<=medate;
	ORDER BY w.Date,w.BILLNO,w.QUALITY;
	INTO CURSOR DyeStatment
 
  Case m.Option='D'
	m.DyeHead='Dyeing Issued But Not Recd (SUMMARY)'
	SELECT w.DATE,w.PARTY,w.QUALITY,SUM(w.QUANTITY) QUANTITY,SUM(w.Amt) Amt;
	FROM Witrnord w;
	WHERE .NOT. EXISTS (SELECT * FROM WIRECV r;
					WHERE w.billno=r.billno .and. w.QUALITY=r.Quality .and. w.COLOUR=r.Colour) .and. w.DATE>=msdate .and. w.DATE<=medate;
	GROUP BY w.QUALITY;
	ORDER BY w.Date;
	INTO CURSOR DyeStatment
 
  Case m.Option='E'
  	SELECT w.PARTY,w.QUALITY,w.DATE,w.BILLNO,w.DYINGLOAD,w.QUANTITY,w.COLOUR,t.DATE AS ISSDATE,w.CARD_NO AS RCDBILL,t.RATE,t.AMT,w.DyePaid;
	FROM WIRECV w;
	RIGH JOIN Witrnord t;
	ON w.billno=t.billnO;
	WHERE w.QUALITY=t.Quality .and. w.COLOUR=t.Colour .AND. w.DATE>=msdate .and. w.DATE<=medate .and. w.Party=m.Supplier .and. DyePaid=.F. .and. ccsMatch22(w.PARTY,CARD_NO);
	ORDER BY w.Date,w.BILLNO,w.QUALITY;
	INTO CURSOR DyeStatment
	
   	Update Wirecv;
	Set DyePaid=.T.;
	Where CARD_NO IN (SELECT RCDBILL FROM DyeStatment)
	pPaidDye=.F.
EndCase

****Min & Max Date****
Select Min(date) from DyeStatment into cursor mindate
select mindate
msdate=mindate->min_date
Select max(date) from  DyeStatment into cursor maxdate
select maxdate
medate=maxdate->Max_date
*********************

SELECT DyeStatment
SET COLO TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V" .and. (m.Option='A' .or. m.Option='B')
		Report form WiDyePayment.frx PREVIEW WINDOW wReport
	Case m.PrnStat="P" .and. (m.Option='A' .or. m.Option='B')
		Report form  WiDyePayment.frx to printer prompt noconsole	
	Case m.PrnStat="V" .and. m.Option='C'
		Report form WiDyePending.frx PREVIEW WINDOW wReport
	Case m.PrnStat="P" .and. m.Option='C'
		Report form WiDyePending.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.Option='D'
		Report form WiDyePendsmry.frx PREVIEW WINDOW wReport
	Case m.PrnStat="P" .and. m.Option='D'
		Report form WiDyePendsmry.frx to printer prompt noconsole					
Endcase
Endif
SET ANSI OFF
RETU