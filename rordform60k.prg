*rordform.prg Finds records for particular or many card no separated by ;
Set Date to Briti
Set Century on
SET ANSI ON

* Public Variable for Carpet-Inventory Search Option !!
*PUBLIC m.psCardNo

**Initialization
*STORE SPACE(30) TO m.Fringe1,m.Fringe2,m.Fringe3,m.Fringe4 && used in samling
*STORE SPACE(100) TO m.psCardNo
*m.psCardNo = m.Card_no && variable is defined in Order form

*SET PROCEDURE TO Catool
* Error Trapping Procedure
 *ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()
*DO csTrimInfo6    && Trim Information for Check Purpose !
*Open Database Carpet
	SELECT s.Issdt,b.Po_no,s.Ol_no,s.Card_no,s.Supplier,b.Design,b.Colour,b.Quality,b.szcode,b.Qty,b.Sqmt,b.breadth,b.length,b.Fringes,s.wev_last_dt;
	FROM  Carpet!cabuyord b, Carpet!casupord s;
	Where b.ol_no=s.ol_no;
	Having s.Issdt=m.Issdt .and. s.Supplier=alltrim(m.Supplier);
	Order by b.Design,b.Quality,b.Colour,b.szcode;
	Into Cursor temp9
	
Select temp9
SET COLOR TO
If RECNO()>RECCOUNT()
	WAIT WINDOW"Supplier Order Not Found!" NOWAIT
Else
  Do Case
	Case m.PrnStat="V"
		Report form rordform60k.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P"
		Report form rordform60k.frx to printer prompt noconsole
  Endcase
Endif
RETURN
**************

