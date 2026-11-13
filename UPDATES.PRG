Close all
USE cabuy6 IN 0
USE cabuyord IN 0
select cabuy6 && values come FROM this table 
scan
update cabuyord ;
set scode= cabuy6.scode ;
Where cabuyord.ol_no=cabuy6.ol_no
endscan
USE IN cabuy6
USE IN cabuyord
***********************
Select ol_no,bcode,scode,spcl_inst from cabuyord

Close all
USE cabuy6 IN 0
USE cabuyord IN 0
select cabuy6 && values come FROM this table 
scan
update cabuyord ;
set Washtype= cabuy6.Washtype;
Where cabuyord.ol_no=cabuy6.ol_no
endscan
USE IN cabuy6
USE IN cabuyord
***********************
Select washtype,ol_no,bcode,scode,spcl_inst from cabuyord where washtype='MTRF'