do test
Select * From cabuyord
Select * From casupord 
Select * From Stkcarpet

*Updating 2 files
Close all
USE Cabuyord IN 0
USE  del2023 IN 0
brow
select del2023 && values come FROM this table 
scan
Update Cabuyord;
Set delclose=.T.;
Where Cabuyord.ol_no=del2023.ol_no
endscan
USE IN Cabuyord
USE IN del2023
***********************

*Updating 2 files Casupord
Close all
USE Casupord IN 0
USE  del2023 IN 0
select del2023 && values come FROM this table 
scan
Update Casupord;
Set delclose=.T.;
Where Casupord.ol_no=del2023.ol_no
endscan
USE IN Casupord
USE IN del2023
***********************

*Updating 2 files in Stakcarpet
Close all
USE Stkcarpet IN 0
USE  del2023 IN 0
select del2023 && values come FROM this table 
scan
Update Stkcarpet;
Set delclose=.T.;
Where Stkcarpet.ol_no=del2023.ol_no
endscan
USE IN Stkcarpet
USE IN del2023
**************************************************************

do test
Dele from cabuyord where delclose=.T.
Dele from Casupord where delclose=.T.
Dele from Stkcarpet where delclose=.T.
close all
use cabuyord
pack
use casupord
pack
use stkcarpet
pack
close all

use Cabuyord
brow
use Casupord
brow
use stkcarpet
brow
use del2023
brow
close all
