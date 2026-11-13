do test

close all
use casupord
repl all delclose with .f.
use casupord
repl all delclose with .f.
close all

Select b.*,s.carpetno,s.supplier;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where  b.cstatus<>'Exported' .AND. s.Cutpaid=.T. .and. s.iwhPaid=.T. .and. s.PaidStatus=.T.;
into table stk5

Select ol_no;
From stk5;
into table delstk

*Updating 2 files
Close all
USE Cabuyord IN 0
USE  delstk IN 0
select delstk && values come FROM this table 
scan
Update Cabuyord;
Set delclose=.T.;
Where Cabuyord.ol_no=delstk.ol_no
endscan
USE IN Cabuyord
USE IN delstk
***********************

*Updating 2 files
Close all
USE Casupord IN 0
USE  delstk IN 0
select delstk && values come FROM this table 
scan
Update Casupord;
Set delclose=.T.;
Where Casupord.ol_no=delstk.ol_no
endscan
USE IN Casupord
USE IN delstk
***********************

Select * from delstk
Select * from cabuyord where delclose=.T.
Select * from Casupord where delclose=.T.
do test
Dele from cabuyord where delclose=.T.
Dele from Casupord where delclose=.T.

Select * from cabuyord where delclose=.T.
Select * from Casupord where delclose=.T.
close all
use cabuyord
pack
brow
use casupord
pack
brow
close all
