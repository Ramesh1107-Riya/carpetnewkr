Select *;
From stk1;
Into Table TTstock3

SELECT t.carpetno;
FROM stk1 T,STKCARPET S;
WHERE alltrim(T.CARPETNO)=alltrim(S.CARPETNO);
Into table ttstock2

*Updating 2 files
Close all
USE Stkcarpet IN 0
USE TTstock2 IN 0
select Ttstock2 && values come FROM this table 
scan
Delete ;
From Stkcarpet ;
Where Stkcarpet.Carpetno=TTstock2.carpetno
endscan
USE IN Stkcarpet
USE IN TTstock2
***********************d
use ttstock2
brow
use stkcarpet excl
pack
close all