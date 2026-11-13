SET DELETED ON
open database carpet 
*Procedure IndividualRep
CREATE SQL VIEW yrnexpt AS Select i.Date, i.Bill, i.Suplier, i.Quality, i.Netwt, i.Rcode;
FROM  yrsupop i;
WHERE i.suplier=m.suplier;
union all;
Select j.Issdt, j.Issno, j.Suplier, j.Quality, j.Ynwtles10, j.Rcode;
FROM woolissu j;
WHERE j.suplier=m.suplier;
union all;
Select k.Date, k.Recno, k.Suplier, k.Quality, k.Netwt, k.Rcode;
FROM  yrecp k;
WHERE k.suplier=m.suplier

SELECT *;
FROM carpet!yrnexpt;
WHERE date>=msdate .and. date<=medate;
ORDER BY quality,date;
INTO cursor yrexp

***************************************
CREATE CURSOR YRNEXPREP (DATE D(8), BILL C(8), RDT D(8), RBILL C(8), NAME C(15), YQLTY C(8), OPYWT N(12,3), RCDYWT N(12,3), ISSYWT N(12,3), REMARK C(3))
***********************************

Select yrexp
do while .not. eof()

SELECT YRNEXPREP    
appen blank

repl Name with yrexp->Suplier
repl Yqlty with yrexp->Quality,remark with yrexp->rcode

do case 
	case remark='Opn'
		repl opywt with yrexp->Netwt
    case remark='Rec'
		 repl rdt with yrexp->date, rbill with yrexp->bill, rcdywt with yrexp->Netwt
	case remark='Iss'
		repl date with yrexp->date, bill with yrexp->bill, issywt with yrexp->Netwt
endcase
sele yrexp
IF .NOT. EOF()
   SKIP
ENDIF
enddo
*************************************************************************************************************

SELECT YRNEXPREP
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		*Report form yrexpti.frx to console preview in screen
		Report form yrexpti.frx PREVIEW WINDOW wReport 		
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrexpti.frx to printer prompt noconsole
Endcase
Endif
RETURN  

