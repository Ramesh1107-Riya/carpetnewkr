**Only in Order DYINLOAD is taken, in Wool Receive Quantity, Here it change is not required
*Dyeing Loss All
SET DELETED ON
SET TALK OFF
SET SAFE OFF

Procedure DyeLossAll

SELECT W.PARTY,W.QUALITY,W.COLOUR,SUM(W.DYINGLOAD) DYINGLOAD,SUM (W.QUANTITY) QUANTITY;
FROM WIRECV W;
WHERE W.DATE>=msdate .and. W.DATE<=medate .and. w.dyingload>0 .and. &condition ;
GROUP BY W.QUALITY,W.COLOUR;
ORDER BY W.QUALITY,W.COLOUR;
INTO CURSOR DYEINGLO

****Min & Max Date*****
Select Min(W.date) from  WIRECV W Where W.dyingload>0 .and. &condition into cursor mindate
select mindate
msdate=mindate->min_date
Select max(W.date) from  WIRECV W Where W.dyingload>0 .and. &condition into cursor maxdate
select maxdate
medate=maxdate->Max_date
*********************

SELECT DYEINGLO
SET COLOR TO 
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form wiDYEINGLO.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wiDYEINGLO.frx to printer prompt noconsole		
Endcase
Endif
Return

*Dyeing Loss Billwise
Procedure DyeLossBill
SELECT W.PARTY,W.QUALITY,W.DATE,W.BILLNO,W.DYINGLOAD,W.QUANTITY,W.COLOUR,t.DATE AS ISSDATE,W.CARD_NO AS RCDBILL,T.RATE,T.AMT;
FROM WIRECV W;
RIGH JOIN Witrnord t;
ON W.billno=t.billnO;
WHERE W.QUALITY=t.Quality .and. W.COLOUR=t.Colour .AND. w.DATE>=msdate .and. w.DATE<=medate .and.  &condition;
INTO CURSOR DYEBILL1

SELECT W.PARTY,W.QUALITY,W.DATE,W.BILLNO,W.DYINGLOAD,W.QUANTITY,W.COLOUR,W.ISSDATE,W.RCDBILL,W.RATE,W.AMT;
FROM DYEBILL1 W;
WHERE &condition;
ORDER BY W.BILLNO,W.QUALITY;
INTO CURSOR DYEBILL

****Min & Max Date*****
Select Min(W.date) from  WIRECV W Where W.dyingload>0 .and. &condition into cursor mindate
select mindate
msdate=mindate->min_date
Select max(W.date) from  WIRECV W Where W.dyingload>0 .and. &condition into cursor maxdate
select maxdate
medate=maxdate->Max_date
*********************

SELECT DYEBILL
SET COLO TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form wiDYEBILL.frx PREVIEW WINDOW wReport
	Case m.PrnStat="P"
		Report form wiDYEBILL.frx to printer prompt noconsole		
Endcase
Endif
SET ANSI OFF
RETU