*do while .t.
SET PROCEDURE TO GRTools
* Error Trapping Procedure
 ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()
 
set date to brit
set cent on
set safe off
mrecord="T"
prnstat="V"	

set color to
acti wind Report1

@.8,20 to 3,56;
pattern 1;
pen 1,8;
style "16";
color rgb(0,0,255,255,225,0)

set color to
@1,23 say "Supplier White Yarn Opening";
font "Times New Roman",14;
style "BT";
color rgb(0,0,255,,,,)

store spac(6) to opt
@20,50 get opt;
pict "@*H \<View;\<Print;E\<Xit";
Size 2,8;
font "Airal",12;
style "B"
read

do case
case opt="EXit"
		deac wind report1
		close all
		exit
****Exit point of program******
case opt="View"
		do reptmake 
case opt="Print"
		prnstat="P"	
		do reptmake
endcase
*enddo

*** Extract Wool Stock Position
Set Excl on
Procedure reptmake
SELECT *;
 FROM inv!supyop;
 INTO TABLE c:\invent\shardat\supsyopt.dbf 
use
set excl off 

SET PROCEDURE TO GRTools 
use c:\invent\shardat\supsyopt
* Checkings
GO TOP
IF RECNO() > RECCOUNT()      && i.e. End of File !
  deac wind Report1	
  DO CloseFile
  DO ShowMess WITH "Party Ledger::"+msname+" Record Not Found!"
  RETURN
ENDIF
IF mrecord="F"
	loop
else 
	do reptprg
endif
retu

proc reptprg
deac wind report1
close all
set date to brit
set cent off
do case
  case prnstat="P" 
	report form supyop.frx to printer prompt noconsole 
  case prnstat="V" 
	report form supyop.frx to console preview
endcase
prnstat="V"
retu