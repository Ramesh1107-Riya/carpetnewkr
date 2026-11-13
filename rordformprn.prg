*rordform.prg Finds records for particular Desing,Quality,Colour,Avgconsm 
***************************************************************************
Create cursor yrcalc2(QUALITY C(12),COLOUR C(10),SQMYARN N(5,2),SLNO N(2),PLY C(2),LOOP C(13),ROD C(2),AVGCONSM N(5,2),DESIGN C(20),BASECOLOUR C(10),CAQUALITY C(12),YRNPER N(5,2))

Select *;
From yrcalc;
Where design=m.design .and. quality=m.quality .and. basecolour=m.basecolour .and. !empty(date) .and. avgconsm=m.avgconsm;
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

Select i.slno as slnoval,i.quality,i.colour,i.yrnper,i.sqmyarn as yrreqkg,i.ply,i.loop,i.rod,i.avgconsm,i.design,i.basecolour,i.caquality;		
From yrcalc2 i ;
Into cursor yrcalc2A1

Select slnoval as slno,quality,colour,yrnper,yrreqkg,ply,loop,rod,avgconsm,design,basecolour,caquality;		
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
		Report form rordformlngprn.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P" 
		Report form rordformlngprn.frx to printer prompt noconsole
  Endcase
Endif
RETURN
**************

