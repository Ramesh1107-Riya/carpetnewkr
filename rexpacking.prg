* PACKING LIST  ALL report 
SET TALK OFF
SET CENTURY ON
SET DATE TO BRITISH
SET SAFE OFF
SET ANSI ON
OPEN DATABASE CARPET

Select *;
From expackingnp;
where Alltrim(invno)=Alltrim(m.invno);
Into cursor packdtl

Dimension packdata (1,22)
Store ' ' to packdata
Select packdtl
copy to ARRAY packdata

*Making Packing List, Data Formatted for N.P. Rugs
*1) For Joining we are eliminating field for better performance
SELECT  p.carpetno,p.DESIGN, COLOUR, p.QUALITY;
FROM Packtran p,cadesign d;
Where p.Design=d.code .and. p.Quality=d.Quality;
HAving Invno = m.invno;
ORDER BY SLNO;
Into Cursor temp1

*2) Getting Design from DgnDesc for packing list
SELECT p.carpetno, d.Code,d.DgnDesc,d.Matcomp; 
FROM temp1 p, CaDesign d;
Where p.Design=d.code;
Into Cursor Dgn1 

*3) Getting Carpet Quality from Desc for packing list
SELECT p.carpetno, p.Quality,d.Desc; 
FROM temp1 p, Caqlty d;
Where p.Quality=d.code; 
Into cursor Qlty1

*4) Joining Tables 1&2, 1&2 with 3, 1&2&3 with 4
SELECT  t.carpetno,t.DESIGN,d.DgnDesc,d.Matcomp,t.COLOUR,t.QUALITY;
FROM temp1 t , Dgn1 d;
Where t.carpetno=d.carpetno;
Into Cursor jn1

SELECT  t.carpetno,t.DESIGN,t.DgnDesc,t.Matcomp,t.COLOUR,t.QUALITY,q.Desc as QltyDesc;
FROM jn1 t , Qlty1 q;
Where t.carpetno=q.carpetno;
Into Cursor jn3
**************************************
***Design has Quality,
SELECT p.BCODE,INVNO, BALENO,CARPETNO, SLNO, PO_NO, OL_NO, p.DESIGN, COLOUR, FIELDCODE , p.QUALITY,d.code as DgnName,d.desc DgnCode,d.Matcomp,p.Diamtr,p.Cubmtr,p.codesc,;
SHIPBRTH,SHIPLNGTH, iif(SL_NO='NORMAL',' ',SL_NO) As SpecialMark, SQMT, BALEWT,Remark,Comment,p.SizeCode1,Subbuyer,Buyerno,Alltrim(STR(SHIPBRTH))+' x '+Alltrim(STR(SHIPLNGTH)) As Size;
FROM Packtran p,CaDesign d;
Where p.Design=d.code .and. p.Quality=d.Quality;
Into Cursor pack1

SELECT BCODE,INVNO, BALENO,p.CARPETNO, SLNO, PO_NO, OL_NO, p.DESIGN, p.COLOUR, FIELDCODE ,p.QUALITY,DgnName,DgnCode,d.DgnDesc,p.CoDesc,d.QltyDesc,;
SHIPBRTH,SHIPLNGTH,SpecialMark, Round(SQMT,2) as sqmt, BALEWT,Remark,Comment,SizeCode1,Subbuyer,Buyerno,Size,p.Diamtr,d.Matcomp,p.Cubmtr;
FROM pack1 p, jn3 d;
Where p.carpetno=d.carpetno;
ORDER BY SLNO;
Into Cursor temprepview

Select temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="F" .and. m.chk1=0
		Report form expackingGR.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="F" .and. m.chk1=0
		Report form expackingGR.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.Option="F" .and. m.chk1=1
		Report form expackingGR1.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="F" .and. m.chk1=1
		Report form expackingGR1.frx to printer prompt noconsole

	Case m.PrnStat="V" .and. m.Option="S" .and. m.chk1=0
		Report form expackingUS.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="S" .and. m.chk1=0
		Report form expackingUS.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.Option="S" .and. m.chk1=1
		Report form expackingUS1.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="S" .and. m.chk1=1
		Report form expackingUS1.frx to printer prompt noconsole

	Case m.PrnStat="V" .and. m.Option="T" .and. m.chk1=0
		Report form expackingIT.frx  PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="T" .and. m.chk1=0
		Report form expackingIT.frx  to printer prompt noconsole
	Case m.PrnStat="V" .and. m.Option="T" .and. m.chk1=1
		Report form expackingIT1.frx  PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="T" .and. m.chk1=1
		Report form expackingIT1.frx  to printer prompt noconsole
		
	Case m.PrnStat="V" .and. m.Option="O" .and. m.chk1=0
		Report form expackingOT.frx  PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="O" .and. m.chk1=0
		Report form expackingOT.frx  to printer prompt noconsole
	Case m.PrnStat="V" .and. m.Option="O" .and. m.chk1=1
		Report form expackingOT1.frx  PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="O" .and. m.chk1=1
		Report form expackingOT1.frx  to printer prompt noconsole

	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BALENO,CARPETNO,DgnDesc,CoDesc,Size,SQMT,SpecialMark,QltyDesc,Buyerno,DgnCode,SizeCode1,SUBBUYER,PO_NO
			Messagebox("Packing List Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Otherwise		
		Messagebox("Invalid choice, make correct Choice!!")
Endcase
Endif
SET ANSI OFF
Return


