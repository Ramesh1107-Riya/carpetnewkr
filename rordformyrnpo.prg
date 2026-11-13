*rordforyrnpo.prg Calculates total yarn for a po_no calculated based on b.Sqmt of same design,colour,quality
Set Date to Briti
Set Century on
SET ANSI ON
Private m.totpcs, m.totdgn, m.allpcs , m.unmatchpcs

*Total Pcs in a PO
SELECT b.po_no, b.Design,b.Colour,b.Quality,b.Sqmt;
FROM  Carpet!cabuyord b;
WHERE alltrim(b.po_no)=alltrim(m.po_no) ;
Into Cursor temp1a
m.allpcs=Reccount("temp1a")

*** Un-matched  Distinct Colour, Design, Quality pcs in a PO with Yarn Calc Chart .i.e Yrcalc.dbf
SELECT Distinct b.Colour, b.Design, b.Quality;
FROM  Carpet!cabuyord b ;
WHERE  .NOT. EXISTS (SELECT * FROM Yrcalc i;
					 Where i.design=b.design .and. i.quality=b.quality .and. i.basecolour=b.colour);
HAVING alltrim(b.po_no)=alltrim(m.po_no);
Into Cursor temp2a

Dimension Adgnunmch(40,3) 
Store '' to Adgnunmch
Select temp2a
Copy to Array Adgnunmch FIELDS Colour, Design, Quality
**All Unmatched pcs
SELECT b.Colour, b.Design, b.Quality;
FROM  Carpet!cabuyord b ;
WHERE  .NOT. EXISTS (SELECT * FROM Yrcalc i;
					 Where i.design=b.design .and. i.quality=b.quality .and. i.basecolour=b.colour);
HAVING alltrim(b.po_no)=alltrim(m.po_no);
Into Cursor temp3a
m.unmatchpcs=Reccount("temp3a")

* Find Matching YRCALC CHART For DISPLY OF DESIGNS*** Assumption An Order has max of 70 designs, at present 40 designs in a PO exists
* 70 designs appear in report header but can calculate any nos of design
SELECT b.po_no, b.Design,b.Colour,b.Quality,b.Sqmt;
FROM  Carpet!cabuyord b, yrcalc i ;
WHERE i.design=b.design .and. i.quality=b.quality .and. i.basecolour=b.colour;
HAVING alltrim(b.po_no)=alltrim(m.po_no) ;
Into Cursor temp1

* Finding No. of Desings for Display
Select j.Design,Count(j.Design) Dgncnt;
From yrcalc i, temp1 j;
Where i.design=j.design .and. i.quality=j.quality .and. i.basecolour=j.colour;
Order By j.design;
Group by j.design;
into cursor temp2


Dimension Arydgn(70,2) && array is declared row=70,col=2
Store '' to Arydgn && initialize array with '', by default .F.
Select temp2
Copy to Array Arydgn FIELDS Design, Dgncnt
m.totpcs=Reccount("temp1")
m.totdgn=Reccount("temp2")


**Find Matching PO record crossesponding Yarn Calc Chart
SELECT Design, Quality, Colour, Sum(Sqmt) Tsqmt;
FROM  Carpet!cabuyord;
WHERE alltrim(po_no)=alltrim(m.po_no); 
Group by design,quality,colour;
Order by design,quality,colour;
Into Cursor temp3

Select i.*,j.tsqmt;
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
ORDER BY i.quality,i.colour;
Into cursor yrcalc2a 

*same color may have different yarn per kg used in different design, now we group same color  
Select i.quality, i.colour, sum(i.sqmt) TotSqmt, sum(yrreqkgall) yrreqkg;  
From yrcalc2a i;
Group by i.quality,i.colour;
ORDER BY i.quality,i.colour;
Into cursor yrcalc3 NOFILTER && Nofilter causes cursor to be temp written in Hard disk can be reused
**********

Select yrcalc3
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found!! Colour Chart is Not Defined for the above Design!")
Else
Do Case
	Case m.PrnStat="V"
		Report form rordformypo.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form rordformypo.frx to printer prompt noconsole
Endcase
Endif
RETURN