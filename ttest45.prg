Select b.*,c.supplier;
From Cabuyord b,Casupord c;
Where b.ol_no=c.Ol_no .and. b.po_no='RAMESH'


Select *;
From Stkcarpet;
Where po_no='RAMESH'
*******************************************************

Delete;
From Cabuyord;
Where po_no='RAMESH'

Delete;
From Casupord;
Where ol_no='A003852' .OR. ol_no='300124' .OR. ol_no='302159'

Delete;
From Stkcarpet;
Where po_no='RAMESH'

*******************************************************

close all
use casupord exclu
pack
reind
use cabuyord exclus
pack 
reind
use stkcarpet exclus
pack 
reind