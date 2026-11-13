*do while .t.
set date to brit
set safe off
set cent on
SET PROCEDURE TO GRTools
* Error Trapping Procedure
 ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()
mrecord="T"
prnstat="V"	

acti wind Report1

@.8,20 to 3,56;
pattern 1;
pen 1,8;
style "16";
color rgb(0,0,255,255,225,0)

@1,23 say "White Yarn Store Opening";
font "Times New Roman",14;
style "BT";
color rgb(0,0,255,,,,)

store spac(6) to opt
@20,50 get opt;
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
		do reptmake	
case opt="Print"
	prnstat="P"	
		do reptmake	
endcase
*enddo


*** Extract Wool Stock Position
Procedure reptmake
set exclu on
SELECT *;
 FROM inv!yrecop;
 INTO TABLE c:\invent\shardat\yarnop.dbf
set excl off
close database

SET PROCEDURE TO GRTools 
use c:\invent\shardat\yarnop.dbf
* Checkings
GO TOP
IF RECNO() > RECCOUNT()      && i.e. End of File !
  deac wind Report1	
  DO CloseFile
  DO ShowMess WITH "White Yarn Store Opening, Record Not Found!"
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
	report form yarnop.frx to printer prompt noconsole 
  case prnstat="V" 
	report form yarnop.frx to console preview
endcase
prnstat="V"
close all
retu