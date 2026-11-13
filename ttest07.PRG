close all
**ok 18/7/2019*** carpet
*select b.*;
*From Casupord a,Casupord5 b;
*Where a.ol_no=b.ol_no .and. empty(a.carpetno) .and. !empty(b.carpetno);
*into table casupordfin

Update CaSupord;
Set delclose=.F. 

Close all
USE Casupord IN 0
USE casupordfin IN 0
SELECT casupordfin && values come FROM this table 
SCAN
Update CaSupord;
Set delclose=.T.; 
Where CaSupord.ol_no=casupordfin.ol_no 
ENDSCAN
Use IN CaSupord 
USE IN casupordfin
*************************************************
close all

Select * from CaSupord;
Where delclose=.T.

*use CaSupord exclus
*pack

