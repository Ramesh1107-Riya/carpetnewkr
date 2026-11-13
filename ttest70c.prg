Close all
USE Stkcarpet IN 0
USE Cabuyer IN 0
Select Cabuyer && values come FROM this table 
Scan
Update Stkcarpet;
Set washtype=Cabuyer.washtype;
Where Stkcarpet.bcode=Cabuyer.Bcode
endscan
Select Stkcarpet
brow
*repl all washtype with 'TTC'  FOR EMPTY(WASHTYPE)
