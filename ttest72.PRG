*Note:- Please remove __ri__inssert_grsuptran()/ __ri__update_Grsuptran()  before updating Grsuptran.dbf
****Grsuptran****
Close all
USE Grsuptran IN 0
USE ttsupl IN 0
Select ttsupl && values come FROM this table 
Scan
Update Grsuptran;
Set Supplier=ttsupl->acode;
Where Grsuptran->scompany=ttsupl->code
endscan
Select Grsuptran
brow








