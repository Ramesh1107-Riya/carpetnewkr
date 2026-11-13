SELECT p.QUALITY,p.COLOUR,p.NETWT as OPQTY,d.NETWT as PURQTY,q.QTY as WSHIQTY ,c.QTY as WSHRQTY,i.QUANTITY  as ISSDYQTY ,j.QUANTITY as ISSUPQTY,K.QUANTITY as RETSUPQTY;
FROM YRNOP p;  											&& *1) White Yarn Opening
LEFT OUTER JOIN YRNRECVD d;								&& *2) White Yarn Purchase
	ON p.Colour=d.Colour .and. p.Quality=d.Quality;
LEFT OUTER JOIN YRNWSHISS q;							&& *3) White Yarn Issue to Washing
	ON p.Colour=q.Colour .and. p.Quality=q.Quality;
LEFT OUTER JOIN YRNWSHRCD c;							&& *4) White Yarn Received From Washing
	ON p.Colour=c.Colour .and. p.Quality=c.Quality;
LEFT OUTER JOIN YRNISSDY i;							    && *5) White Yarn Issue to Dyeing	
	ON p.Colour=i.Colour .and. p.Quality=i.Quality;
LEFT OUTER JOIN WIISSUE j;								&& *6) White Yarn Issue to Supplier where Wash='N'
	ON p.Colour=j.Colour .and. p.Quality=j.Quality;
LEFT OUTER JOIN WIRETURN k;								&& *7) White Yarn Return From Supplier where Wash='N'
	ON p.Colour=k.Colour .and. p.Quality=k.Quality;
WHERE recdt<msdate;
GROUP BY p.QUALITY,p.COLOUR;
ORDER BY p.QUALITY,p.COLOUR
