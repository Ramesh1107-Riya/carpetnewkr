Close all
USE Wistock IN 0
USE Cabuyer IN 0
Select Cabuyer && values come FROM this table 
Scan
Update Wistock;
Set washtype=Cabuyer.washtype;
Where Wistock.Customer=Cabuyer.Bcode
endscan
Select Wistock
brow
*repl all washtype with 'TTC'  FOR EMPTY(WASHTYPE)




