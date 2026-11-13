Delete From Casupord s;
WHERE .NOT. EXISTS (SELECT p.ol_no FROM Cabuyord p;
					WHERE p.ol_no=s.Ol_no)
