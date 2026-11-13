SELECT *;
FROM Witrnord s;
WHERE .NOT. EXISTS (SELECT * FROM Witrnord3 c;
					WHERE c.Quality=s.Quality)
					
SELECT *;
FROM Wirecv s;
WHERE .NOT. EXISTS (SELECT * FROM Wirecv3 c;
					WHERE c.Quality=s.Quality)
					
SELECT *;
FROM Wireturn s;
WHERE .NOT. EXISTS (SELECT * FROM Wireturn3 c;
					WHERE c.Quality=s.Quality)
					
SELECT *;
FROM Wiissue s;
WHERE .NOT. EXISTS (SELECT * FROM Wiissue3 c;
					WHERE c.Quality=s.Quality)
					
SELECT *;
FROM Yrnissdy s;
WHERE .NOT. EXISTS (SELECT * FROM Yrnissdy3 c;
					WHERE c.Quality=s.Quality)