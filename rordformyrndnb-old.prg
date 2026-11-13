*rordformyrn.prg Calculates total yarn required to weave order carpet  Qualitywise for a Supplier
*having carpet cstatus="Not Distributed" and 'Distributed' carpet base on b.Sqmt of same Colour,Quality,Design

SET PROCEDURE TO Catool
Set Date to Briti
Set Century on
SET ANSI ON


* Public Variable for Carpet-Inventory Search Option !!
*PUBLIC m.psCardNo

**Initialization
*STORE SPACE(150) TO m.psCardNo
*m.psCardNo = m.Card_no && variable in defined in Order form

*set procedure to catool
*DO csTrimInfo6    && Trim Information for Check Purpose !
*Open Database Carpet

	SELECT ol_no,Po_no,Po_dt,Design,Colour,Quality,szcode,Qty,Sqmt;
	FROM  Carpet!cabuyord;
	Where Design=alltrim(m.Design) .and. Colour=alltrim(m.Colour) .and. Quality=alltrim(m.Quality) .and. cstatus='NotDistri';
	Into Cursor temp2
	
	* .and. empty(s.loomdt).and. b.Design=m.Design .and. b.Colour=m.Colour;
	*			 .and. b.Quality=m.Quality .and. b.szcode=m.szcode

    *SELECT Po_no,Ol_no,Design,Colour,Quality,szcode,Qty,Sqmt;
	*FROM temp1;
	*WHERE ccsMatch14(Card_No);
	*Into Cursor temp2 

******ONLY YRCALC CHART RECORD INCLUDED IN DISPLY OF CARD NOS**********	
Select j.Ol_No;   &&  j.Card_No=Ol_No for HT 5/6/2015
From yrcalc i, temp2 j;
Where i.design=j.design .and. i.quality=j.quality .and. i.basecolour=j.colour;
Order By j.Ol_No;
Into cursor temp2a

Dimension card(194,1) && array is declared row=12,col=1
Store '' to card && initialize array with '', by default .F.
select temp2a
Copy to Array Card FIELDS Ol_no
Private m.cardcount
m.cardcount=Reccount("Temp2a")
*************************************

	SELECT Design, Quality, Colour, Sum(Sqmt) Tsqmt;
	From temp2;
	Group by Design,quality,colour;
	Order by Design,quality,colour;
	Into Cursor temp3

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