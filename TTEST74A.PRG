**UPDATING SUPPLIER NAME IN ALL *.DBF
****Casupord****
Close all
USE Cabuyord IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update Cabuyord;
Set quality=caqltyf1->quality;
Where Cabuyord->quality=caqltyf1->code
endscan
Select Cabuyord
brow

****Grmaster****
Close all
USE Grmaster IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update Grmaster;
Set Quality=caqltyf1->quality;
Where Grmaster->quality=caqltyf1->code
endscan
Select Grmaster
brow

