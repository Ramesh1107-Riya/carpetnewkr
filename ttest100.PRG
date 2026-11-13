**Updating Rcode from DgnCode into Cadesign
*C)*Updating 2 Files 

Close all
do test
USE CASUP5 IN 0
USE CASUPORD IN 0
Select CASUP5 && values come FROM this table 
Scan
Update CASUPORD;
Set WEV_LAST_D=Casup5.Wev_Last_D;
Where casupord.ol_no=casupord.ol_no .and. empty(casupord.wev_last_d)
Endscan
************************************************
Select casupord
brow
