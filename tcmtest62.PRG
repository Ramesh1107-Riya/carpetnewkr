Select b.*,p.invno,p.expdt;
from cabuyord b,packtcm1 p;
where b.ol_no=p.ol_no;
Into table pack1

Select p.*,s.bthweav,s.lthweav,s.finsqmt,s.carpetno,p.breadth as shipbrth,p.length as shiplngth,p.sqmt as sqmt,datetime() as datetime;
from pack1 p,casupord s;
Where p.ol_no=s.ol_no;
into table pack2

Select  a.invno,a.ol_no,a.expdt,p.invno,p.ol_no,p.expdt;
from packtran a, pack1 p;
Where a.ol_no=p.ol_no;
into table packdup

select * from packdup

*Updating 2 files
Close all
USE Packtran IN 0
USE packdup IN 0
select packdup && values come FROM this table 
do while .not. eof()
update Packtran ;
set Packtran.delclose=.T.;
Where packtran.ol_no=packdup.ol_no_a
	Select packdup
	If .not. eof()
		skip
	Endif
enddo
USE IN Packtran
USE IN packdup
*****************************
use packtran
dele all for delclose=.T.
Pack
brow fields invno,ol_no for delclose=.T.

Select  a.invno,a.ol_no,a.expdt,p.invno,p.ol_no,p.expdt,a.delclose;
from packtran a, pack1 p;
Where a.ol_no=p.ol_no;
into table packdup

select * from packdup

close all
use packtran
*appen from pack2

repl all sqmt with (shipbrth*shiplngth)/10000
repl all sqmtord with (shipbrth*shiplngth)/10000
repl all lastatus with 'Exported' for empty(lastatus)

