do test

close all
use Cabuyord
pack
brow
repl all delclose with .f.
use Casupord
pack
brow
repl all delclose with .f.
pack
use stkcarpet
brow
close all

*Where  b.cstatus<>'Exported' .AND. PO_DT=<{^2022/12/31}s.Cutpaid=.T. .and. s.iwhPaid=.T. .and. s.PaidStatus=.T.;

Select b.*,s.carpetno,s.supplier;
From Cabuyord b;
Join Casupord s;
On b.ol_no=s.ol_no;
Where  b.cstatus<>'Exported' .AND. PO_DT=<{^2023/05/31};
.and. b.bcode<>'24' .and. b.bcode<>'36' .and. b.bcode<>'65' .and. b.bcode<>'86' .and. b.bcode<>'121' .and. b.code<>'192' .and. b.code<>'216';
.and. b.bcode<>'197' .and. b.bcode<>'212' .and. b.code<>'200';
into table stk5
 
Select ol_no,carpetno,cstatus,po_no;
From stk5;
into table delstk

*Updating 2 files
Close all
USE Cabuyord IN 0
USE  delstk IN 0
brow
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

do test
Dele from cabuyord where delclose=.T.
Dele from Casupord where delclose=.T.
close all
use cabuyord
pack
use casupord
pack
close all
use stk5
dele for empty(carpetno)
pack
use stkcarpet
appen from stk5

close all

use Cabuyord
brow
use Casupord
brow
use stkcarpet
brow
use stk5
brow
close all
