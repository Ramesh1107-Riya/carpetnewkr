Local m.invno
m.invno='G17/2017'

Select invno;
From Expackingnp;
where invno=m.invno ;
into cursor expack

select expack
If RECNO()>RECCOUNT()
	Wait Window "Enter Packing Header First to make Invoice Entry, Enter Correct Invoice No.,...Press Arrow Button to Exit" NOWAIT
	*ThisForm.invno1.Setfocus()
ELSE
**Continue Invoice Entry
	SELECT QUALITY;
	FROM Packtran;
	WHERE Invno=m.invno;
	GROUP BY Quality;
	ORDER BY Quality;
	Into Cursor Pack1x
	
	SELECT Count(*) as Qltycount;
	FROM Pack1x;
	Into Cursor Pack1y
	
	Select Pack1y
	bROW

Endif

