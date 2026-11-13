*rordform.prg Finds records for particular Desing,Quality,Colour,Size,IssDate  18/9/2018 review by Ramesh Basnet 
*a) Estimation Done before Distribution, We have no knowledge of Supplier
***************************************************************************
*SET PROCEDURE TO Catool
* Error Trapping Procedure
*ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()
Local m.Len1,m.design1
m.Len1=LEN(CHRTRAN(m.Design,'',space(0))) &&Removes between space and Length is given
m.Design1=SUBSTR(m.Design,1,m.len1-1) && Trying to remove last char
***************************************************************************
SELECT Po_no,Ol_no,Design,TrimLast2,LEN(alltrim(Design)) AS LEN2,Colour,Quality,szcode,Qty,Sqmt,breadth,length,bcode,po_dt,notes,spcl_inst,fringes,comment ,silkpr,cstatus,estdt;
FROM  cabuyord ;
Where Design=m.Design .and. Colour=m.Colour .and. Quality=m.Quality .and. (cstatus='NotDistri' .or. cstatus='On-Loom') .and. estdt=m.estdt;
Into Cursor temprepviewa1 

SELECT Po_no,Ol_no,iif(Trimlast2=.T.,SUBSTR(DESIGN,1,LEN2-2),Design) AS Design,Len2,Colour,Quality,szcode,Qty,Sqmt,breadth,length,bcode,po_dt,notes,spcl_inst,estdt,;
		fringes,comment,silkpr,cstatus;
FROM temprepviewa1;
Where Len2=m.Len3;
Into Cursor temprepview
**********************************************************************	
Select temprepview  
Dimension cardolno(37,4) && array is declared row=37,col=3
Store '' to cardolno && initialize array with '', by default .F.
Copy to Array Cardolno FIELDS Ol_no,szcode,sqmt,po_dt

SELECT Po_no,Ol_no,Design,Colour,Quality,szcode,sum(Sqmt) Sqmt,Sum(Qty)Qty,breadth,length,po_dt,bcode,notes,fringes,comment,silkpr,spcl_inst,estdt;
FROM  temprepview;
Group by Bcode,Design,Quality,Colour,szcode; 
Order by bcode,Design,quality,colour,szcode;
Into Cursor temprepview1
**********************************************************************	
SELECT j.*,k.Qty, k.breadth, k.length, k.po_dt,k.sqmt,k.bcode,k.colour,k.notes,k.fringes,k.comment,k.silkpr,k.po_no as orderno,	k.spcl_inst,k.ol_no as carpetno;
FROM  yrcalc j,  temprepview1 k; 
Where j.design=k.design .and. j.basecolour=k.Colour .and. j.quality=k.quality .and. j.szcode=k.szcode .and. !empty(j.date);
Into Cursor temprepview2  Nofilter
select temprepview2
brow
************Yarn Store comparision***********************************
Private count1,count2,count3,count4,count5,count6,count7,count8,m.quality,m.colour,m.sqmyarn,m.po_no,m.slno,m.ply,m.loop,m.rod,m.sqmt,m.recordcnt,m.avgconsm,;
		m.design,m.basecolour,m.bcode
tvar=.T.
m.gtreqkg=0
Create cursor yrcalc2(QUALITY C(12),COLOUR C(10),SQMYARN N(5,2),SLNO N(2),PLY C(2),LOOP C(13),ROD C(2),SQMT N(6,2),AVGCONSM N(5,2),DESIGN C(20),BASECOLOUR C(10),SZCODE C(11),CAQUALITY C(12))

*Select yrcalc1
Select temprepview2
Scan while (.not. eof())
m.caquality=temprepview2->quality
m.sqmt=temprepview2->sqmt
m.avgconsm=temprepview2->Avgconsm
m.design=temprepview2->Design
m.basecolour=temprepview2->Basecolour
m.szcode=temprepview2->szcode
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
	if(empty(temprepview2->&count2))
			loop
		else
			Insert into yrcalc2(quality,colour,sqmyarn,slno,ply,loop,rod,sqmt,avgconsm,design,basecolour,szcode,caquality);
					 Values(m.quality,m.colour,m.sqmyarn,m.slno,m.ply,m.loop,m.rod,m.sqmt,m.avgconsm,m.design,m.basecolour,m.szcode,m.caquality)
		endif
	Endfor
	Select temprepview2	
	*Select yrcalc1
Endscan

*we calculate individual yarnrequred for same color with all values than sum in the next query
**Report for Quality, Colour>26, select yrcalc2a.dbf for 2nd option
Select i.slno,j.po_no,i.quality,i.colour,i.sqmt,i.ply,i.loop,i.rod,i.sqmt*i.sqmyarn as yrreqkgall,i.avgconsm,i.design,i.basecolour,j.szcode,i.caquality,j.bcode,;
		j.Ol_no,j.Qty,j.breadth,j.length,j.po_dt,j.notes,j.fringes,j.comment,j.silkpr,j.po_no as orderno,j.ol_no as carpetno,spcl_inst;  
From yrcalc2 i, temprepview1 j;
Where i.design=m.design .and. i.basecolour=j.Colour .and. i.caquality=j.quality .and. i.szcode=j.szcode ;
ORDER BY j.ol_no,i.slno;
Into cursor yrcalc2a 

Select slno,po_no,quality,colour,sum(sqmt) sqmt,ply,loop,rod,sum(yrreqkgall) yrreqkgall,avgconsm,design,basecolour,szcode,caquality,bcode,;
		Ol_no,sum(Qty) qty,breadth,length,po_dt,notes,fringes,comment,silkpr,po_no as orderno,ol_no as carpetno,spcl_inst;  
From yrcalc2a;
Group by Bcode,Design,Quality,Colour;
order by slno;
Into cursor yrcalc3 

*********count record*****************
Select count(colour) as recordcnt; 
From yrcalc3 ;
Into cursor yrcalcnt 
m.recordcnt=yrcalcnt->recordcnt
**************************************

*************End of Yarn Store Comparision*************************************************************************
SELECT yrcalc3
SET COLOR TO
If RECNO()>RECCOUNT()
	WAIT WINDOW"Either Colour Chart is NOT Defined/ Colour Chart DATE is Empty / Buyer Order NOT Entered for above Design!" NOWAIT
	  Select temprepview1   
	   Do Case
		 Case m.PrnStat="V"
			Report form rordform-emtyet.frx PREVIEW WINDOW wReport 
			DEACTIVATE WINDOW wReport 
   		 Case m.PrnStat="P"
			Report form rordform-emtyet.frx to printer prompt noconsole
 	   Endcase
Else
  Do Case
	Case m.PrnStat="V" .and. m.recordcnt=<26
		Report form rordformet.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P" .and. m.recordcnt=<26
		Report form rordformet.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.recordcnt>26
		select yrcalc2a
		Report form rordformlnget.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P" .and. m.recordcnt>26
		select yrcalc2a
		Report form rordformlnget.frx to printer prompt noconsole
  Endcase
Endif
RETURN
**************

