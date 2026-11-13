Set Ansi on
If(!empty(m.Packno))
	SELECT s.CARPETNO,b.DESIGN,b.QUALITY,b.SZCODE,b.NOTES,b.Packno;
	FROM  Cabuyord b;
	Inner Join Casupord s;
	On b.ol_no=s.ol_no;
	WHERE !empty(fdate) .and. Packno=m.Packno;
	UNION ALL;
	SELECT CARPETNO,DESIGN,QUALITY,SZCODE,SUBSTR(NOTES,1,40) AS NOTES,Packno;
	FROM  Stkcarpet;
	WHERE Packno=m.Packno;		
	Into cursor buy1

	SELECT b.CARPETNO,b.DESIGN,r.Desc,b.NOTES,b.QUALITY,b.SZCODE,b.Packno,r.rcode;
	From buy1 b,Cadesign r;
	Where b.Design=r.Code .and. b.Quality=r.Quality;
	Into Cursor buy2

	SELECT b.CARPETNO,b.DESIGN,b.Desc,b.NOTES,b.QUALITY,b.SZCODE,b.Packno,c.code,c.ratenpr,c.ratedollar,c.party;
	From buy2 b;
	Left Join buyrate c;
	ON b.rcode=c.Code ;
	Into Cursor buy3
Else 
	Messagebox("Packing No. Can Not Be Empty, Enter Correct Packing!!")
ENDIF

SELECT buy3
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form Packdgnr.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form Packdgnr.frx to printer prompt noconsole
Endcase
Endif

