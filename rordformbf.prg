*rordform.prg Finds records for particular Desing,Quality,Colour,Size,IssDate for limit of 26 colours 10/4/2018 review by Ramesh Basnet 
*a) Estimation Done before Distribution 25/4/2018, We have no knowledge of Supplier
***************************************************************************
*We print different size with same colour,quality and design but pick design,colour,quality for particular size from yarn chart
*SET ANSI ON
*SET EXACT ON
Local m.Len1,m.design1,m.Len3
m.Len1=0
m.design1=''
m.Len1=LEN(CHRTRAN(m.Design,'',space(0))) &&Removes between space and Length is given
m.Design1=ALLTRIM(SUBSTR(m.Design,1,m.Len1-1)) && Trying to remove last char
m.Len3=LEN(Alltrim(m.Design)) && For Exact match
***************************************************************************
Open database carpet
SET PROCEDURE TO Catool
* Error Trapping Procedure
ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()

SELECT Po_no,Ol_no,Design,TrimLast2,LEN(alltrim(Design)) AS LEN2,Colour,Quality,szcode,Qty,Sqmt,breadth,length,bcode,po_dt,notes,spcl_inst,fringes,comment,silkpr,cstatus;
FROM  cabuyord;
Where Design=m.Design .and. Colour=m.Colour .and. Quality=m.Quality .and. bcode=m.bcode .and. cstatus='NotDistri' .and. po_no=m.po_no;
Order by Ol_No;
Into Cursor temprepviewa1

SELECT Po_no,Ol_no,iif(Trimlast2=.T.,SUBSTR(DESIGN,1,LEN2-2),Design) AS Design,iif(Trimlast2=.T.,LEN2-2,LEN2) AS LEN2,Colour,Quality,szcode,Qty,Sqmt,breadth,length,bcode,po_dt,notes,spcl_inst,;
		fringes,comment,silkpr,cstatus;
FROM temprepviewa1;
Into Cursor temprepviewa2

SELECT b.Po_no,b.Ol_no,b.Design,b.Len2,b.Colour,b.Quality,b.szcode,b.Qty,b.Sqmt,b.breadth,b.length,b.bcode,b.po_dt,b.notes,s.br_feet,s.br_inch,s.ln_feet,s.ln_inch,b.spcl_inst,;
		b.fringes,b.comment,b.silkpr,b.cstatus;
FROM temprepviewa2 b,casize s;
Where  b.Szcode=s.Szcode;
Order by b.ol_no;
Into Cursor temprepviewa3

SELECT Po_no,Ol_no,Design,Len2,Colour,Quality,szcode,Qty,Sqmt,breadth,length,bcode,po_dt,notes,br_feet,br_inch,ln_feet,ln_inch,spcl_inst,fringes,comment,silkpr,cstatus;
FROM temprepviewa3;
Where len2=m.len3 .or. len2=m.len3-2; && done for adjusting tirm( s) 2char for sample
Order by ol_no;
Into Cursor temprepview
**********************************************************************	
Select temprepview
Dimension cardolno(37,7) && array is declared row=37,col=3
Store '' to cardolno && initialize array with '', by default .F.
Copy to Array Cardolno FIELDS Ol_no,szcode,sqmt,br_feet,br_inch,ln_feet,ln_inch

SELECT Distinc Po_no,Ol_no,Design,Colour,Quality,szcode,sum(Sqmt) Sqmt,Sum(Qty)Qty,breadth,length,po_dt,bcode,notes,spcl_inst,fringes,comment,silkpr;
FROM  temprepview;
Group by Design,Quality,Colour; 
Into Cursor temprepview1
Select temprepview1
*******For Sumation of Sqmt and Qty*******************
SELECT szcode,sum(Sqmt) Sqmt,Sum(Qty)Qty;
FROM  temprepview;
Group by Quality; 
Into Cursor temp1

***Done to catch one size only****14/1/2019**
Private m.TQty,m.TSqmt
Local m.szcode1

Select temp1
m.szcode1=temp1->Szcode
m.TQty=temp1->Qty
m.TSqmt=temp1->Sqmt
**********************************************************************	
*Till above we are not worried about size, but to link yarn chart we to to link exact yarn chart design.
*original select statement changed on 17/5/2020 we have 245 yrncalc fields + 9 fields from tempreviews = 254, allowed Max Limit 255 fields
*SELECT j.*, k.Qty, k.breadth, k.length, k.po_dt,k.sqmt,k.bcode,k.colour,k.notes,k.spcl_inst,k.fringes,k.comment,k.silkpr,k.po_no as orderno,k.ol_no as carpetno
SELECT j.*, k.po_dt,k.bcode,k.colour,k.notes,k.spcl_inst,k.fringes,k.comment,k.silkpr,k.po_no as orderno;
FROM  yrcalc j, temprepview1 k;
Where alltrim(j.design)=k.design .and. alltrim(j.basecolour)=k.Colour .and. alltrim(j.quality)=k.quality .and. alltrim(j.szcode)=m.szcode1 .and. LEN(alltrim(j.Design))=LEN(alltrim(k.Design));
Group by j.Design,j.quality,j.basecolour,j.szcode; && done to select only one design from list 14/10/2019
Into Cursor temprepview2  Nofilter
*Group by j.Design,j.quality,j.basecolour,j.szcode,j.continue; && done to select only one design from list 14/10/2019 original
************Yarn Store comparision***********************************
Private count1,count2,count3,count4,count5,count6,count7,count8,count9,m.quality,m.colour,m.sqmyarn,m.po_no,m.slno,m.ply,m.loop,m.rod,m.sqmt,m.recordcnt,m.avgconsm,;
		m.design,m.basecolour,m.bcode,m.remark
tvar=.T.
m.gtreqkg=0
Create cursor yrcalc2(QUALITY C(12),COLOUR C(10),SQMYARN N(5,2),SLNO N(3),PLY C(2),LOOP C(13),ROD C(2),SQMT N(6,2),AVGCONSM N(5,2),;
		DESIGN C(20),BASECOLOUR C(10),SZCODE C(10),CAQUALITY C(12),REMARK C(20),rec c(3))

SELECT Design, Quality as Caquality, Colour,szcode,Sum(Sqmt) Tsqmt;
From temprepview;
Group by Design,quality,colour;
Into Cursor temp3

*Order by Design,quality,colour 29/08/2021 Removed by ramesh

Select i.*,j.Tsqmt,j.Caquality;
From yrcalc i, temp3 j;
Where i.design=j.design .and. i.quality=j.Caquality .and. i.basecolour=j.colour .and. i.szcode=m.szcode1 .and. LEN(alltrim(i.Design))=LEN(alltrim(j.Design));
Group by i.Design,i.quality,i.basecolour,i.szcode,i.continue;
Into cursor yrcalc1

Select yrcalc1
m.caquality=yrcalc1->Caquality
m.sqmt=yrcalc1->Tsqmt
m.avgconsm=yrcalc1->Avgconsm
m.design=yrcalc1->Design
m.basecolour=yrcalc1->Basecolour
m.szcode=yrcalc1->szcode
Scan while (.not. eof())
	For count1=1 to 26 Step 1
		count4="QLTY"+right("00"+Alltrim(Str(count1)),2) 
		count2="COLOUR"+right("00"+Alltrim(Str(count1)),2)
		count3="SQMYARN"+right("00"+Alltrim(Str(count1)),2)
		count5="SLNO"+right("00"+Alltrim(Str(count1)),2) 
		count6="PLY"+right("00"+Alltrim(Str(count1)),2) 
		count7="LOOP"+right("00"+Alltrim(Str(count1)),2) 
		count8="ROD"+right("00"+Alltrim(Str(count1)),2)
		count9="RMK"+right("00"+Alltrim(Str(count1)),2)
		m.quality=&count4
		m.colour=&count2
		m.sqmyarn=&count3		
		m.slno=&count5		
		m.ply=&count6
		m.loop=&count7
		m.rod=&count8
		m.remark=&count9
	if(empty(yrcalc1->&count2))
			loop
		else
			Insert into yrcalc2(quality,colour,sqmyarn,slno,ply,loop,rod,sqmt,avgconsm,design,basecolour,szcode,caquality,remark);
					 Values(m.quality,m.colour,m.sqmyarn,m.slno,m.ply,m.loop,m.rod,m.sqmt,m.avgconsm,m.design,m.basecolour,m.szcode,m.caquality,m.remark)
		endif
	Endfor
	Select yrcalc1
Endscan

Select distin i.slno,j.po_no,i.quality,i.colour,i.sqmt,i.ply,i.loop,i.rod,i.sqmt*i.sqmyarn as yrreqkgall,i.avgconsm,i.design,i.basecolour,j.szcode,i.caquality,j.bcode,;
		j.Ol_no,j.Qty,j.breadth,j.length,j.po_dt,j.notes,j.spcl_inst,j.fringes,j.comment,j.silkpr,j.po_no as orderno,j.ol_no as carpetno,i.remark; 
From yrcalc2 i, temprepview1 j;
Where i.design=m.design .and. i.basecolour=j.Colour .and. i.caquality=j.quality .and. i.szcode=j.szcode;
Order by i.slno,i.ply desc;
Into cursor yrcalc3 

*Order by i.slno,i.ply desc; 19/08/2021 removed by Ramesh asked by chompel to look alike entry in yarn chart + addes on 31/08/2021 on request Chomphel
*********count record*****************
Select count(colour) as recordcnt; 
From yrcalc3 ;
Into cursor yrcalcnt 
m.recordcnt=yrcalcnt->recordcnt
**************************************

Select temprepview2
SET COLOR TO
If RECNO()>RECCOUNT()
	WAIT WINDOW"Either Colour Chart is Not Defined/ [Not Verified] - Date is empty in Yarn Chart for above Design!" NOWAIT
	  Select temprepview1   
	   Do Case
		 Case m.PrnStat="V"
			Report form rordform-emtybf.frx PREVIEW WINDOW wReport 
			DEACTIVATE WINDOW wReport 
   		 Case m.PrnStat="P"
			Report form rordform-emtybf.frx to printer prompt noconsole
 	   Endcase
Else
  Do Case
	Case m.PrnStat="V" .and. m.recordcnt=<26
		Select temprepview2
		Report form rordformbf.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P" .and. m.recordcnt=<26
		Select temprepview2
		Report form rordformbf.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.recordcnt>26
		SELECT yrcalc3
		Report form rordformlngbf.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P" .and. m.recordcnt>26
		SELECT yrcalc3
		Report form rordformlngbf.frx to printer prompt noconsole
  Endcase
Endif
RETURN


