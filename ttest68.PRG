SELECT *;
FROM Stkcarpet s;
WHERE .NOT. EXISTS (SELECT * FROM Caqlty c;
					WHERE c.Code=s.Quality)
					
SELECT *;
FROM Stkcarpet s;
WHERE .NOT. EXISTS (SELECT * FROM CaDesign c;
					WHERE c.Code=s.Design)