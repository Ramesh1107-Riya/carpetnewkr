**********Calculate Current Stock till date
SET DELETED ON
SET TALK OFF
SET SAFE OFF

*Do Wistkcolor
Do Querygen
Do Reportgen
Do Yarncalc
Do INTEGRATE
*1)**********
*PROCEDURE WISTKCOLOR
*CREATE CURSOR REPSTOCK (QUALITY C(8),COLOUR C(10),OPENBAL N(10,3),RECQTY N(11,3),ISSQTY N(11,3),ORDQTY N(11,3),RETNQTY N(11,3),RCOD C(3))
*SELECT REPSTOCK
*APPEND FIELDS QUALITY,COLOUR,OPENBAL FROM WISTOCK
*RETURN
*Eop(1)

*2
PROCEDURE QUERYGEN
CREATE CURSOR REPSTOCK (QUALITY C(10),COLOUR C(10),OPENBAL N(10,3),RECQTY N(11,3),ISSQTY N(11,3),ORDQTY N(11,3),RETNQTY N(11,3),RCOD C(3))

SELECT QUALITY,COLOUR,(OPENBAL) AS QUANTITY,PADR('WOP',3) as RCOD;
FROM WISTOCK;
INTO CURSOR WIOP

SELECT QUALITY,COLOUR,SUM(QUANTITY) QUANTITY,PADR('REV',3) as RCOD;
FROM WIRECV SHARE;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR RECV

SELECT QUALITY,COLOUR,SUM(QUANTITY) QUANTITY,PADR('ISS',3) as RCOD;
FROM WIISSUE SHARE;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR ISSUE

SELECT QUALITY,COLOUR,SUM(QUANTITY) QUANTITY,PADR('RTN',3) as RCOD;
FROM WIRETURN SHARE;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR RETN

SELECT QUALITY,COLOUR,SUM(QUANTITY) QUANTITY,PADR('ORD',3) as RCOD;
FROM WITRNORD SHARE;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR WORDER
*---all data in same container distinguished by rcode
SELECT QUALITY,QUANTITY,COLOUR,RCOD;
FROM WIOP;
UNION ALL;
SELECT QUALITY,QUANTITY,COLOUR,RCOD;
FROM RECV;
UNION ALL;
SELECT QUALITY,QUANTITY,COLOUR,RCOD;
FROM RETN;
UNION ALL;
SELECT QUALITY,QUANTITY,COLOUR,RCOD;
FROM ISSUE;
UNION ALL;
SELECT QUALITY,QUANTITY,COLOUR,RCOD;
FROM WORDER;
INTO CURSOR wstk

***** distribute all data according to fields
SELECT wstk 
DO WHILE .NOT. EOF()
SELECT REPSTOCK
APPEN BLANK
repl quality with wstk->quality,colour with wstk->colour,rcod with wstk->rcod

do case
	case rcod='WOP'
		repl repstock->OPENBAL with wstk->Quantity
	case rcod='REV'
		repl repstock->RECQTY with wstk->Quantity
	case rcod='RTN'
		repl repstock->RETNQTY with wstk->Quantity
	case rcod='ISS'
		repl repstock->ISSQTY with wstk->Quantity
	case rcod='ORD'
		repl repstock->ORDQTY with wstk->Quantity
  endcase
   SELECT wstk
	IF .NOT. EOF()
	   SKIP
	ENDIF
ENDDO

***smmation on quality
SELECT QUALITY, SUM(OPENBAL) OPENBAL,SUM(RECQTY) RECQTY, SUM(RETNQTY) RETNQTY,SUM(ISSQTY) ISSQTY,SUM(ORDQTY) ORDQTY;
FROM REPSTOCK;
GROUP BY QUALITY;
ORDER BY QUALITY;
INTO CURSOR REPSTOCK1
RETURN
**END OF Querygen
*Eop(2)

*3
PROCEDURE REPORTGEN
SELECT QUALITY,COLOUR,OPENBAL,RECQTY,ISSQTY,RETNQTY,(OPENBAL+RECQTY+RETNQTY-ISSQTY) AS STOCKQTY,ORDQTY DYEORD;
FROM REPSTOCK;
WHERE OPENBAL>0 .OR. RECQTY>0 .OR. ISSQTY>0;
ORDER BY QUALITY,COLOUR;
INTO CURSOR WISTK
RETURN

*Calculate Yarn Requirement form Yarn Calc Chart for only (NotDistri Carpets) till today
**Find Matching PO record crossesponding Yarn Calc Chart
Procedure Yarncalc
SELECT Design, Quality, Colour, Sum(Sqmt) Tsqmt;
FROM  Cabuyord ;
WHERE .NOT. EXISTS (Select *;
 					From Casupord;
 					Where Cabuyord.ol_no = Casupord.ol_no) .and. po_no=m.po_no;
Group by design,quality,colour;
Order by design,quality,colour;
Into Cursor temp3

**OK till now

*SELECT Design, Quality, Colour, Sum(Sqmt) Tsqmt;
*FROM  Carpet!cabuyord;
*WHERE Cstatus="NotDistri"; 
*Group by design,quality,colour;
*Order by design,quality,colour;
*Into Cursor temp3

Select i.*,j.Tsqmt;
From yrcalc i, temp3 j;
Where i.design=j.design .and. i.quality=j.quality .and. i.basecolour=j.colour;
Into cursor yrcalc1

Create cursor yrcalc2(QUALITY C(12), COLOUR C(10), SQMYARN N(5,2), SQMT N(6,2))

Private count1,count2,count3,tvar,var1,var2,var3,var4
tvar=.T.

Select yrcalc1
Scan while (.not. eof())
	For count1=1 to 26 Step 1
		count4="QLTY"+right("00"+Alltrim(Str(count1)),2) 
		count2="COLOUR"+right("00"+Alltrim(Str(count1)),2)
		count3="SQMYARN"+right("00"+Alltrim(Str(count1)),2)
		var1=&count4
		var2=&count2
		var3=&count3		
		var4=yrcalc1.Tsqmt && value sent to sqmt for yrcalc2
		if(empty(yrcalc1->&count2))
			loop
		else
			Insert into yrcalc2(quality,colour,sqmyarn,sqmt) Values(var1,var2,var3,var4)
		endif
	Endfor
	Select yrcalc1
Endscan

*we calculate individual yarnrequred for same color with all values than sum in the next query
Select i.quality, i.colour, i.sqmt , i.sqmt*i.sqmyarn yrreqkgall;  && calculate yarn kg for all individual sqmt used in different colors
From yrcalc2 i;
ORDER BY i.quality,i.colour;
Into cursor yrcalc2a 

*same color may have different yarn per kg used in different design, now we group same color  
Select i.quality, i.colour, sum(yrreqkgall) yrreqkg;  
From yrcalc2a i;
Group by i.quality,i.colour;
ORDER BY i.quality,i.colour;
INTO Cursor Yrcalc3
RETURN
*Eop(3)

*4) Integrate both cursor Yarncal3 and Wiskt
Procedure INTEGRATE
CREATE CURSOR YrReOrder (QUALITY C(10),COLOUR C(10),STOCKQTY N(11,3),DYEORD N(11,3),YRREQKG N(11,3))
APPEND FROM DBF('YRCALC3')

SELECT QUALITY,COLOUR,STOCKQTY,DYEORD;
FROM WISTK;
ORDER BY QUALITY,COLOUR;
INTO CURSOR WISTK1

SELECT YRREORDER
INDEX ON QUALITY+COLOUR TAG YRREORDER
set order to YRREORDER
SELECT WISTK1
INDEX ON QUALITY+COLOUR TAG WISTK1
set order to WISTK1

SELECT YRREORDER
  GO TOP
DO WHILE .NOT. EOF()
  	=SEEK (YRREORDER.QUALITY + YRREORDER.COLOUR,"WISTK1")
  	IF .T.
    	REPL YRREORDER.STOCKQTY WITH WISTK1.STOCKQTY
    	REPL YRREORDER.DYEORD WITH WISTK1.DYEORD
    ENDIF
    SELECT YRREORDER
	IF .NOT. EOF()
	   SKIP
	ENDIF
ENDDO

*Selecting only required fields  (on 13/7/2011 it was realized Dyeord effects stock, when yarn is received, temporarily removed)
*but still we show total dye order till date just to be clear till date how much order has been placed.
*SELECT QUALITY,COLOUR,YRREQKG,STOCKQTY,DYEORD,YRREQKG-STOCKQTY-DYEORD REORDER;

Private Head1

IF m.chk1=1
	SELECT QUALITY,COLOUR,YRREQKG,STOCKQTY,DYEORD,YRREQKG-STOCKQTY REORDER;
	FROM YRREORDER;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR WISTK2 NOFILTER
	Head1="Complete Dyed Yarn Reqd For NotDistri Order"
Else
	SELECT QUALITY,COLOUR,YRREQKG,STOCKQTY,DYEORD,YRREQKG-STOCKQTY REORDER;
	FROM YRREORDER;
	WHERE YRREQKG-STOCKQTY>0;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR WISTK2 NOFILTER
	Head1="Partial Re-Order Dyed Yarn For NotDistri Order"
Endif

Select Wistk2
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form wireordndist.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wireordndist.frx to printer prompt noconsole
Endcase
Endif
RETURN
*Eop(4)
*Into cursor yrcalc3 NOFILTER && Nofilter causes cursor to be temp written in Hard disk can be reused
