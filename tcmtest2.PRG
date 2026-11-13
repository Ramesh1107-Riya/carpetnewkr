SELECT s.ol_no,s.lthweav,s.lthweav,s.finsqmt;
FROM Casupord s;
WHERE .NOT. EXISTS (SELECT p.ol_no FROM Packtran p;
					WHERE p.ol_no=s.Ol_no)

