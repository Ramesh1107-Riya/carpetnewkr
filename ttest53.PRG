Close all
USE TTJWrate2 IN 0
USE Buyrate IN 0
select TTJWrate2 && values come FROM this table 
scan
update Buyrate ;
set party= TTJWrate2.Party ;
Where Code=TTJWrate2.code
endscan
USE IN TTJWrate2
USE IN Buyrate
***********************
Select * from Yrnorder