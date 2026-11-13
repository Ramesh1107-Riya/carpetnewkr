****************************
SELECT s.*;
FROM CaSupord6 s;
WHERE .NOT. EXISTS (SELECT p.ol_no FROM CaSupord p;
					WHERE p.ol_no=s.Ol_no);
Into table Casupordv
