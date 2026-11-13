*Updating 2 files

*Updating 2 files

Close all
USE Cabuyord IN 0
USE Caqlty IN 0
select Caqlty && values come FROM this table 
scan
update Cabuyord ;
set qltyusd= Caqlty.qltyusd ;
Where Cabuyord.Quality=Caqlty.Code
endscan
USE IN Cabuyord
USE IN Caqlty
***********************
Select Distinct Quality,qltyusd From Cabuyord where qltyusd>0 Order by Quality