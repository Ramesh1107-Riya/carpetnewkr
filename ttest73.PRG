Close all
USE Casupplr IN 0
USE Casup2 IN 0
Select Casup2 && values come FROM this table 
Scan
Update Casupplr;
Set Phone=Casup2->phone,address1=Casup2->Address1;
Where Casupplr->code=Casup2->code
endscan
Select Casupplr
brow








