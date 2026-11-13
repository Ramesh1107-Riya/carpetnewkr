****************************
SELECT s.ol_no,s.weaver;
FROM Casupord s;
WHERE .NOT. EXISTS (SELECT p.ol_no FROM Cabuyord p;
					WHERE p.ol_no=s.Ol_no)
					
****************************
SELECT s.ol_no,s.design;
FROM Cabuyord s;
WHERE .NOT. EXISTS (SELECT p.ol_no FROM CaSupord2 p;
					WHERE p.ol_no=s.Ol_no)