*rordformyrndnb.prg
*having carpet cstatus="Not Distributed"  carpet based on b.Sqmt of same Design,Colour,Quality
*From White Yarn store stock seen to check natural colour that is being issued to Dyeing
*From Dyed Yarn Store stock 
SET PROCEDURE TO Catool
Set Date to Briti
Set Century on
SET ANSI ON

SELECT Bcode,Ol_no,Po_no,Po_dt,Design,Colour,Quality,szcode,Qty,Sqmt,yrncaldt as delivery_dt,Notes;
FROM  Carpet!cabuyord;
Where Design=alltrim(m.Design) .and. Colour=alltrim(m.Colour) .and. Quality=alltrim(m.Quality) .and. cstatus='NotDistri';
Into Cursor temp2

*** To Show Avgconsm**********
Select avgconsm;
From Caqlty q,temp2 y;
Where alltrim(q.code)=alltrim(y.quality);
Into Cursor cqlty
m.avgconsm=cqlty->avgconsm
	
******ONLY YRCALC CHART RECORD INCLUDED IN DISPLY OF CARD NOS**********	
Select j.Ol_No,j.szcode;   &&  j.Card_No=Ol_No for HT 5/6/2015
From yrcalc i, temp2 j;
Where i.design=j.design .and. i.quality=j.quality .and. i.basecolour=j.colour;
Order By j.Ol_No;
Into cursor temp2a

*****To Display OL_NO and Std. Size in Report********
Dimension card(64,2) && array is declared row=12,col=1
Store '' to card && initialize array with '', by default .F.
select temp2a
Copy to Array Card FIELDS Ol_no,szcode
Private m.cardcount
m.cardcount=Reccount("Temp2a")
*************************************

SELECT Bcode,Po_no,Po_dt,Design,Quality,Colour,Sum(Qty) Tqty,delivery_dt,Notes,Sum(Sqmt) Tsqmt;
From temp2;
Group by Design,quality,colour;
Order by Design,quality,colour;
Into Cursor temp3

Dimension hdata(1,10) && array is declared row=1,col=10
Store '' to hdata && initialize array with '', by default .F.
select temp3
Copy to Array hdata FIELDS Design,Quality,Colour,Po_no,Po_dt,Notes,TQty,Tsqmt,delivery_dt,Bcode	

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
		var4=yrcalc1.tsqmt
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
ORDER BY i.quality, i.colour;
Into cursor yrcalc2a 

*same color may have different yarn per kg used in different design, now we group same color, dummy ystkbal field created  
Select i.quality, i.colour, sum(i.sqmt) TSqmt, sum(i.yrreqkgall) yrreqkg, sum(i.yrreqkgall)*0 ystkbal;  
From yrcalc2a i;
Group by i.quality,i.colour;
ORDER BY i.quality,i.colour;
Into cursor yrcalc3a  && this is JOINING FILE AT THE ENDI

*Yarn Stock Generation
Private m.ystkb,msdate,medate
msdate=pstartdt
medate=Date()

**************************
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
Select j.quality,j.colour,j.TSqmt,j.yrreqkg, k.balance as ystkbal;
From yrcalc3a j LEFT OUTER  JOIN StkBoth k ON j.quality=k.quality .and. j.colour=k.colour;
into cursor yrcalc3

Select yrcalc3 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found!! Colour Chart is Not Defined for the above Design!")
Else
Do Case
	Case m.PrnStat="V"
		Report form rordformydnb.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form rordformydnb.frx to printer prompt noconsole
Endcase
Endif
RETURN