* PACKING LIST  ALL report 
SET TALK OFF
SET CENTURY ON
SET DATE TO BRITISH
SET SAFE OFF
SET ANSI ON

******Multipel Tables Joins*******
SELECT  p.carpetno,c.desc as COLOUR, q.Desc as Quality ,d.DgnDesc as Design;
FROM Packtran p;
LEFT OUTER JOIN cadesign d;
	ON p.Design=d.code .and. p.Quality=d.Quality;
LEFT OUTER JOIN Caqlty q;
	on p.Quality=q.code;
LEFT OUTER JOIN cacolour c;
	on p.colour=c.code;
WHERE Invno = m.invno;
ORDER BY p.Quality;
Into Cursor temp1 
****************************
Select *;
From expackingnp;
where Alltrim(invno)=Alltrim(m.invno);
Into cursor packdtl

Dimension packdata (1,22)
Store ' ' to packdata
Select packdtl
copy to ARRAY packdata

**Union Stkcarpet and Cabuyord for szcode*********
Select p.ol_no,b.szcode;
From Packtran p,cabuyord b;
where p.ol_no=b.ol_no .and. invno=m.invno;
into cursor pabuy

Select p.ol_no,b.szcode;
From Packtran p,stkcarpet b;
where p.ol_no=b.ol_no .and. invno=m.invno;
into cursor pastk

Select ol_no,szcode;
From pabuy;
union all;
Select ol_no,szcode;
From pastk;
into cursor stkbuyord
*********end of ********************************
If m.option="D"
	Select P.carpetno,P.Baleno,p.subbuyer,P.Quality,P.Design,P.Colour,b.szcode,p.sqmt,int(val(p.baleno)) as bale;
	From Packtran P, stkbuyord b;
	Where  p.ol_no=b.ol_no .and. p.invno=m.invno;
	Order BY p.subbuyer,p.QUALITY,p.DESIGN,p.COLOUR;
	Into cursor packsm1

	Select carpetno,bale,Subbuyer,quality,design,colour,szcode,sqmt;
	From packsm1;
	order by subbuyer,QUALITY,DESIGN,COLOUR,bale,sqmt;
	Into Cursor tempack1
	********Join temp1 and tempack1 into tempack********to produce Quality desc,colour Desc, Design Desc
	Select i.bale,i.Subbuyer,j.quality,j.design,j.colour,i.szcode,i.sqmt;
	From tempack1 i, temp1 j;
	Where i.carpetno=j.carpetno;
	order by i.subbuyer,j.QUALITY,j.DESIGN,j.COLOUR,i.bale,i.sqmt;
	Into Cursor tempack
Else
	m.ption="S"
	Select P.carpetno,P.Baleno,p.subbuyer,P.Quality,P.Design,P.Colour,b.szcode,count(szcode) as nopcs,sum(p.sqmt) as sqmt;
	From Packtran P,stkbuyord b;
	where p.ol_no=b.ol_no .and. p.invno=m.invno;
	Order BY p.subbuyer,p.QUALITY,p.DESIGN,p.COLOUR;
	Group by subbuyer,p.quality,szcode,p.design,p.colour;
	Into Cursor tempack1
	********Join temp1 and tempack1 into tempack********to produce Quality desc,colour Desc, Design Desc
	Select i.subbuyer,j.Quality,j.Design,j.Colour,i.szcode,i.nopcs,i.sqmt;
	From tempack1 i, temp1 j;
	Where i.carpetno=j.carpetno;
	order by i.subbuyer,j.QUALITY,j.DESIGN,j.COLOUR,i.sqmt;
	Into Cursor tempack
Endif

Select tempack
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"  .and. m.Option="S" .and. m.chk1=0
		Report form packsmry.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"  .and. m.chk1=0
		Report form packsmry.frx to printer prompt noconsole
	
	Case m.PrnStat="V" .and. m.Option="D" .and. m.chk1=0
		Report form packdtl.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport

	Case  m.PrnStat="V" .and. m.Option="K" 
		EXPORT TO &exclfile TYPE XL5 FIELDS  Baleno,subbuyer,Quality,Design,Colour,szcode,nopcs,sqmt
			Messagebox("Packing List Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Otherwise		
		Messagebox("Invalid choice, make correct Choice!!")
Endcase
Endif
SET ANSI OFF
Return


