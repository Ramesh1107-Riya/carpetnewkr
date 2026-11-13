set defa to c:\carpetnew
modi proj carpet
modi comm nptest16
DO c:\carpetnew\nptest16.prg
brow
use oldstk
close all
use oldstk
brow
brow for delclose=.T.
modi proj carpet
modi comm nptest16
DO c:\carpetnew\nptest16.prg
modi proj carpet
modi comm nptest16
modi comm nptest17
modi comm nptest16
modi comm nptest18
DO c:\carpetnew\nptest18.prg
use oldstk
brow
close all
use oldstk
brow
sele * from oldstk where delclose=.T.
close all
!copy oldstk.dbf oldstk1.dbf
close all!copy oldstk.dbf oldstk1.dbf
run copy oldstk.dbf oldstk1.dbf
sele * from oldstk into table oldstk1.dbf
brow
use oldstk
close all
use oldstk exclus
pack
brow
sele * from oldstk where delclose=.T.
delete all for delclose=.T.
close all
use oldstk exclus
delete all for delclose=.T.
pack
modi comm nptest16
modi comm nptest17
modi comm nptest18
DO c:\carpetnew\nptest18.prg
use oldstk exclus
close all
use oldstk exclus
delete all for delclose=.T.

delete all for delclose=.T.
pack
brow
select * from stkcarpet into table stkcarpet1
