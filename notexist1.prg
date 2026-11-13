
SELECT *;
FROM Wiqlty3;
WHERE .NOT. EXISTS (SELECT * FROM Wiqlty;
					WHERE Wiqlty.Quality=Wiqlty3.Quality);
into table Wiqlty4.dbf

****************************
select * from wiqlty4