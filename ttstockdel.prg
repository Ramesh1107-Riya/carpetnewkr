*Updating 2 files
Close all
USE Cabuyord IN 0
USE pACK1 IN 0
select pACK1 && values come FROM this table 
scan
Update Cabuyord;
Set cstatus='RcdWash';
Where Cabuyord.ol_no=Pack1.ol_no
endscan
USE IN Cabuyord
USE IN Pack1
***********************

