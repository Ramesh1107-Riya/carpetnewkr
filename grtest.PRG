
*ThisForm.Caption="Order Not Distributed to Supplier"
SELECT *;
FROM CaDesign2;
WHERE .NOT. EXISTS (SELECT * FROM CaDesign;
					WHERE CaDesign.code=CaDesign2.code);
into table cadesign3.dbf
