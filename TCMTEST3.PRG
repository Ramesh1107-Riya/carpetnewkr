**25/01/2019 tcmtest.prg, tcmtest3.prg
*Excel Packing List of TCM Inserted directly to packtran.dbf by Ramesh Basnet, on request to Mr.Chomphel excel list

SELECT i.*;
FROM pack1 i;
WHERE .NOT. EXISTS (SELECT carpetno FROM packtran p;
					WHERE p.carpetno=i.carpetno);
Into table packin


SELECT i.*;
FROM pack1 i,packtran j;
Where i.carpetno=j.carpetno;
Into Table packfound