**Updating Rcode from DgnCode into Cadesign
*C)*Updating 2 Files 
Close all
USE DgnCode IN 0
USE Cadesign IN 0
Select DgnCode && values come FROM this table 
Scan
Update Cadesign;
Set Rcode=DgnCode.Rcode;
Where Cadesign.Code=DgnCode.Code
Endscan
************************************************
Select Cadesign
brow

