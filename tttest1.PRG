	SELECT w.DATE,w.BILLNO,w.PARTY,w.QUALITY,w.COLOUR,w.QUANTITY,w.Rate,w.Amt;
	FROM Witrnord w;
	WHERE .NOT. EXISTS (SELECT * FROM WIRECV r;
					WHERE w.billno=r.billno .and. w.QUALITY=r.Quality .and. w.COLOUR=r.Colour);
	ORDER BY Date Desc;
					
*RATE,t.AMT
