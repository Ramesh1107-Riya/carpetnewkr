close all

USE Casupord IN 0
USE Casupord3 IN 0
SELECT Casupord3 && values come FROM this table 
SCAN
Update CaSupord;
Set WEV_LAST_DT=CaSupord3.WEV_LAST_D; 
Where CaSupord.ol_no=Casupord3.ol_no 
ENDSCAN
Use IN CaSupord 
USE IN CaSupord3
*************************************************
CLOSE ALL

Select OL_NO,WEV_LAST_DT,FDATE;
from casupord ;
WHERE EMPTY(WEV_LAST_DT);
INTO CURSOR CASUPORD4





