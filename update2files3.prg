Close all
USE PACKTRAN IN 0
USE Casize IN 0
select Casize && values come FROM this table 
scan
update PACKTRAN ;
set sl_no=Casize.category;
Where PACKTRAN.Szcode=Casize.szcode
endscan

USE IN PACKTRAN
USE IN Casize
***********************
Select ol_no,design,quality,sl_no from PACKTRAN

