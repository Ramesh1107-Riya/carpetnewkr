*rordform.prg Finds records for particular Desing,Quality,Colour,Size,IssDate  18/9/2018 review by Ramesh Basnet 
*a) Estimation Done before Distribution, We have no knowledge of Supplier
***************************************************************************
SET PROCEDURE TO Catool
* Error Trapping Procedure
ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()
Local m.Len1,m.design1,m.Len3
m.Len1=0
m.design1=''
m.Len1=LEN(CHRTRAN(m.Design,'',space(0))) &&Removes between space and Length is given
m.Design1=ALLTRIM(SUBSTR(m.Design,1,m.Len1-1)) && Trying to remove last char
m.Len3=LEN(Alltrim(m.Design))
***************************************************************************
SELECT Po_no,Ol_no,Design,TrimLast2,LEN(alltrim(Design)) AS LEN2,Colour,Quality,szcode,Qty,Sqmt,breadth,length,bcode,po_dt,notes,spcl_inst,fringes,comment ,silkpr,cstatus,estdt;
FROM  cabuyord;
Where Design=m.Design .and. Colour=m.Colour .and. Quality=m.Quality .and. (cstatus='NotDistri' .or. cstatus='On-Loom') .and. estdt=m.estdt;
Into Cursor temprepviewa1 

SELECT Po_no,Ol_no,iif(Trimlast2=.T.,SUBSTR(DESIGN,1,LEN2-2),Design) AS Design,iif(Trimlast2=.T.,LEN2-2,LEN2) AS LEN2,Colour,Quality,szcode,Qty,Sqmt,breadth,length,bcode,po_dt,notes,spcl_inst,estdt,;
		fringes,comment,silkpr,cstatus;
FROM temprepviewa1;
Into Cursor temprepviewa2

**For Processing LEN2 AND DESIGN
SELECT Po_no,Ol_no,Design,Len2,Colour,Quality,szcode,Qty,Sqmt,breadth,length,bcode,po_dt,notes,spcl_inst,estdt,fringes,comment,silkpr,cstatus;
FROM temprepviewa2;
Where len2=m.len3 .or. len2=m.len3-2; && done for adjusting trim( s) 2char for sample
Into Cursor temprepview

**********************************************************************	
Select temprepview
Dimension cardolno(37,4) && array is declared row=37,col=3
Store '' to cardolno && initialize array with '', by default .F.
Copy to Array Cardolno FIELDS Ol_no,szcode,sqmt,po_dt

**************Over all toal (not size wise) For Total Sqmt & Total pcs********
SELECT Design,quality, Colour,szcode,Sum(Sqmt) Tsqmt,Sum(Qty) TQty;
From temprepview;
Group by Design,quality,colour;
Into Cursor temp3
select temp3
m.Tqty=temp3.TQty
m.TSqmt=temp3.TSqmt
**************************

***********required for relation after calculation to display in report****
SELECT Po_no,Ol_no,Design,Colour,Quality,szcode,sum(Sqmt) Sqmt,Sum(Qty) Qty,breadth,length,po_dt,bcode,notes,fringes,comment,silkpr,spcl_inst,estdt;
FROM  temprepview;
Group by Design; 
Into Cursor Temprelation

**********************************************************************
**Yrcalc RMK si not possible becoz we are grouping design 20/5/2020 we changed Select statment not to overpass 255 fields in joins	
*SELECT j.*,k.Qty, k.breadth, k.length, k.po_dt,k.sqmt,k.bcode,k.colour,k.notes,k.fringes,k.comment,k.silkpr,k.po_no as orderno,k.spcl_inst,k.ol_no as carpetno 
SELECT j.*, k.po_dt,k.bcode,k.colour,k.notes,k.sqmt,k.spcl_inst,k.fringes,k.comment,k.silkpr,k.po_no as orderno;
FROM  yrcalc j,  Temprelation k; 
Where j.design=k.design .and. j.basecolour=k.Colour .and. j.quality=k.quality .and. j.szcode=k.szcode .and. !empty(j.date) .and. LEN(alltrim(j.Design))=LEN(alltrim(k.Design));
Into Cursor yrcalc1  Nofilter

************Yarn Store comparision***********************************
Private count1,count2,count3,count4,count5,count6,count7,count8,count9,m.quality,m.colour,m.sqmyarn,m.po_no,m.slno,m.ply,m.loop,m.rod,m.sqmt,m.recordcnt,m.avgconsm,;
		m.design,m.basecolour,m.bcode,m.Tqty,m.Tsqmt,m.remark 
tvar=.T.
m.gtreqkg=0
Create cursor yrcalc2(QUALITY C(12),COLOUR C(10),SQMYARN N(5,2),SLNO N(2),PLY C(2),LOOP C(13),ROD C(2),SQMT N(6,2),AVGCONSM N(5,2),DESIGN C(20),BASECOLOUR C(10),SZCODE C(11),CAQUALITY C(12),REMARK C(20))

Select yrcalc1
Scan while (.not. eof())
m.sqmt=yrcalc1->sqmt
m.caquality=yrcalc1->quality
m.avgconsm=yrcalc1->Avgconsm
m.design=yrcalc1->Design
m.basecolour=yrcalc1->Basecolour
m.szcode=yrcalc1->szcode
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
***calculation of yrreqkgall yarn req. for 1 kg according size wise*********
select quality,colour,sqmyarn,slno,ply,loop,rod,sqmt,avgconsm,design,basecolour,szcode,caquality,sqmt*sqmyarn as yrreqkgall,recno() as rec1,remark;
From yrcalc2;
into cursor yrcalc3

**********sum on slno,quality,colour of different sizes*****
select slno,quality,colour,ply,loop,rod,sqmt,design,basecolour,szcode,caquality,sum(yrreqkgall) yrreqkgall,rec1,remark;
From yrcalc3;
Group by slno,quality,colour,ply;
into cursor yrcalc4

*we calculate individual yarnrequred for same color with all values than sum in the next query
Select distin i.slno,j.po_no,i.quality,i.colour,j.sqmt,i.ply,i.loop,i.rod,i.yrreqkgall,i.design,i.basecolour,j.szcode,i.caquality,j.bcode,;
		j.Ol_no,j.Qty,j.breadth,j.length,j.po_dt,j.notes,j.fringes,j.comment,j.silkpr,j.po_no as orderno,j.ol_no as carpetno,spcl_inst,i.rec1,i.remark;  
From yrcalc4 i;
Left Join Temprelation j;
ON i.design=j.design;
order by i.rec1;
Into cursor yrcalc5

SELECT yrcalc5
SET COLOR TO
If RECNO()>RECCOUNT()
	WAIT WINDOW"Either Colour Chart is NOT Defined/ Colour Chart DATE is Empty / Buyer Order NOT Entered for above Design!" NOWAIT
	  Select temprepview  
	   Do Case
		 Case m.PrnStat="V"
			Report form rordform-emtyet.frx PREVIEW WINDOW wReport 
			DEACTIVATE WINDOW wReport 
   		 Case m.PrnStat="P"
			Report form rordform-emtyet.frx to printer prompt noconsole
 	   Endcase
Else
  Do Case
	Case m.PrnStat="V" 
		Report form rordformlnget.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P" 	
		Report form rordformlnget.frx to printer prompt noconsole
  Endcase
Endif
RETURN
**************

