set safe off
set talk off
** Keep the required Quality rest delete
***Deletting Quality from 
*1) Wiqlty
*2) Wistock && Dyed Yarn Stock
*3) Yrnop && Undyed Yarn Opening
** Wiqltydel.dbf has the quality

*****Delete all data in following*****
*1) witrnord
*2) yrnrecvd
*3) yrecp
*4) woolissu
*5) yrnissdy
*6) yrnrecvd
*7) wirecv
*8) wiissue
*9) wireturn
close all
use witrnord exclus
zap
use yrnrecvd exclus
zap
use yrecp exclus
zap
use woolissu exclu
zap
use yrnissdy exclus
zap
use yrnrecvd exclus
zap
use wirecv exclus
zap
use wiissue exclus
zap
use wireturn exclus
zap

***Deletting Quality from 
*1) Wiqlty
*__ri_update_wiqlty()
*__ri_delete_wiqlty()
*2) Wistock && Dyed Yarn Stock
*__ri_insert_wistock()
*__ri_update_wistock()
*3) Yrnop && Undyed Yarn Opening


do test

Close all
USE wiqltydel IN 0
USE yrnop IN 0
select wiqltydel && values come FROM this table 
scan
Update yrnop;
set Suplier='DEL';
Where yrnop.Quality=wiqltydel.Quality
endscan
close all
use yrnop exclus
DELETE FOR Suplier="DEL"
Pack
Brow
close all
********

Close all
USE wiqltydel IN 0
USE wistock IN 0
select wiqltydel && values come FROM this table 
scan
Update wistock;
set Location='DEL';
Where wistock.Quality=wiqltydel.Quality
endscan
close all
use wistock exclus
DELETE FOR LOCATION="DEL"
*DELETE FOR opendate<{^2025/01/01}
pack
Brow
close all

*****************
Close all
USE wiqltydel IN 0
USE wiqlty IN 0
select wiqltydel && values come FROM this table 
scan
Update Wiqlty;
set Option=.T.;
Where Wiqlty.Quality=Wiqltydel.Quality
endscan
close all
use wiqlty exclus
DELETE FOR option = .T.
pack
Brow
close all

******************

