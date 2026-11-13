SET DELETED ON
SET TALK OFF
SET SAFE OFF

Create cursor yrcalc2(QUALITY C(12),COLOUR C(10),SQMYARN N(5,2),SLNO N(2),PLY C(2),LOOP C(13),ROD C(2),AVGCONSM N(5,2),DESIGN C(20),BASECOLOUR C(10),CAQUALITY C(12),YRNPER N(5,2))

SELECT s.Issdt,s.Ol_no,s.Supplier,b.Design,b.Colour,b.Quality,b.szcode,b.Qty,b.Sqmt,b.bcode,b.notes,b.comment,b.spcl_inst,b.po_no,b.po_dt;
FROM cabuyord b,casupord s;
Where b.ol_no=s.ol_no .and. Issdt = m.Issdt .and. Supplier = m.Supplier .and. b.Design = m.Design .and. b.Colour = m.Colour .and. b.Quality = m.Quality .and. (b.cstatus = 'On-Loom' OR b.cstatus = 'Distri') ;
Into Cursor temp2

Select temp2
Dimension cardolno(37,3) && array is declared row=37,col=3
Store '' to cardolno && initialize array with '', by default .F.
Copy to Array Cardolno FIELDS Ol_no,szcode,sqmt


SELECT Issdt,Ol_no,Supplier,Design,Colour,Quality,szcode,sum(Qty) as TQty,Sum(Sqmt) as Tsqmt,bcode,notes,comment,spcl_inst,po_no,po_dt;
FROM temp2;
Group by Design,quality,colour;
Order by Design,quality,colour;
Into Cursor temp3

*Issdt = m.Issdt .and. Supplier = m.Supplier .and. b.Design = m.Design .and. b.Colour = m.Colour .and. b.Quality = m.Quality .and. (b.cstatus = 'On-Loom' OR b.cstatus = 'Distri') ;
Local m.design,m.quality,m.basecolour,m.caq1uality,m.avgconsm,m.Tqty,m.TSqmt
m.Tqty=0
m.TSqmt=0.0

Select temp3
m.Tqty=temp3.TQty
m.TSqmt=temp3.TSqmt

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

Select i.slno as slnoval,i.quality,i.colour,i.yrnper,i.sqmyarn as yrreqkg,i.ply,i.loop,i.rod,i.avgconsm,i.design,i.basecolour,i.caquality,j.spcl_inst,j.notes,j.po_no,j.po_dt,j.ol_no,j.szcode,j.supplier,j.issdt;		
From yrcalc2 i ;
Join Temp3 j;
On i.design=j.design .and. i.caquality=j.quality .and. i.basecolour=j.colour;
Into cursor yrcalc2A1

Select slnoval as slno,quality,colour,yrnper,yrreqkg,ply,loop,rod,avgconsm,design,basecolour,caquality,spcl_inst,notes,po_no,po_dt,ol_no,szcode,supplier,issdt;		
From yrcalc2A1;
order by slnoval,ply desc;
Into cursor yrcalc2A 

SELECT yrcalc2A
SET COLOR TO
If RECNO()>RECCOUNT()
	WAIT WINDOW"Either Colour Chart is Not Defined/ [Not Verified] - Date is empty in Yarn Chart for above Design!" NOWAIT
Else
  Do Case
	Case m.PrnStat="V" 
		Report form rordformlngyarn2.frx PREVIEW WINDOW wReport 
		*Report form rordformlngyarntcm.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P" 
		Report form rordformlngyarn2.frx to printer prompt noconsole
		*Report form rordformlngyarntcm.frx to printer prompt noconsole
  Endcase
Endif
RETURN
*******************************