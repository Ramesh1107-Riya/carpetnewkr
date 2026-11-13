Close all
USE Cabuyord IN 0
USE Cabuyordtt1 IN 0
select Cabuyordtt1 && values come FROM this table 
scan
update Cabuyord ;
set cstatus=Cabuyordtt1.cstatus ;
Where Cabuyordtt1.ol_no=Cabuyord.ol_no .and.  Cabuyord.cstatus<>'Exported'
endscan
USE IN Cabuyord
USE IN Cabuyordtt1
***********************
Select a.Ol_no,a.cstatus from Cabuyord a,Cabuyordtt1 b where a.ol_no=b.ol_no
select * From Cabuyordtt1