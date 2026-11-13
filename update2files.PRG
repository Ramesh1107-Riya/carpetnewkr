*Updating 2 files

*Updating 2 files

Close all
USE YrnOrder IN 0
USE Yrnrecvd IN 0
select Yrnrecvd && values come FROM this table 
scan
update YrnOrder ;
set Rate= Yrnrecvd.Rate ;
Where YrnOrder.Rono=Yrnrecvd.Rono
endscan
USE IN YrnOrder
USE IN Yrnrecvd 
***********************
Select * from Yrnorder