*Updating 2 files
Close all
USE cabuy5 IN 0
USE cabuyord IN 0
select cabuy5 && values come FROM this table 
scan
update cabuyord ;
set scode= cabuy5.scode ;
Where cabuyord.ol_no=cabuy5.ol_no
endscan
USE IN cabuy5
USE IN cabuyord
***********************
*Select ol_no,bcode,scode,spcl_inst from cabuyord

Close all
USE cabuy5 IN 0
USE cabuyord IN 0
select cabuy5 && values come FROM this table 
scan
update cabuyord ;
set spcl_inst= cabuy5.spcl_inst;
Where cabuyord.ol_no=cabuy5.ol_no
endscan
USE IN cabuy5
USE IN cabuyord
***********************
Close all
USE cabuy5 IN 0
USE cabuyord IN 0
select cabuy5 && values come FROM this table 
scan
update cabuyord ;
set washtype= cabuy5.washtype;
Where cabuyord.ol_no=cabuy5.ol_no
endscan
USE IN cabuy5
USE IN cabuyord
***********************
Select ol_no,Design,Quality,sqmt,bcode,scode,spcl_inst,cstatus,washtype;
from cabuyord;
Where cstatus<>'Exported' 
**********************************************************************************

*******stkcarpet*****************************************************************
*Updating 2 files
Close all
USE stk5 IN 0
USE stkcarpet IN 0
select stk5 && values come FROM this table 
scan
update stkcarpet ;
set scode= stk5.scode ;
Where stkcarpet.ol_no=stk5.ol_no
endscan
USE IN stk5
USE IN stkcarpet
***********************
*Select ol_no,bcode,scode,spcl_inst from stkcarpet

Close all
USE stk5 IN 0
USE stkcarpet IN 0
select stk5 && values come FROM this table 
scan
update stkcarpet ;
set spcl_inst= stk5.spcl_inst;
Where stkcarpet.ol_no=stk5.ol_no
endscan
USE IN stk5
USE IN stkcarpet
***********************
Close all
USE stk5 IN 0
USE stkcarpet IN 0
select stk5 && values come FROM this table 
scan
update stkcarpet ;
set washtype= stk5.washtype;
Where stkcarpet.ol_no=stk5.ol_no
endscan
USE IN stk5
USE IN stkcarpet
***********************
Select ol_no,Design,Quality,sqmt,bcode,scode,spcl_inst,cstatus,washtype;
from stkcarpet;
Where cstatus<>'Exported' 

