*Updating 2 files

*Updating 2 files

Close all
USE wistock3 IN 0
USE wistock IN 0
select wistock && values come FROM this table 
scan
update wistock3;
set wistock3.Desc=wistock.Desc,wistock3.customer=wistock.customer,wistock3.opendate=wistock.opendate;
Where wistock3.quality=wistock.quality .and. wistock3.colour=wistock.colour
endscan
USE IN wistock3
USE IN wistock 
***********************
Select * from wistock3