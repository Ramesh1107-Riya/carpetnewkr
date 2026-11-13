* BARCODE
SET TALK OFF
SET CENTURY ON
SET DATE TO BRITISH
SET SAFE OFF
SET ANSI ON
OPEN DATABASE CARPET
*Local m.invno,m.PrnStat,m.carpetno
*m.carpetno=''
*m.PrnStat="V"
*m.invno='G04/2017'
*where Alltrim(invno)=Alltrim(m.invno) .and. carpetno=m.carpetno;

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
SHIPBRTH,SHIPLNGTH,SpecialMark,(shipbrth*shiplngth)/10000 as SQMT1, BALEWT,Remark,Comment,SizeCode1,Subbuyer,Buyerno,Size,p.Diamtr,d.Matcomp,p.Cubmtr;
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
	Case m.PrnStat="V"
		Label form label2.lbx to console preview in screen
	Case m.PrnStat="P"
		Label form label2.lbx to printer prompt noconsole
Endcase
Endif
Return