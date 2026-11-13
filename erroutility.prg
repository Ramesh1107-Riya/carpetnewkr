*erroutility
Select *;
from errorlog;
Into Cursor errortemp

ZOOM WINDOW wReport MAX 
Select errortemp
Report form errorlog.frx PREVIEW WINDOW wReport 

return
