SELECT BCODE, CSTATUS,SUM(SQMT) SQMT;
FROM Cabuyord ;
Group by bcode,cstatus;
Where cstatus<>'Exported'