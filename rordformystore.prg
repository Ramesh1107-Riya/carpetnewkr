*Program To calculate yarnstore Yarn

Private count1,count2,count3,tvar,var1,var2,var3,var4
tvar=.T.
Create cursor yrcalc2(QUALITY C(12), COLOUR C(10), SQMYARN N(5,2), SQMT N(6,2))

SELECT s.Issdt,b.Po_no,s.Ol_no,s.Supplier,b.Design,b.Colour,b.Quality,b.szcode,b.Qty,b.Sqmt,s.fdate;
FROM  Carpet!cabuyord b, Carpet!casupord s;
Where b.ol_no=s.ol_no .and. s.Issdt=m.Issdt .and. s.Supplier=alltrim(m.Supplier);
Into Cursor temp1
	
SELECT Design, Quality, Colour, Sum(Sqmt) Tsqmt;
From temp1;
Group by Design,quality,colour;
Order by Design,quality,colour;
Into Cursor temp3

Select i.*,j.Tsqmt;
From yrcalc i, temp3 j;
Where i.design=j.design .and. i.quality=j.quality .and. i.basecolour=j.colour;
Into cursor yrcalc1


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
Select i.quality, i.colour, sum(i.sqmt) TotSqmt, sum(i.yrreqkgall) yrreqkg, sum(i.yrreqkgall) ystkbal;  
From yrcalc2a i;
Group by i.quality,i.colour;
ORDER BY i.quality,i.colour;
Into cursor yrcalc3a

*same color may have different yarn per kg used in different design, now we group same color, dummy ystkbal field created  
Select i.quality, i.colour, sum(i.sqmt) TotSqmt, sum(i.yrreqkgall) yrreqkg, i.yrreqkgall*0 ystkbal;  
From yrcalc2a i;
Group by i.quality,i.colour;
ORDER BY i.quality,i.colour;
Into cursor yrcalc3a 

*Yarn Stock Generation
Private m.ystkb,msdate,medate
msdate=pstartdt
*msdate={^2012/01/01}
medate=Date()

store 0 to m.ystkb && *Inserting Yarn stock balance in dummy field ystkbal
Set procedure to wistockrep
Private m.customer
m.customer=""
*do Allcust
do querygen

*Show all data from yrcalc3
Select j.quality, j.colour, j.TotSqmt, j.yrreqkg, k.openbal+k.recqty+retnqty-k.issqty+k.recqtym-k.issqtym+k.retnqtym ystkbal;
From yrcalc3a j LEFT OUTER JOIN repstock1a k ON j.quality=k.quality .and. j.colour=k.colour;
into cursor yrcalc3 NOFILTER && Nofilter causes cursor to be temp written in Hard disk can be reusedR

***********Yarn Store Summary, Same quality and colour in a design is put together**********
Select quality, colour, yrreqkg ystkbal;
From yrcalc3;
into cursor yrcalc4

Dimension ystore(14,4) && array is declared row=14,col=4
Store '' to ystore && initialize array with '', by default .F.
select yrcalc4
Copy to Array ystore
*******************************************************************************************

RETURN