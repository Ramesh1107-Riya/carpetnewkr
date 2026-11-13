Close all
USE stkjw IN 0
USE cabuyord IN 0
select stkjw && values come FROM this table 
scan
update cabuyord ;
set spcl_inst= stkjw.spcl_inst;
Where cabuyord.ol_no=stkjw.ol_no
endscan
USE IN stkjw
USE IN cabuyord
***********************
Close all
USE stkjw IN 0
USE cabuyord IN 0
select stkjw && values come FROM this table 
scan
update cabuyord ;
set scode= stkjw.scode;
Where cabuyord.ol_no=stkjw.ol_no
endscan
USE IN stkjw
USE IN cabuyord
***********************
Select ol_no,Design,Quality,sqmt,bcode,scode,spcl_inst,cstatus,washtype;
from cabuyord;
Where cstatus<>'Exported' 

