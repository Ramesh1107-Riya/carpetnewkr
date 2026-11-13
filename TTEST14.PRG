close all
*Select * From cabuyordtk into table cabuyordtkcopy
*Update cabuyordtk;
*Set delclose=.F.
*C)***Update Packtran.dbf cstatus (Look for Carpet No.)
Close all
USE cabuyord IN 0
USE del2019 IN 0
SELECT del2019 && values come FROM this table 
SCAN
Update cabuyord;
Set delclose=.T.; 
Where cabuyord.ol_no=del2019.ol_no 
ENDSCAN
Use IN cabuyord 
USE IN del2019


Dele From cabuyord;
Where delclose=.T.
close all

use cabuyord exclus
pack

