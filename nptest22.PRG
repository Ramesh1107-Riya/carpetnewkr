*Multiple table 

SELECT  p.carpetno,c.desc as COLOUR, q.Desc as Quality ,d.DgnDesc as Design;
FROM Packtran p;
LEFT OUTER JOIN cadesign d;
	ON p.Design=d.code .and. p.Quality=d.Quality;
LEFT OUTER JOIN Caqlty q;
	on p.Quality=q.code;
LEFT OUTER JOIN cacolour c;
	on p.colour=c.code
WHERE Invno = m.invno;
ORDER BY p.Quality;
Into Cursor temp1