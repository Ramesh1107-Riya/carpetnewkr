*Updating 2 files
Close all
USE delord IN 0
USE cabuyord IN 0
select delord && values come FROM this table 
scan
update cabuyord ;
set delclose=.T.;
Where cabuyord.ol_no=delord.ol_no
endscan
USE IN delord
USE IN cabuyord
use cabuyord excl
dele for delclose=.T.
pack

***************************************
Close all
USE delord IN 0
USE casupord IN 0
select delord && values come FROM this table 
scan
update casupord ;
set delclose=.T.;
Where casupord.ol_no=delord.ol_no
endscan
close all
use casupord exclus
dele for delclose=.T.
pack
