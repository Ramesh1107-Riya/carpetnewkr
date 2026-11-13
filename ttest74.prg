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

****Buyrate****
Close all
USE Buyrate IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update Buyrate;
Set quality=caqltyf1->quality;
Where Buyrate->quality=caqltyf1->code
endscan
Select Buyrate
brow

****Cadesign****
Close all
USE Cadesign IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update Cadesign;
Set quality=caqltyf1->quality;
Where Cadesign->quality=caqltyf1->code
endscan
Select Cadesign
brow

****cafield****
Close all
USE cafield IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update cafield;
Set quality=caqltyf1->quality;
Where cafield->quality=caqltyf1->code
endscan
Select cafield
brow

****Cawevdel****
Close all
USE Cawevdel IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update Cawevdel;
Set CODE=caqltyf1->quality;
Where Cawevdel->CODE=caqltyf1->code
endscan
Select Cawevdel
brow


****Graphord****
Close all
USE Graphord IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update Graphord;
Set Quality=caqltyf1->quality;
Where Graphord->quality=caqltyf1->code
endscan
Select Graphord
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

****Grregstr****
Close all
USE Grregstr IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update Grregstr;
Set Quality=caqltyf1->quality;
Where Grregstr->quality=caqltyf1->code
endscan
Select Grregstr
brow

****Packtran****
Close all
USE Packtran IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update Packtran;
Set Quality=caqltyf1->quality;
Where Packtran->quality=caqltyf1->code
endscan
Select Packtran
brow

****Stkcarpet****
Close all
USE Stkcarpet IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update Stkcarpet;
Set Quality=caqltyf1->quality;
Where Stkcarpet->quality=caqltyf1->code
endscan
Select Stkcarpet
brow

****yrcalc****
Close all
USE yrcalc IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update yrcalc;
Set Quality=caqltyf1->quality;
Where yrcalc->quality=caqltyf1->code
endscan
Select yrcalc
brow

****Buydeliday****
Close all
USE Buydeliday IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update Buydeliday;
Set Quality=caqltyf1->quality;
Where Buydeliday->quality=caqltyf1->code
endscan
Select Buydeliday
brow

****Invdata****
Close all
USE Invdata IN 0
USE caqltyf1 IN 0
Select caqltyf1 && values come FROM this table 
Scan
Update Invdata;
Set Quality=caqltyf1->quality;
Where Invdata->quality=caqltyf1->code
endscan
Select Invdata
brow

