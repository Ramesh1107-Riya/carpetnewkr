****Grmaster.dbf*****************
Close all
USE Grmaster IN 0
USE design2 IN 0
Select design2 && values come FROM this table 
Scan
Update Grmaster;
Set washtype=design2.washtype;
Where Grmaster.design=design2.design
endscan
Select Grmaster
brow
repl all washtype with 'TTC'  FOR EMPTY(WASHTYPE)

****Grregstr.dbf*****************
Close all
USE Grregstr IN 0
USE design2 IN 0
Select design2 && values come FROM this table 
Scan
Update Grregstr;
Set washtype=design2.washtype;
Where Grregstr.design=design2.design
endscan
Select Grregstr
brow
repl all washtype with 'TTC'  FOR EMPTY(WASHTYPE)




