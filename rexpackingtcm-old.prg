* PACKING LIST  ALL report 3/3/2021 [Before revised] for taking quality/specl_inst/remarks from tranpack.scx as per Chomphel
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
SELECT p.carpetno, d.Code,d.Desc as DgnDesc,d.Matcomp,d.designno; 
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
SELECT p.BCODE,INVNO, BALENO,CARPETNO, SLNO, PO_NO, OL_NO, p.DESIGN, COLOUR, SZCODE, FIELDCODE , p.QUALITY,d.code as DgnName,d.desc as DgnCode,d.Matcomp,p.Diamtr,p.Cubmtr,p.codesc,p.silkpr,d.designno,p.rate,p.amt,;
SHIPBRTH,SHIPLNGTH, iif(SL_NO='NORMAL',' ',SL_NO) As SpecialMark, SQMT, BALEWT,Remark,Comment,p.SizeCode1,Subbuyer,Buyerno,Alltrim(STR(SHIPBRTH))+' x '+Alltrim(STR(SHIPLNGTH)) As Size,spcl_inst;
FROM Packtran p,CaDesign d;
Where p.Design=d.code .and. p.Quality=d.Quality;
Into Cursor pack1

SELECT BCODE,INVNO, BALENO,p.CARPETNO, SLNO, PO_NO, OL_NO, p.DESIGN, SZCODE,p.COLOUR,FIELDCODE ,p.QUALITY,DgnName,DgnCode,d.DgnDesc,p.CoDesc,d.QltyDesc,d.designno,p.rate,p.amt,;
SHIPBRTH,SHIPLNGTH,SpecialMark, Round(SQMT,2) as sqmt, BALEWT,Remark,Comment,SizeCode1,Subbuyer,Buyerno,Size,p.Diamtr,d.Matcomp,p.Cubmtr,p.silkpr,spcl_inst;
FROM pack1 p, jn3 d;
Where p.carpetno=d.carpetno;
ORDER BY SLNO;
Into Cursor temp1

***for tcm standard breadth, length we have take removing Shipbrth,shiplngth SHIPBRTH,SHIPLNGTH,SpecialMark, Round(SQMT,2) as sqmt,
SELECT BCODE,INVNO, BALENO,CARPETNO, SLNO, PO_NO, OL_NO, DESIGN, COLOUR,t.SZCODE,FIELDCODE ,QUALITY,DgnName,DgnCode,DgnDesc,CoDesc,QltyDesc,designno,rate,amt,;
BALEWT,Remark,Comment,Subbuyer,Buyerno,Size,Diamtr,Matcomp,Cubmtr,c.br_feet,c.br_inch,c.ln_feet,c.ln_inch,c.sqmt,silkpr,spcl_inst;
FROM temp1 t,casize c;
Where alltrim(t.szcode)=alltrim(c.szcode);
ORDER BY SLNO;
Into Cursor temprepview

Select temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="F" .and. m.chk1=0
		Report form expackingTcmN.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="F" .and. m.chk1=0
		Report form expackingTcmN.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.Option="F" .and. m.chk1=1
		Report form expackingTcmN1.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="F" .and. m.chk1=1
		Report form expackingTcmN.frx  to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BALENO,CARPETNO,DgnDesc,CoDesc,Size,SQMT,SpecialMark,QltyDesc,Buyerno,DgnCode,SizeCode1,SUBBUYER,PO_NO,designno,rate,amt,comment
			Messagebox("Packing List Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Otherwise		
		Messagebox("Invalid choice, make correct Choice!!")
Endcase
Endif
SET ANSI OFF
Return


