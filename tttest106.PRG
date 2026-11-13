*select s.* ;
*from cadesign d,stkcarpet s;
*d.code=s.code

*Colour in Cacolour2 not in Cacolour
*SELECT *;
*FROM CaColour2;
*WHERE .NOT. EXISTS (SELECT * FROM CaColour;
*					WHERE CaColour.code=CaColour2.code);
*into table CaColour3.dbf

SELECT s.design as code,s.quality,s.bcode,s.notes as desc,padr('Old Stk 4/12/2023',17) as dgndesc,s.datetime,entryby;
FROM Stkcarpet s;
WHERE .NOT. EXISTS(SELECT * FROM Cadesign d;
					WHERE d.code=s.design);
.and. s.cstatus<>'Exported';
Into table stk5

select distinct code,dgndesc,quality,bcode,desc,datetime,entryby;
from stk5;
Into table stk6

select * from cadesign
select disti code,dgndesc from stk6 into table stk7

close all
use cadesign
pack
appen from stk7