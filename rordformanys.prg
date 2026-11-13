** TESTING PROGRAM for Unlimited yarnchart report
*rordform.prg Finds records for particular Desing,Quality,Colour,Size,IssDate for limit of 26 colours 10/4/2018 review by Ramesh Basnet
*2 Version:-
	*a) Before Distribution
	*b) After Distribution

Local m.po_no
m.po_no='170001/001'
Set Date to Briti
Set Century on
SET ANSI ON
Private count1,count2,count3,count4,count5,count6,count7,count8,m.quality,m.colour,m.sqmyarn,m.po_no,m.slno,m.ply,m.loop,m.rod

SELECT Design,Colour,Quality,szcode,Qty,Sqmt,po_no;
FROM  Cabuyord ;
Where po_no=m.po_no;
Into Cursor temp1

Select i.*,j.Sqmt;
From yrcalc i, temp1 j;
Where i.Design=j.Design .and. i.baseColour=j.Colour .and. i.Quality=j.Quality .and. i.Szcode=j.Szcode;
Into cursor yrcalc1

*Where i.Design=j.Design .and. i.baseColour=j.Colour .and. i.Quality=j.Quality .and. i.Szcode=j.Szcode;

Create cursor yrcalc2(PO_NO C(18), QUALITY C(12), COLOUR C(10), SQMYARN N(5,2), SLNO N(3), PLY C(2),LOOP C(13), ROD C(2))
Select yrcalc1
m.po_no=yrcalc1->po_no
Scan while (.not. eof())
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
		if(empty(yrcalc1->&count2))
			loop
		else
			Insert into yrcalc2(po_no,quality,colour,sqmyarn,slno,ply,loop,rod) Values(m.po_no,m.quality,m.colour,m.sqmyarn,m.slno,m.ply,m.loop,m.rod)
		endif
	Endfor
	Select yrcalc1
Endscan

Select t.Design,t.Colour as basecolour,t.Quality as Caqlty,t.szcode,t.Qty,t.Sqmt,t.po_no,y.quality,y.colour,y.sqmyarn,y.slno,y.ply,y.loop,y.rod;
From Temp1 t;
Left Join yrcalc2 y;
ON t.po_no=y.po_no

Return

Select yrcalc3 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found!! Colour Chart is Not Defined for the above Design!")
Else
Do Case
	Case m.PrnStat="V"
		Report form rordformbuyt1.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form rordformbuyt1.frx to printer prompt noconsole
Endcase
Endif
RETURN