close all
do while .t.
set date to brit
set safe off
set cent on
SET PROCEDURE TO GRTools
* Error Trapping Procedure
 ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()
mrecord="T"
msdate=date()
medate=date()
prnstat="V"	
mcomp=spac(20)

set color to 
USE supname   IN 12  ORDER TAG sname     ALIAS supplier
acti wind Report1

@.8,22 to 3,55;
pattern 1;
pen 1,8;
style "16";
color rgb(0,0,255,255,225,0)

@1,25 say "White Yarn Receipt Report";
font "Times New Roman",14;
style "BT";
color rgb(0,0,255,,,,)

set color to ,GR+/RB+
@4,5 say 'Supplier Name 'font "System",9
*@4,30 get mcomp size 1,25.5 font "Arial",9 style "B"
sele supplier
if !empty(sname)
define popup wty from 3,55 to 15,80 in wind Report1 scroll prompt field sname;
FONT 'Arial', 9 STYLE 'B' Title "S U P P L I E R    N A M E"
acti popup wty 
mcomp=sname
set colo to
@4,30 get mcomp size 1,25.5 font "Arial",10 style "B"
deact popup wty
endif


@6,5 say 'From Date 'font "System",9
@6,30 get msdate size 1,10.5 font "Arial",10 style "B"
@8,5 say 'To Date 'font "System",9
@8,30 get medate size 1,10.5 font "Arial",10 style "B"
@10,5 say 'Type any letter in Supplier Name -> Individual Report'  font "Arial",10 
@12,5 say 'Leave Blank Suplier Name -> Supplierwise  Report'  font "Arial",10 

store spac(6) to opt
@16,30 get opt;
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
SELECT *;
 FROM inv!yrecp;
 where alltrim(upper(sname))=alltrim(upper(mcomp));
 ORDER BY yrecp.rdt;
 having rdt between msdate .and. medate;
 INTO TABLE c:\invent\shardat\yrectem.dbf
use 
set exclu off
SET PROCEDURE TO GRTools 
use c:\invent\shardat\yrectem.dbf
* Checkings
GO TOP
IF RECNO() > RECCOUNT()      && i.e. End of File !
  deac wind Report1	
  DO CloseFile
  DO ShowMess WITH "Yarn Recived From:"+mcomp+", Record Not Found!"
  RETURN
ENDIF

IF mrecord="F"
	loop
else 
	do reptprg
endif
retu

procedure alltype
SELECT *;
 FROM inv!yrecp;
 ORDER BY yrecp.rdt;
 having rdt between msdate .and. medate;
 INTO TABLE c:\invent\shardat\yrectem.dbf
close database
SET PROCEDURE TO GRTools 
use c:\invent\shardat\yrectem.dbf
* Checkings
GO TOP
IF RECNO() > RECCOUNT()      && i.e. End of File !
  deac wind Report1	
  DO CloseFile
  DO ShowMess WITH "Yarn Recived From: All Party, Record Not Found!"
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
	report form yrecrep.frx to printer prompt noconsole 
  case prnstat="V"
	report form yrecrep.frx to console preview
endcase
prnstat="V"
close all
retu

