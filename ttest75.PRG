*LATE ONLOOM PRC report, after supplier supplies the carpet, Black Listed Weaver Performance - Summary
SET PROCEDURE TO Catool
Open Database Carpet
DO csTrimInfo   
	
	*Current Order in Hand
	CREATE CURSOR LOMSUMRY(Card_No N(5), Sqmt N(7,2), Weaver C(20), NoStartCnt N(5), NoStartSqm N(7,2), LatCnt N(5), LatSqmt N(7,2),;
					OnTimeCnt N(5), OnTimeSqmt N(7,2))
	
	SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT,;
		 	 b.ORDER_TYPE, b.BCODE, b.WASHTYPE, s.LOOMDT, s.FDATE, b.QUALITY, b.CTRL_NO,s.CATEGORY;	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.ISSDT) .and. empty(s.fdate);
	HAVING s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text2;
	INTO CURSOR OrdHand
	
	SELECT Card_no, Sqmt, Weaver, IssDt, loomdt, fdate, Wev_Last_Dt;
	FROM OrdHand;
	WHERE ccsMatch4(Weaver) .and. ccsMatch7(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, WASHTYPE, CATEGORY); 
	ORDER BY WEAVER ASC;
	INTO Cursor OrdHandA

	SELECT Count(Card_no) Card_no,Sum(Sqmt) Sqmt, Weaver;
	FROM OrdHandA;
	GROUP BY WEAVER;
	ORDER BY WEAVER ASC;
	INTO CURSOR WevOrd
	
	SELECT LOMSUMRY 
	APPEN FROM DBF("WEVORD")
	
	*Current Order Not Started (LoomDt Not Started)
	SELECT Card_no, Sqmt, Weaver;
	FROM  OrdHandA;
	WHERE !empty(ISSDT) .and. Empty(loomdt);
	INTO Cursor NoStart1   
	
	SELECT Count(Card_no) Card_no,Sum(Sqmt) Sqmt, Weaver;
	FROM NoStart1;
	GROUP BY WEAVER;
	ORDER BY WEAVER ASC;
	INTO CURSOR NoStart
	
	*Current Order On Time (Not Crossed Wev_Last_Dt)
	SELECT Card_no, Sqmt, Weaver;
	FROM  OrdHandA;
	WHERE !empty(loomdt) .and. WEV_LAST_DT>=m.Text2-m.Text4;  
	INTO Cursor OnTime1   
	
	SELECT Count(Card_no) Card_no,Sum(Sqmt) Sqmt, Weaver;
	FROM OnTime1;
	GROUP BY WEAVER;
	ORDER BY WEAVER ASC;
	INTO CURSOR OnTime
	
	*Late On Loom, WevLastDt Crossed (Black List)
	SELECT Card_no, Sqmt, Weaver;
	FROM  OrdHandA;
	WHERE !empty(loomdt) .and. WEV_LAST_DT<=m.Text2-m.Text4;
	ORDER BY Weaver ASC ;  
	INTO CURSOR Blist1
	
    SELECT COUNT(Card_No)Card_no, Sum(SQMT) Sqmt,Weaver;	
	FROM Blist1;
	GROUP BY WEAVER;
	ORDER BY Weaver ASC;
	Into Cursor Blist

SELECT LOMSUMRY
INDEX ON WEAVER TAG LWEAVER
SET ORDER TO LWEAVER
SELECT BLIST
INDEX ON WEAVER TAG BWEAVER
SET ORDER TO BWEAVER
SELECT NOSTART
INDEX ON WEAVER TAG NWEAVER
SET ORDER TO NWEAVER
SELECT ONTIME
INDEX ON WEAVER TAG TWEAVER
SET ORDER TO TWEAVER
	
SELECT LOMSUMRY
  GO TOP
DO WHILE .NOT. EOF()
  	=SEEK (LOMSUMRY.Weaver,"Blist")
  	IF .T.
    	REPL LOMSUMRY.LatCnt WITH Blist.Card_no,LOMSUMRY.LatSqmt with Blist.Sqmt
    ENDIF
  	=SEEK (LOMSUMRY.Weaver,"NoStart")
  	IF .T.
    	REPL LOMSUMRY.NoStartCnt WITH NoStart.Card_no,LOMSUMRY.NoStartSqm with NoStart.Sqmt
    ENDIF
   	=SEEK (LOMSUMRY.Weaver,"OnTime")
  	IF .T.
    	REPL LOMSUMRY.OnTimeCnt WITH OnTime.Card_no,LOMSUMRY.OnTimeSqmt with OnTime.Sqmt
    ENDIF
    SELECT LOMSUMRY
	IF .NOT. EOF()
	   SKIP
	ENDIF
ENDDO	

Select *;
From LOMSUMRY;
INTO Table LOMSUMRY1

Use LomSumry1 Share
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prcordhnds.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcordhnds.frx to printer prompt noconsole
Endcase
Endif
Return'