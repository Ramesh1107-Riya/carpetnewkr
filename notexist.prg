*Colour in Cacolour2 not in Cacolour
SELECT *;
FROM CaColour2;
WHERE .NOT. EXISTS (SELECT * FROM CaColour;
					WHERE CaColour.code=CaColour2.code);
into table CaColour3.dbf

***************************
SELECT *;
FROM Wiqlty2;
WHERE .NOT. EXISTS (SELECT * FROM Wiqlty;
					WHERE Wiqlty.Quality=Wiqlty2.Quality);
into table Wiqlty3.dbf

****************************
SELECT s.ol_no,s.lthweav,s.lthweav,s.finsqmt;
FROM Casupord s;
WHERE .NOT. EXISTS (SELECT p.ol_no FROM Packtran p;
					WHERE p.ol_no=s.Ol_no)

