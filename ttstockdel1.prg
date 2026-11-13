Select *;
From TTstock1;
Into Table TTstock3

SELECT t.design,t.carpetno;
FROM TTSTOCK T,STKCARPET S;
WHERE alltrim(T.CARPETNO)=alltrim(S.CARPETNO);
Into table ttstock2

*Updating 2 files
Close all
USE TTstock1 IN 0
USE TTstock2 IN 0
select Ttstock2 && values come FROM this table 
scan
Delete ;
From TTstock1 ;
Where TTstock1.Carpetno=TTstock2.carpetno
endscan
USE IN TTstock1
USE IN TTstock2
***********************
