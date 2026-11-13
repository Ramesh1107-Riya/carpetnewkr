
*ThisForm.Caption="Order Not Distributed to Supplier"
SELECT *;
FROM CaColour2;
WHERE .NOT. EXISTS (SELECT * FROM CaColour;
					WHERE CaColour.code=CaColour2.code);
into table CaColour3.dbf
