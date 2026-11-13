**Updating Rcode from DgnCode into Cadesign
*C)*Updating 2 Files 
Close all
USE casupordmerg2 IN 0
USE casupord IN 0
Select casupordmerg2 && values come FROM this table 
Scan
Update casupord;
Set delclose=.T.;
Where casupordmerg2.ol_no=casupord.ol_no
Endscan
************************************************
Select * from casupord where delclose=.T.
brow

*Set wev_last_d=Casupord.wev_last_dt,billonln=casupord.billonln
*Set cutsupplier=Casupord.cutsupplier,wshsupplier=casupord.wshsupplier