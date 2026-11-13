*** Calculating Yarn% summation

Set Procedure to Catool
*Local m.design,m.quality,m.basecolour,m.washtype,m.Tqty,m.TSqmt
Local m.Tqty,m.TSqmt,m.Washtype
m.Tqty=0
m.TSqmt=0.0

Create cursor yrcalc2(QUALITY C(12),COLOUR C(10),SQMYARN N(5,2),SLNO C(2),PLY C(2),LOOP C(13),ROD C(2),AVGCONSM N(5,2),DESIGN C(20),BASECOLOUR C(10),CAQUALITY C(12),YRNPER N(5,2))

SELECT s.Issdt,s.Ol_no,s.Supplier,b.Design,b.Colour,b.Quality,b.szcode,b.Qty,Sum(b.Sqmt) as Tsqmt,Sum(b.Qty) as TQty,b.bcode,b.notes,b.comment,b.spcl_inst,b.po_no,b.po_dt,b.washtype;
FROM cabuyord b,casupord s;
Where b.ol_no=s.ol_no .and.  b.ol_no=m.ol_no; 
Into Cursor temp3

*Where b.ol_no=s.ol_no .and. b.ol_no=m.ol_no
*Where b.ol_no=s.ol_no .and. s.Issdt=m.Issdt .and. s.Supplier=alltrim(m.Supplier) .and. b.Design=m.Design .and. b.Colour=m.Colour .and. b.Quality=m.Quality .and. (b.cstatus='On-Loom' .or. b.cstatus='Distri');

select temp3
m.Tqty=temp3.TQty
m.TSqmt=temp3.TSqmt
m.washtype=temp3->washtype

Select i.*,j.Tsqmt;
From yrcalc i, temp3 j;
Where i.design=j.design .and. i.quality=j.quality .and. i.basecolour=j.colour;
Into cursor yrcalc1

Select yrcalc1
m.caquality=yrcalc1->quality
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
		count9='CONS'+right("00"+Alltrim(Str(count1)),2) 
		m.quality=&count4
		m.colour=&count2
		m.sqmyarn=&count3		
		m.slno=&count5		
		m.ply=&count6
		m.loop=&count7
		m.rod=&count8
		m.yrnper=&count9		
	if(empty(yrcalc1->&count2))
			loop
		else
		Insert into yrcalc2(quality,colour,sqmyarn,slno,ply,loop,rod,avgconsm,design,basecolour,caquality,yrnper);
					 Values(m.quality,m.colour,m.sqmyarn,m.slno,m.ply,m.loop,m.rod,m.avgconsm,m.design,m.basecolour,m.caquality,m.yrnper)
		endif
	Endfor
	Select yrcalc1
Endscan

Select int(val(alltrim(i.slno))) as slnoval,i.quality,i.colour,i.yrnper,i.sqmyarn as yrreqkg,i.ply,i.loop,i.rod,i.avgconsm,i.design,i.basecolour,i.caquality,j.spcl_inst,j.notes,j.po_no,j.po_dt,j.ol_no,j.szcode,j.supplier,j.issdt;		
From yrcalc2 i ;
Join Temp3 j;
On i.design=j.design .and. i.caquality=j.quality .and. i.basecolour=j.colour .and. j.washtype=m.washtype;
Into cursor yrcalc2A1

*Where j.ol_no=m.ol_no;

Select slnoval as slno,quality,colour,yrnper,yrreqkg,ply,loop,rod,avgconsm,design,basecolour,caquality,spcl_inst,notes,po_no,po_dt,ol_no,szcode,supplier,issdt,recno() as rec1;		
From yrcalc2A1;
Into cursor yrcalc2A2

*order by slnoval,ply desc 14/8/2023 changed recno

Select Distinc i.slno,i.quality,i.colour,i.yrnper,i.yrreqkg,i.ply,i.loop,i.rod,i.avgconsm,i.design,i.basecolour,i.caquality,i.spcl_inst,i.notes,i.po_no,i.po_dt,i.ol_no,i.szcode,i.supplier,i.issdt,iif(isnull(j.location)=.T.,'',j.location) as location,rec1;
From yrcalc2A2 i;
Left Outer Join Wistock j;
ON alltrim(i.quality)=alltrim(j.quality) .and. alltrim(i.colour)=alltrim(j.colour) .and. j.washtype=m.washtype;
order by rec1;
into cursor yrcalc2A3

Select Distinc i.slno,i.quality,i.colour,i.yrnper,i.yrreqkg,i.ply,i.loop,i.rod,i.avgconsm,i.design,i.basecolour,i.caquality,i.spcl_inst,i.notes,i.po_no,i.po_dt,i.ol_no,i.szcode,i.supplier,i.issdt,i.location,i.rec1,j.ytype;
From yrcalc2A3 i;
Left Outer Join Wiqlty j;
ON alltrim(i.quality)=alltrim(j.quality) ;
order by j.ytype;
into cursor yrcalc2A

*order by i.slno,i.ply desc

SELECT yrcalc2A
SET COLOR TO
If RECNO()>RECCOUNT()
	WAIT WINDOW"Either Colour Chart is Not Defined/ [Not Verified] - Date is empty in Yarn Chart for above Design!" NOWAIT
Else
  Do Case
	Case m.PrnStat="V" 
		Report form rordformper_s.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P" 
		Report form rordformper_s.frx to printer prompt noconsole
  Endcase
Endif
RETURN
**************

