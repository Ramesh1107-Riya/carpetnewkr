Close all
USE Cabuyord IN 0
USE TT65DEL IN 0
select TT65DEL && values come FROM this table 
scan
update Cabuyord ;
set Delclose=.T. ;
Where TT65DEL.ol_no=Cabuyord.ol_no 
endscan
USE IN Cabuyord
USE IN TT65DEL
***********************
Select a.Ol_no from Cabuyord a, TT65DEL b where a.ol_no=b.ol_no
Select * From TT65DEL
*
close all
Delete From Cabuyord Where Delclose=.T.
use Cabuyord
pack
use in Cabuyord
*
Select a.Ol_no from Cabuyord a, TT65DEL b where a.ol_no=b.ol_no
Select * From TT65DEL


