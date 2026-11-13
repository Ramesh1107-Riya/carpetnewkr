
*C)*Updating 2 Files 
Close all
USE Wistock3 IN 0
USE Wistock IN 0
Select Wistock3 && values come FROM this table 
Scan
Update Wistock;
Set Washtype=Wistock3.Washtype;
Where Wistock.quality=Wistock3.Quality .and. wistock.colour=wistock3.colour
Endscan
************************************************
Select wistock
brow

