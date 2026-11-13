*Collect all Quality and Colour from Wirecv.dbf,Wissue.dbf,Wiretun.dbf that is not in opening Wistock.dbf
*Append all these record to Wistock.dbf temporarily and generate Stock Balance report
*CREATE CURSOR NOTWISTOCK (QUALITY C(8),COLOUR C(10),QUANTITY N(10,3))
CREATE CURSOR NOTWISTOCK (QUALITY C(8),COLOUR C(10),OPENBAL N(10,3),;
						RECQTY N(11,3),RETNQTY N(11,3),ISSQTY N(11,3),RECQTYM N(11,3),RETNQTYM N(11,3),ISSQTYM N(11,3))
Do WiRecd
Do Wiss
Do Wiretu

Procedure WiRecd
Open Database Carpet
SELECT Quality,Colour,Sum(Quantity) RECQTY;
FROM Carpet!Wirecv r;
WHERE .NOT. EXISTS(SELECT Quality,Colour;
					FROM Wistock s;
					WHERE s.quality=r.quality .and. s.Colour=r.Colour);
GROUP BY Quality,Colour;
ORDER BY Quality,Colour;
INTO CURSOR RcdNotStk 
Select NOTWISTOCK
APPEND  FROM DBF ('RcdNotStk')
RETURN

Procedure Wiss
Open Database Carpet
SELECT Quality,Colour,Sum(Quantity) ISSQTY;
FROM Carpet!Wiissue k;
WHERE .NOT. EXISTS(SELECT Quality,Colour;
					FROM Wistock s;
					WHERE s.quality=k.quality .and. s.Colour=k.Colour);
GROUP BY Quality,Colour;
ORDER BY Quality,Colour;
INTO CURSOR IssNotStk
Select NOTWISTOCK
APPEND FROM DBF ('IssNotStk')
RETURN

Procedure Wiretu
Open Database Carpet
SELECT Quality,Colour,Sum(Quantity) Quantity;
FROM Carpet!Wireturn j;
WHERE .NOT. EXISTS(SELECT Quality,Colour;
					FROM Wistock s;
					WHERE s.quality=j.quality .and. s.Colour=j.Colour);
GROUP BY Quality,Colour;
ORDER BY Quality,Colour;
INTO CURSOR ReturNotStk
Select NOTWISTOCK
APPEND FROM DBF ('ReturNotStk')

SELECT REPSTOCK
APPEND FROM DBF ('NotWistock')
Brow
Return
*Do WistoNot  && Quality and Colour Not in Wistock We Insert-Append From Wiissue,Wirecv,Wireturn Calling prg

CREATE CURSOR REPSTOCK (QUALITY C(8),COLOUR C(10),OPENBAL N(10,3),;
						RECQTY N(11,3),RETNQTY N(11,3),ISSQTY N(11,3),RECQTYM N(11,3),RETNQTYM N(11,3),ISSQTYM N(11,3))
