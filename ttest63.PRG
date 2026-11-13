**Updating Rcode from DgnCode into Cadesign
*C)*Updating 2 Files 
Close all
USE ttdel IN 0
USE casupord IN 0
Select ttdel && values come FROM this table 
Scan
Update casupord;
Set delclose=.T.;
Where ttdel.ol_no=casupord.ol_no
Endscan
***
Select * from casupord where delclose=.T.
Delete from casupord where delclose=.t.
close all
use casupord
pack
Select s.ol_no;
From ttdel t,casupord s;
where t.ol_no=s.ol_no

********************************************
Close all
USE ttdel IN 0
USE cabuyord IN 0
Select ttdel && values come FROM this table 
Scan
Update cabuyord;
Set delclose=.T.;
Where ttdel.ol_no=cabuyord.ol_no
Endscan
***
Select * from cabuyord where delclose=.T.
Delete from cabuyord where delclose=.t.
close all
use cabuyord
pack
Select s.ol_no;
From ttdel t,cabuyord s;
where t.ol_no=s.ol_no

********************************************
Close all
USE ttdel IN 0
USE packtran IN 0
Select ttdel && values come FROM this table 
Scan
Update packtran;
Set delclose=.T.;
Where ttdel.ol_no=packtran.ol_no
Endscan
***
Select * from packtran where delclose=.T.
Delete from packtran where delclose=.t.
close all
use packtran
pack
Select s.ol_no;
From ttdel t,packtran s;
where t.ol_no=s.ol_no


