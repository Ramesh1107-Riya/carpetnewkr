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
Select Distinct Code,qltyusd From Caqlty where qltyusd>0 order by code

****check if works with 2 files, previously it has been used
UPDATE Carpet!CaWeaver ;
SET CaWeaver.Sgroup=Casupplier.Sgroup