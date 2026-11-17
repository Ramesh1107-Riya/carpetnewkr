*rordform.prg Finds records for particular Desing,Quality,Colour,Size,IssDate for limit of 26 colours 10/4/2018 review by Ramesh Basnet 
*a) Estimation Done before Distribution
*b) Estimation Done after Distribution 12/04/2018 Doing

SET PROCEDURE TO Catool
* Error Trapping Procedure
ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()

SELECT s.Issdt,b.Po_no,s.Ol_no,s.Supplier,b.Design,b.Colour,b.Quality,b.szcode,b.Qty,b.Sqmt,b.breadth,b.length,s.wev_last_dt,b.bcode,b.notes,b.comment,s.grpid;
FROM  Carpet!cabuyord b, Carpet!casupord s;
Where b.ol_no=s.ol_no .and. s.Issdt=m.Issdt .and. s.Supplier=alltrim(m.Supplier) .and. b.Design=m.Design .and. b.Colour=m.Colour .and. b.Quality=m.Quality;
Into Cursor temprepview 
**********************************************************************	
Select temprepview  
Dimension cardolno(37,5) && array is declared row=37,col=3
Store '' to cardolno && initialize array with '', by default .F.
Copy to Array Cardolno FIELDS Ol_no,szcode,sqmt,wev_last_dt,po_no

SELECT Issdt,Po_no,Ol_no,Supplier,Design,Colour,Quality,szcode,sum(Sqmt) Sqmt,Sum(Qty)Qty,breadth,length,wev_last_dt,bcode,notes,comment,grpid;
FROM  temprepview;
Group by Design,Quality,Colour; 
Into Cursor temprepview1
**********************************************************************	
SELECT j.*,k.Issdt, k.Ol_no, k.Supplier, k.Qty, k.breadth, k.length, k.wev_last_dt,k.sqmt,k.bcode,k.po_no,k.notes,k.comment,k.grpid;
FROM  yrcalc j, temprepview1 k;
Where j.design=k.design .and. j.basecolour=k.Colour .and. j.quality=k.quality .and. !empty(j.date);
Into Cursor temprepview2  Nofilter

************Yarn Store comparision***********************************
Private count1,count2,count3,count4,count5,count6,count7,count8,m.quality,m.colour,m.sqmyarn,m.po_no,m.slno,m.ply,m.loop,m.rod,m.sqmt,m.recordcnt,m.avgconsm,;
		m.design,m.basecolour,m.bcode
tvar=.T.
m.gtreqkg=0
Create cursor yrcalc2(QUALITY C(12),COLOUR C(10),SQMYARN N(5,2),SLNO N(2),PLY C(2),LOOP C(13),ROD C(2),SQMT N(6,2),AVGCONSM N(5,2),;
		DESIGN C(20),BASECOLOUR C(10),CAQUALITY C(12))

SELECT Design, Quality, Colour,szcode,Sum(Sqmt) Tsqmt;
From temprepview;
Group by Design,quality,colour;
Order by Design,quality,colour;
Into Cursor temp3

Select i.*,j.Tsqmt;
From yrcalc i, temp3 j;
Where i.design=j.design .and. i.quality=j.quality .and. i.basecolour=j.colour;
Into cursor yrcalc1

Select yrcalc1
m.caquality=yrcalc1->quality
m.sqmt=yrcalc1->Tsqmt
m.avgconsm=yrcalc1->Avgconsm
m.design=yrcalc1->Design
m.basecolour=yrcalc1->Basecolour
Scan while (.not. eof())
	For count1=1 to 26 Step 1
		count4="QLTY"+right("00"+Alltrim(Str(count1)),2) 
		count2="COLOUR"+right("00"+Alltrim(Str(count1)),2)
		count3="SQMYARN"+right("00"+Alltrim(Str(count1)),2)
		count5="SLNO"+right("00"+Alltrim(Str(count1)),2) 
		count6="PLY"+right("00"+Alltrim(Str(count1)),2) 
		count7="LOOP"+right("00"+Alltrim(Str(count1)),2) 
		count8="ROD"+right("00"+Alltrim(Str(count1)),2) 
		m.quality=&count4
		m.colour=&count2
		m.sqmyarn=&count3		
		m.slno=&count5		
		m.ply=&count6
		m.loop=&count7
		m.rod=&count8		
	if(empty(yrcalc1->&count2))
			loop
		else
			Insert into yrcalc2(quality,colour,sqmyarn,slno,ply,loop,rod,sqmt,avgconsm,design,basecolour,caquality);
					 Values(m.quality,m.colour,m.sqmyarn,m.slno,m.ply,m.loop,m.rod,m.sqmt,m.avgconsm,m.design,m.basecolour,m.caquality)
		endif
	Endfor
	Select yrcalc1
Endscan

*we calculate individual yarnrequred for same color with all values than sum in the next query
**Report for Quality, Colour>26, select yrcalc2a.dbf for 2nd option, Select int(val(alltrim(i.slno))) as slnoval
Select i.slno as slnoval,j.po_no,i.quality,i.colour,i.sqmt,i.ply,i.loop,i.rod,i.sqmt*i.sqmyarn as yrreqkgall,i.avgconsm,i.design,i.basecolour,j.szcode,i.caquality,j.bcode,;
		j.Issdt,j.Ol_no,j.Supplier,j.Qty,j.breadth,j.length,j.wev_last_dt,j.notes,j.comment,j.grpid;
From yrcalc2 i, temprepview1 j;
Where i.design=j.design .and. i.basecolour=j.Colour .and. i.caquality=j.quality;
ORDER BY i.quality,i.colour;
Into cursor yrcalc2b 

Select slnoval as slno,po_no,quality,colour,sqmt,ply,loop,rod,yrreqkgall,avgconsm,design,basecolour,szcode,caquality,bcode,;
		Issdt,Ol_no,Supplier,Qty,breadth,length,wev_last_dt,notes,comment,grpid;  
From yrcalc2b ;
ORDER BY slnoval,quality,colour;
Into cursor yrcalc2a 

*********count record*****************
Select count(colour) as recordcnt; 
From yrcalc2a ;
Into cursor yrcalcnt 
m.recordcnt=yrcalcnt->recordcnt
**************************************

*same color may have different yarn per kg used in different design, now we group same color, dummy ystkbal field created  
Select i.quality, i.colour, sum(i.sqmt) TotSqmt, sum(i.yrreqkgall) yrreqkg;  
From yrcalc2a i;
Group by i.quality,i.colour;
ORDER BY i.quality,i.colour;
Into cursor yrcalc3a

**********Calculating White Yarn + Dyed Yarn Stock*******************************************
*Purpose: Calculate stock balance of both White Yarn stock & Dyed Yarn Stock; Update it into Yarn Requirement List
*Update required balnce to Yarn Requirement List form Yarn Calculation
*Calling program 
*Assumption: Zero for not available qyt
*1. White Yarn Stocck Calcualtion
	Set Procedure to yarnstk     && White Yarn Stock *.prg	
	Private msdate,medate  && Yarnstk contains these variables
	medate=date()
	msdate={^2018/01/01}				
	Do Querygen
	Do Whitestk
	SELECT QUALITY,COLOUR,BALANCE;
	FROM WHTSTOCK;
	INTO CURSOR Whtstk  Nofilter
	
*2. Calculate Dyed Yarn Stock	
	CREATE CURSOR WSTOCK (QUALITY C(10),COLOUR C(10),OPENBAL N(10,3),RECQTY N(11,3),RETNQTY N(11,3),ISSQTY N(11,3))
	SELECT WSTOCK
	APPEND FIELDS QUALITY,COLOUR,OPENBAL FROM WISTOCK 

	SELECT QUALITY,COLOUR,SUM(QUANTITY) RECQTY;
	FROM WIRECV;
	GROUP BY QUALITY,COLOUR;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR RECV
	SELECT WSTOCK
	APPEND FIELDS QUALITY,COLOUR,RECQTY FROM DBF ('RECV') 

	SELECT QUALITY,COLOUR,SUM(QUANTITY) RETNQTY;
	FROM WIRETURN;
	WHERE dyewht='D';
	GROUP BY QUALITY,COLOUR;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR RETN
	SELECT WSTOCK
	APPEND FIELDS QUALITY,COLOUR,RETNQTY FROM DBF ('RETN') 

	SELECT QUALITY,COLOUR,SUM(QUANTITY) ISSQTY;
	FROM WIISSUE;
	WHERE dyewht='D';
	GROUP BY QUALITY,COLOUR;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR ISSUE
	SELECT WSTOCK
	APPEND FIELDS QUALITY,COLOUR,ISSQTY FROM DBF ('ISSUE')

	Select Quality,Colour,sum(openbal+recqty+retnqty-issqty) balance;
	From Wstock;
	GROUP BY QUALITY,COLOUR;
	ORDER BY QUALITY,COLOUR;
	Into Cursor Wstock1
	
	SELECT QUALITY,COLOUR,BALANCE;
	FROM Whtstk;
	Union All;
	SELECT QUALITY,COLOUR,BALANCE;
	FROM Wstock1;
	Into Cursor StkBoth1
**********19/4/2016 Added	
	SELECT QUALITY,COLOUR,SUM(BALANCE) AS BALANCE;
	FROM StkBoth1;
	GROUP BY QUALITY,COLOUR;
	ORDER BY QUALITY,COLOUR;
	INTO CURSOR StkBoth
**************End of White Yarn + Dyed Yarn Stock************************

Select j.quality, j.colour, j.TotSqmt, j.yrreqkg, k.balance as ystkbal;
From yrcalc3a j LEFT OUTER  JOIN StkBoth k ON j.quality=k.quality .and. j.colour=k.colour;
into cursor yrcalc3
*Where j.yrreqkg>0 && to balance left outer join for empty estimation 19/04/2018
***********Yarn Store Summary, Same quality and colour in a design is put together**********
Select quality, colour, sum(yrreqkg) GTreqkg,ystkbal;
From yrcalc3;
into cursor yrcalc5

Select yrcalc5
m.GTreqkg=yrcalc5->GTreqkg

Select quality, colour, yrreqkg, ystkbal;
From yrcalc3;
into cursor yrcalc4
**Empty 0 balnce, Null no transaction

Dimension ystore(60,4) && array is declared row=26,col=4 for one page report, Limit 60 rows for long report total of different repeated quality+colour
Store '' to ystore && initialize array with '', by default .F.
select yrcalc4
Copy to Array ystore
*************End of Yarn Store Comparision*************************************************************************

SELECT temprepview2
SET COLOR TO
If RECNO()>RECCOUNT()
	WAIT WINDOW"Either Colour Chart is Not Defined/ [Not Verified] - Date is empty in Yarn Chart for above Design!" NOWAIT
	  Select temprepview1   
	   Do Case
		 Case m.PrnStat="V"
			Report form rordform-emty.frx PREVIEW WINDOW wReport 
			DEACTIVATE WINDOW wReport 
   		 Case m.PrnStat="P"
			Report form rordform-emty.frx to printer prompt noconsole
 	   Endcase
Else
  Do Case
	Case m.PrnStat="V" .and. m.recordcnt=<26
		Report form rordform.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P" .and. m.recordcnt=<26
		Report form rordform.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.recordcnt>26
		select yrcalc2a
		Report form rordformlng.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P" .and. m.recordcnt>26
		select yrcalc2a
		Report form rordformlng.frx to printer prompt noconsole
  Endcase
Endif
RETURN
**************

