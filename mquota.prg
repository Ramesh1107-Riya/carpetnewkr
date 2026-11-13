do while .t.
set cent on
set date to brit

SET PROCEDURE TO GRTools
 *Error Trapping Procedure
 ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()
mrecord="T"
msdate=date()
medate=date()
prnstat="V"	
mcomp=spac(20)

open database inv share
set color to 
USE supname   IN 7  ORDER TAG SNAME  ALIAS SUPPLIER SHARE
acti wind Report1

@.8,22 to 3,55;
pattern 1;
pen 1,8;
style "16";
color rgb(0,0,255,255,225,0)

@1,25 say "Monthly Quota Report";
font "Times New Roman",14;
style "BT";
color rgb(0,0,255,,,,)

set color to ,GR+/RB+
@4,5 say 'Supplier Name 'font "System",9
*@4,30 get mcomp size 1,25.5 font "Arial",9 style "B"
sele supplier
if !empty(sname)
define popup wty from 4,55 to 15,80 in window Report1  scroll prompt field sname;
FONT 'Arial', 9 STYLE 'B' Title "S U P P L I E R    N A M E"
acti popup wty 
mcomp=sname
set colo to
@4,30 get mcomp size 1,25.5 font "Arial",10 style "B"
deact popup
endif

*sele a
@6,5 say 'From Date 'font "System",9
@6,30 get msdate size 1,10.5 font "Arial",10 style "B"
@8,5 say 'To Date 'font "System",9
@8,30 get medate size 1,10.5 font "Arial",10 style "B"
@12,5 say 'Type any letter in Supplier Name -> Individual Report'  font "Arial",10 
@14,5 say 'Leave Blank Supplier Name -> Supplierwise Report'  font "Arial",10 

store spac(6) to opt
@18,30 get opt;
pict "@*H \<View;\<Print;E\<Xit";
Size 2,8;
font "Airal",10;
style "B"
read

do case
  case opt="EXit"
		deac wind Report1
		close all
		exit
****Exit point of program******

case opt="View"
	do repmake  	
case opt="Print"
	prnstat="P"	
	do repmake
endcase
enddo

procedure repmake
do case
	case empty(mcomp)
		do alltype
	case !empty(mcomp)
		do repind
endcase
retu

procedure repind
set exclu on
SELECT a.date,a.month, a.rname, a.yqlty, sum(a.ywt) yarnwt;
 FROM inv!wissue a;
 where alltrim(upper(a.rname))=alltrim(upper(mcomp));
 GROUP BY a.rname,a.month,a.yqlty;
 Order BY a.date;
 having a.date between msdate .and. medate;
 INTO table twissue

SELECT m.dt,m.month,m.sname,m.yqlty,sum(m.ynetwt) ynetwt;
 FROM inv!mquota m;
 where alltrim(upper(m.sname))=alltrim(upper(mcomp));
 GROUP BY m.sname,m.month,m.yqlty;
 ORDER BY m.dt;
 having dt between msdate .and. medate;
into table tmquota
close all

sele a
use twissue 
*index on month+yqlty to twis
sele b
use c:\invent\shardat\mquotat
zap
appen from tmquota 
*index on month+yqlty to tquot
sele a
do while .not. eof()
sele b
scan for b->month=a->month .and. b->yqlty=a->yqlty 
		repl b->yarnwt with a->yarnwt
endscan
sele a
if .not. eof()
	skip
else
	exit
endif
enddo

set excl off
****check empty**
SET PROCEDURE TO GRTools
sele b
GO TOP
IF RECNO() > RECCOUNT()      && i.e. End of File !
  deac wind Report1	
  DO CloseFile
  DO ShowMess WITH "Quota"+mcomp+"Record Not Found!"
  RETURN
ENDIF
IF mrecord="F"
	loop
else 
	do reptprg
endif
retu

procedure alltype
SELECT a.date,a.month, a.rname, a.yqlty, sum(a.ywt) yarnwt;
 FROM inv!wissue a;
 GROUP BY a.rname,a.month,a.yqlty;
 Order BY a.date;
 having a.date between msdate .and. medate;
 INTO table twissue

SELECT m.dt,m.month,m.sname,m.yqlty,sum(m.ynetwt) ynetwt;
 FROM inv!mquota m;
 GROUP BY m.sname,m.month,m.yqlty;
 ORDER BY m.dt;
 having dt between msdate .and. medate;
into table tmquota
close all

sele a
use twissue 
index on rname+month+yqlty to twis
sele b
use c:\invent\shardat\mquotat
zap
appen from tmquota 
index on sname+month+yqlty to tquot
sele a
do while .not. eof()
sele b
scan for b->sname=a->rname .and. b->month=a->month .and. b->yqlty=a->yqlty 
		repl b->yarnwt with a->yarnwt
endscan
sele a
if .not. eof()
	skip
else
	exit
endif
enddo

close database
SET PROCEDURE TO GRTools
use c:\invent\shardat\mquotat.dbf
GO TOP
IF RECNO() > RECCOUNT()      && i.e. End of File !
  deac wind Report1	
  DO CloseFile
  DO ShowMess WITH "All Party Quota Record Not Found!"
  RETURN
ENDIF
IF mrecord="F"
	loop
else 
	do reptprg
endif
retu

proc reptprg
deac wind Report1
close all
set date to brit
set cent off
do case
  case prnstat="P" 
	report form mquotat.frx to printer prompt noconsole 
  case prnstat="V"
	report form mquotat.frx to console preview
endcase
prnstat="V"
close all
retu

