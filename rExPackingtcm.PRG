* PACKING LIST  ALL report 
SET TALK OFF
SET CENTURY ON
SET DATE TO BRITISH
SET SAFE OFF
SET ANSI ON
*OPEN DATABASE CARPET

Select *;
From expackingnp;
where Alltrim(invno)=Alltrim(m.invno);
Into cursor packdtl

Dimension packdata (1,32)
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

*2) Getting Design from DgnDesc for packing list [DgnDesc<->Desc1 for TCM 6/1/2019]
SELECT p.carpetno, d.Code,d.Desc as DgnDesc,d.Matcomp,d.code as designno; 
FROM temp1 p, CaDesign d;
Where p.Design=d.code;
Into Cursor Dgn1 

*3) Getting Carpet Quality from Desc for packing list
SELECT p.carpetno, p.Quality,d.Desc; 
FROM temp1 p, Caqlty d;
Where p.Quality=d.code; 
Into cursor Qlty1

*4) Joining Tables 1&2, 1&2 with 3, 1&2&3 with 4
SELECT  t.carpetno,t.DESIGN,d.DgnDesc,d.Matcomp,t.COLOUR,t.QUALITY,d.designno;
FROM temp1 t , Dgn1 d;
Where t.carpetno=d.carpetno;
Into Cursor jn1

SELECT  t.carpetno,t.DESIGN,t.DgnDesc,t.Matcomp,t.COLOUR,t.QUALITY,q.Desc as QltyDesc,t.designno;
FROM jn1 t , Qlty1 q;
Where t.carpetno=q.carpetno;
Into Cursor jn3
**************************************
***Design has Quality,
SELECT p.BCODE,INVNO, BALENO,CARPETNO, SLNO, PO_NO, OL_NO, p.DESIGN, COLOUR, FIELDCODE , p.QUALITY,d.code as DgnName,d.desc as DgnCode,d.Matcomp,p.Diamtr,p.Cubmtr,p.codesc,;
SHIPBRTH,SHIPLNGTH, iif(SL_NO='NORMAL',' ',SL_NO) As SpecialMark, SQMT, BALEWT,Remark,Comment,p.SizeCode1,Subbuyer,Buyerno,Alltrim(STR(SHIPBRTH))+' x '+Alltrim(STR(SHIPLNGTH)) As Size,;
p.br_feet,p.br_inch,p.ln_feet,p.ln_inch,p.sqft;
FROM Packtran p,CaDesign d;
Where p.Design=d.code .and. p.Quality=d.Quality;
Into Cursor pack1

*For Kamal Rug
SELECT BCODE,INVNO, BALENO,p.CARPETNO, SLNO, PO_NO, OL_NO, p.DESIGN,p.COLOUR,FIELDCODE ,p.QUALITY,DgnName,DgnCode,d.DgnDesc,p.CoDesc,d.QltyDesc,;
SHIPBRTH,SHIPLNGTH,SpecialMark, Round(SQMT,2) as sqmt, BALEWT,Remark,Comment,SizeCode1,Subbuyer,Buyerno,Size,p.Diamtr,d.Matcomp,p.Cubmtr,;
p.br_feet,p.br_inch,p.ln_feet,p.ln_inch,p.sqft;
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
	Case m.PrnStat="V" .and. m.Option="E" .and. m.chk1=0
		Report form expackingTcmN.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="E" .and. m.chk1=0
		Report form expackingTcmN.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.Option="E" .and. m.chk1=1
		Report form expackingTcmN1.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="E" .and. m.chk1=1
		Report form expackingTcmN.frx  to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="F" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BALENO,CARPETNO,DgnDesc,CoDesc,Size,SQMT,SpecialMark,QltyDesc,Buyerno,DgnCode,SizeCode1,SUBBUYER,PO_NO,designno,rate,amt
			Messagebox("Packing List Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Otherwise		
		Messagebox("Invalid choice, make correct Choice!!")
Endcase
Endif
SET ANSI OFF
Return


