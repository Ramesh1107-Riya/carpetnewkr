SELECT p.QUALITY,p.COLOUR,p.NETWT,d.NETWT,q.QTY,c.QTY,i.QUANTITY,j.QUANTITY,K.QUANTITY;
FROM YRNOP p;
LEFT OUTER JOIN YRNRECVD d;
	ON p.Colour=d.Colour .and. p.Quality=d.Quality;
LEFT OUTER JOIN YRNWSHISS q;
	ON p.Colour=q.Colour .and. p.Quality=q.Quality;
LEFT OUTER JOIN YRNWSHRCD c;
	ON p.Colour=c.Colour .and. p.Quality=c.Quality;
LEFT OUTER JOIN YRNISSDY i;
	ON p.Colour=i.Colour .and. p.Quality=i.Quality;
LEFT OUTER JOIN WIISSUE j;
	ON p.Colour=j.Colour .and. p.Quality=j.Quality;
LEFT OUTER JOIN WIRETURN k;
	ON p.Colour=k.Colour .and. p.Quality=k.Quality;

