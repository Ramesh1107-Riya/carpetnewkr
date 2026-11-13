*C)*Updating 2 Files 
*Close all
*USE wiissue IN 0
*USE design2 IN 0
*Select design2 && values come FROM this table 
*Scan
*Update wiissue;
*Set washtype=design2.washtype;
*Where wiissue.design=design2.design
*endscan
*Select wiissue
*brow


*******************************
set date to briti
SET DELETED ON
set procedure to abtool
* Screen Colour Setting
DO SetColour WITH ISCOLOR()





*******************************
Close all
USE witrnord IN 0
USE design2 IN 0
Select design2 && values come FROM this table 
Scan
Update witrnord;
Set washtype=design2.washtype;
Where witrnord.design=design2.design
endscan
Select witrnord
brow

*******************************
Close all
USE witrnord IN 0
USE design2 IN 0
Select design2 && values come FROM this table 
Scan
Update witrnord;
Set washtype=design2.washtype;
Where witrnord.design=design2.design
endscan
Select witrnord
brow








