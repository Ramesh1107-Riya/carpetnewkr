**Updating Rcode from DgnCode into Cadesign
*C)*Updating 2 Files 
Close all
USE casupord5 IN 0
USE casupord3 IN 0
Select casupord3 && values come FROM this table 
Scan
Update casupord5;
Set casupord5.wshsupplier=casupord3.wshsupplier;
Where casupord3.ol_no=casupord5.ol_no  .and. casupord5.cutissdt={^2021/04/13}
Endscan
************************************************
Select * from casupord5
brow

*Set wev_last_d=Casupord.wev_last_dt,billonln=casupord.billonln
*Set cutsupplier=Casupord.cutsupplier,wshsupplier=casupord.wshsupplier