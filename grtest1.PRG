
*ThisForm.Caption="Order Not Distributed to Supplier"
SELECT *;
FROM Casize2;
WHERE .NOT. EXISTS (SELECT * FROM Casize;
					WHERE CaSize.Szcode=CaSize2.Szcode);
into table Casize3.dbf
