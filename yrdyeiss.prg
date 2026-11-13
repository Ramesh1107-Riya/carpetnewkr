do while .t.
set date to brit
set safe off
set cent on
mrecord="T"
msdate=date()
medate=date()
prnstat="V"	
reptype="D"
mcomp=spac(20)
SET PROCEDURE TO GRTools
* Error Trapping Procedure
 ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()
 
set color to 
USE dyeparty   IN 12  ORDER TAG pname     ALIAS dparty
acti wind Report1



@.8,22 to 3,55;
pattern 1;
pen 1,8;
style "16";
color rgb(0,0,255,255,225,0)

@1,25 say "Yarn Issued Dyeing Report";
font "Times New Roman",14;
style "BT";
color rgb(0,0,255,,,,)

@4,5 say 'Dyeing Party Name 'font "System",9
*@4,30 get mcomp size 1,25.5 font "Arial",9 style "B"
set color to ,GR+/RB+
sele dparty
if !empty(pname)
define popup wty from 3,55 to 15,75 in wind Report1 scroll prompt field pname;
 FONT 'Arial', 9 STYLE 'B' Title "D Y E    P A R T Y  LIST "
acti popup wty 
mcomp=pname
set colo to
@4,30 get mcomp size 1,25.5 font "Arial",10 style "B"
deact popup wty
endif

@6,5 say 'From Date 'font "System",9
@6,30 get msdate size 1,10.5 font "Arial",10 style "B"
@8,5 say 'To Date 'font "System",9
@8,30 get medate size 1,10.5 font "Arial",10 style "B"
@10,5 say 'Wool Itemwise-Summary (S)'font "System",9
@10,30 get reptype size 1,1.5 font "Arial",10 style "B";
valid reptype='S' .or. reptype='s' .or. reptype='D' .or. reptype='d' 
@12,5 say 'Type any letter in Dyeing Party Name -> Individual Report'  font "Arial",10 
@14,5 say 'Leave Blank Dyeing Party Name -> Dye Partywise  Report'  font "Arial",10 
@16,5 say 'Blank Company Name + "S" - Itemwise Summary Report' font "Arial",9 

store spac(6) to opt
@20,30 get opt;
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
	case reptype='s' .or. reptype='S'
		do sumryrep
	case empty(mcomp)
		do alltype
	case !empty(mcomp)
		do repind
endcase
retu

procedure repind
set exclu on
SELECT y.*;
 FROM ydying y;
 where alltrim(upper(pname))=alltrim(upper(mcomp));
 ORDER BY ddt;
 having ddt between msdate .and. medate;
 INTO TABLE c:\invent\shardat\dyetemp.dbf
use
set exclu off
SET PROCEDURE TO GRTools 
use c:\invent\shardat\dyetemp.dbf
* Checkings
GO TOP
IF RECNO() > RECCOUNT()      && i.e. End of File !
  deac wind Report1	
  DO CloseFile
  DO ShowMess WITH "Yarn Issue to Dye Party: "+mcomp+", Record Not Found!"
  RETURN
ENDIF
IF mrecord="F"
	loop
else 
	do reptprg
endif
retu

procedure alltype
set exclu on
SELECT y.*;
 FROM ydying y;
 ORDER BY ddt;
 having ddt between msdate .and. medate;
 INTO TABLE c:\invent\shardat\dyetemp.dbf
 use
 set exclu off
SET PROCEDURE TO GRTools 
use c:\invent\shardat\dyetemp.dbf
* Checkings
GO TOP
IF RECNO() > RECCOUNT()      && i.e. End of File !
  deac wind Report1	
  DO CloseFile
  DO ShowMess WITH "Yarn Dye All Party Detail, Record Not Found!"
  RETURN
ENDIF
IF mrecord="F"
	loop
else 
	do reptprg
endif
retu

procedure sumryrep
SELECT y.pname,y.yqlty,sum(netwt);
 FROM ydying y;
 ORDER BY y.pname,y.yqlty;
 group by y.pname,y.yqlty;
 having ddt between msdate .and. medate;
 INTO TABLE c:\invent\shardat\dyetemp1.dbf
close database
SET PROCEDURE TO GRTools 
use c:\invent\shardat\dyetemp1.dbf
* Checkings
GO TOP
IF RECNO() > RECCOUNT()      && i.e. End of File !
  deac wind Report1	
  DO CloseFile
  DO ShowMess WITH "All Party Dye Summary, Record Not Found!"
  RETURN
ENDIF
IF mrecord="F"
	loop
else 
	do rept2
endif
retu

proc reptprg
deac wind Report1
close all
set date to brit
set cent off
do case
  case prnstat="P" 
	report form dyrep.frx to printer prompt noconsole 
  case prnstat="V"
	report form dyrep.frx to console preview
endcase
prnstat="V"
close all
retu

proc rept2
deac wind Report1
close all
set date to brit
set cent off
do case
  case prnstat="P" 
	report form dyrep1.frx to printer prompt noconsole 
  case prnstat="V"
	report form dyrep1.frx to console preview
endcase
prnstat="V"
close all
retu

