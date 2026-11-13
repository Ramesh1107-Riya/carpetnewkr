
*Select i.*;
*From availtcm i;
*Inner Join wiqlty j;
*On i.quality=j.quality;

*Select i.*;
*From availtcm i;
*Inner Join wiqlty j;
*On i.qltygroup=j.qltygroup;

*Select i.*;
*From cacolour i;
*Inner Join availtcm j;
*On i.code=j.colour;

SELECT *;
FROM availtcm;
WHERE .NOT. EXISTS (SELECT * FROM wiqlty;
					WHERE availtcm.quality=wiqlty.quality);
					Into cursor qltynot1					
SELECT *;
FROM availtcm;
WHERE .NOT. EXISTS (SELECT * FROM wiqlty;
					WHERE availtcm.qltygroup=wiqlty.qltygroup);
					Into cursor qltygrpnot1								
SELECT *;
FROM availtcm;
WHERE .NOT. EXISTS (SELECT * FROM cacolour;
					WHERE availtcm.colour=cacolour.code);
										Into cursor colournot1
					
Select * from qltynot1
select * from qltygrpnot1
select * from colournot1
					
*select distinc quality from qltynot into table c:\carpetnew\avltcm\dqltynot
*select distinc qltygroup from qltygrpnot into table c:\carpetnew\avltcm\dqltygrpnot
*select distinc colour from colournot into table c:\carpetnew\avltcm\dcolournot