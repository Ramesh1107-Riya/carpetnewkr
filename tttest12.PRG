SELECT s.ol_no,s.carpetno,s.fdate,s.lthweav,s.lthweav,s.finsqmt;
FROM Casupord s;
WHERE .NOT. EXISTS (SELECT p.ol_no FROM Cabuyord p;
					WHERE p.ol_no=s.Ol_no);
Into table nobuyord
