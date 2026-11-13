
*ThisForm.Caption="Order Not Distributed to Supplier"
SELECT *;
FROM Wiqlty2;
WHERE .NOT. EXISTS (SELECT * FROM Wiqlty;
					WHERE Wiqlty.Quality=Wiqlty2.Quality);
into table Wiqlty3.dbf
