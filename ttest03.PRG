close all
Update Cabuyord;
Set delclose=.F.
*C)***Update Packtran.dbf cstatus (Look for Carpet No.)
Close all
USE Cabuyord IN 0
USE oldel IN 0
SELECT oldel && values come FROM this table 
SCAN
Update Cabuyord;
Set delclose=.T.; 
Where Cabuyord.ol_no=oldel.ol_no
ENDSCAN
Use IN Cabuyord 
USE IN oldel
****************************************************
close all

****************************************************

*C)***Update Packtran.dbf cstatus (Look for Carpet No.)

Update CaSupord;
Set delclose=.F. 
Close all
USE Casupord IN 0
USE oldel IN 0
SELECT oldel && values come FROM this table 
SCAN
Update CaSupord;
Set delclose=.T.; 
Where CaSupord.ol_no=oldel.ol_no 
ENDSCAN
Use IN CaSupord 
USE IN oldel
*************************************************

Select * from Cabuyord;
Where delclose=.T.

Select * from CaSupord;
Where delclose=.T.

Dele From Cabuyord;
Where delclose=.T.

Dele From CaSupord;
Where delclose=.T.
close all

*use CaSupord exclus
*pack

*use CaBuyord exclus
*pack
