SET DELETED ON
Open database carpet share
************************************collect all data from 3 tables******************
CREATE SQL VIEW yrnexpts AS;
Select i.Date,i.Suplier, i.Quality, i.Netwt, i.Rcode;
FROM  yrsupop i;
union all;
Select  j.Issdt, j.Suplier, j.Quality, j.Ynwtles10, j.Rcode;
FROM woolissu j;
union all;
Select  k.Date, k.Suplier, k.Quality, k.Netwt, k.Rcode;
FROM  yrecp k


***************************************Sum on Supplier********************************************
Select Date,Suplier,Quality, Sum(Netwt) Netwt, Rcode;
FROM  carpet!yrnexpts;
WHERE date>=msdate .and. date<=medate;
Group by suplier,quality,rcode;
Order by suplier,quality;
INTO cursor yrexp

***************************************************************************************************************
CREATE CURSOR YRNEXPREPS (NAME C(15), YQLTY C(8), OPYWT N(12,3), RCDYWT N(12,3), ISSYWT N(12,3), REMARK C(3))
*****************************************************************************************************************

Select yrexp
do while .not. eof()

SELECT YRNEXPREPS    
appen blank

repl Name with yrexp->Suplier
repl Yqlty with yrexp->Quality,remark with yrexp->rcode

do case 
	case remark='Opn'
		  repl opywt with yrexp->Netwt
    case remark='Rec'
		  repl rcdywt with yrexp->Netwt
	case remark='Iss'
		 repl issywt with yrexp->Netwt
endcase
sele yrexp
IF .NOT. EOF()
	   SKIP
ENDIF
enddo
****************************************************************************************************************
*This table is made and temporarily include in DE of Report, after cursor is established then delete the table
*infact remove from DE.
*Select *;
*From Yrnexpreps;
*into table yrnexptem2.dbf
*use

******************************************************************************************************************

SELECT YRNEXPREPS  
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		*Report form yrexpts.frx to console preview in screen
		
		Report form yrexpts.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yrexpts.frx to printer prompt noconsole
Endcase
Endif
RETURN  


