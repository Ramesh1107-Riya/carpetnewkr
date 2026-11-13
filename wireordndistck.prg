**********Calculate Current Stock Check for Not Distri Design
*SET PROCEDURE TO Catool
SET DELETED ON
SET TALK OFF
SET SAFE OFF
 
Select csCarpetCr
COUNT TO m.csVar1  FOR LABEL
IF m.csVar1=1
	REPL LABEL WITH .T.	 && Done to track single record
Endif
 
RELEASE WINDOW csoSrchWn_

Select *;
From csCarpetCr;
Where LABEL=.T.;
Into Cursor Temp Nofilter

*m.csVar2  = ALLTRIM(STR(m.csVar1)) + " Pieces Marked for Distribution"

Do Wistkcolor
Do Querygen
Do Reportgen
Do Yarncalc
Do INTEGRATE
*1)**********
PROCEDURE WISTKCOLOR
CREATE CURSOR REPSTOCK (QUALITY C(10),COLOUR C(10),OPENBAL N(10,3),RECQTY N(11,3),ISSQTY N(11,3),ORDQTY N(11,3),RETNQTY N(11,3))
SELECT REPSTOCK

APPEND FIELDS QUALITY,COLOUR,OPENBAL FROM WISTOCK 
RETURN
*Eop(1)

*2
PROCEDURE QUERYGEN
SELECT QUALITY,COLOUR,SUM(QUANTITY) QUANTITY;
FROM WIRECV SHARE;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR RECV

SELECT QUALITY,COLOUR,SUM(QUANTITY) QUANTITY;
FROM WIISSUE SHARE;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR ISSUE

SELECT QUALITY,COLOUR,SUM(QUANTITY) QUANTITY;
FROM WIRETURN;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR RETN

SELECT QUALITY,COLOUR,SUM(QUANTITY) QUANTITY;
FROM WITRNORD SHARE;
GROUP BY QUALITY,COLOUR;
ORDER BY QUALITY,COLOUR;
INTO CURSOR ORDER

SELECT REPSTOCK
INDEX ON QUALITY+COLOUR TAG REPSTOCK
set order to repstock
SELECT RECV
INDEX ON QUALITY+COLOUR TAG RECV
set order to recv
SELECT ISSUE
INDEX ON QUALITY+COLOUR TAG ISSUE
set order to ISSUE
SELECT ORDER
INDEX ON QUALITY+COLOUR TAG ORDER
set order to ORDER
SELECT RETN
INDEX ON QUALITY+COLOUR TAG RETN
set order to RETN

**In the same date all the data is scanned individually
SELECT REPSTOCK
  GO TOP
DO WHILE .NOT. EOF()
  	=SEEK (REPSTOCK.QUALITY + REPSTOCK.COLOUR,"RECV")
  	IF .T.
    	REPL REPSTOCK.RECQTY WITH RECV.QUANTITY
    ENDIF
    =SEEK (REPSTOCK.QUALITY + REPSTOCK.COLOUR,"ISSUE")
  	IF .T.
    	REPL REPSTOCK.ISSQTY WITH ISSUE.QUANTITY
    ENDIF 
        =SEEK (REPSTOCK.QUALITY + REPSTOCK.COLOUR,"ORDER")
  	IF .T.
    	REPL REPSTOCK.ORDQTY WITH ORDER.QUANTITY
    ENDIF   
           =SEEK (REPSTOCK.QUALITY + REPSTOCK.COLOUR,"RETN")
  	IF .T.
    	REPL REPSTOCK.RETNQTY WITH RETN.QUANTITY
    ENDIF   
    SELECT REPSTOCK
	IF .NOT. EOF()
	   SKIP
	ENDIF
ENDDO
RETURN
*Eop(2)

*3
PROCEDURE REPORTGEN
SELECT QUALITY,COLOUR,OPENBAL,RECQTY,ISSQTY,OPENBAL+RECQTY-ISSQTY STOCKQTY,ORDQTY DYEORD;
FROM REPSTOCK;
WHERE OPENBAL>0 .OR. RECQTY>0 .OR. ISSQTY>0;
ORDER BY QUALITY,COLOUR;
INTO CURSOR WISTK
RETURN

*Calculate Yarn Requirement form Yarn Calc Chart for only (NotDistri Carpets) till today
**Find Matching PO record crossesponding Yarn Calc Chart
Procedure Yarncalc
SELECT Design, Quality, Colour, Sum(Sqmt) Tsqmt,Label;
FROM  Temp ;
Where Label=.T.;
Group by design,quality,colour;
Order by design,quality,colour;
Into Cursor temp3

Select i.*,j.Tsqmt;
From yrcalc i, temp3 j;
Where i.design=j.design .and. i.quality=j.quality .and. i.basecolour=j.colour;
Into cursor yrcalc1

*.and. i.quality=j.quality .and. i.basecolour=j.colour

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

**Array:placing design,colour,count into Array for Item Included that have yarn chart
Select i.design, i.basecolour,j.ol_no;
From yrcalc i, Temp j;   
Where i.design=j.design .and. i.quality=j.quality .and. i.basecolour=j.colour .and. j.label=.T.;
Order by j.ol_no;
Into cursor yrcalc1ary

SELECT design,basecolour  as colour,Ol_no;
From yrcalc1ary;
Order by design,basecolour;
Into cursor Dgn1


Dimension Adgnunmch1(30,3) NOFILTER
Store '' to Adgnunmch1
Select Dgn1
Copy to Array Adgnunmch1 FIELDS  Design, Colour,Ol_no
Private m.tpcs
m.tpcs=Reccount("Dgn1")
*end of array

*Selecting only required fields
Private Head1

	SELECT QUALITY,COLOUR,YRREQKG,STOCKQTY,DYEORD,YRREQKG-STOCKQTY-DYEORD REORDER;
	FROM YRREORDER;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR WISTK2 NOFILTER
	Head1="Dyed Yarn Reqd For Below NotDistri Order"

Select Wistk2
If RECNO()>RECCOUNT()
	Messagebox("Yarn Chart Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form wireordndistck.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wireordndistck.frx to printer prompt noconsole
Endcase
Endif
RETURN
*Eop(4)
*Into cursor yrcalc3 NOFILTER && Nofilter causes cursor to be temp written in Hard disk can be reused
