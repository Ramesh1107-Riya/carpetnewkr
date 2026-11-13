
*ThisForm.Caption="Order Not Distributed to Supplier"
SELECT *;
FROM CaSupplr2;
WHERE .NOT. EXISTS (SELECT * FROM CaSupplr;
					WHERE CaSupplr.code=CaSupplr2.code);
into table Casupplr3.dbf
