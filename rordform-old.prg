*rordform.prg Finds records for particular or many card no separated by ;
Set Date to Briti
Set Century on
SET ANSI ON
* Public Variable for Carpet-Inventory Search Option !!
PUBLIC m.psCardNo

**Initialization
STORE SPACE(100) TO m.psCardNo
m.psCardNo = m.Card_no && variable is defined in Order form
*WAIT WINDOW "Retrieving Records ... Please wait" NOWAIT

SET PROCEDURE TO Catool
* Error Trapping Procedure
 ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()
DO csTrimInfo6    && Trim Information for Check Purpose !
Open Database Carpet

	CREATE SQL VIEW temprepview1 AS SELECT s.Issdt,b.Po_no,s.Ol_no,s.Card_no,s.Supplier,b.Design,b.Colour,b.Quality,b.szcode,b.Qty,b.Sqmt,b.breadth,b.length,b.Fringes,s.wev_last_dt;
	FROM  Carpet!cabuyord b, Carpet!casupord s;
	Where b.ol_no=s.ol_no;
	Having s.Issdt=m.Issdt .and. s.Supplier=alltrim(m.Supplier) .and. b.Design=m.Design .and. b.Colour=m.Colour;
				 .and. b.Quality=m.Quality && .and. b.szcode=m.szcode [3/9/2015 removed as Tenzin & NP Reqment]

	CREATE SQL VIEW temprepview2 AS SELECT Issdt,Po_no,Ol_no,Card_no,Supplier,Design,Colour,Quality,szcode,Qty,Sqmt,breadth,length,Fringes,wev_last_dt;
	FROM Carpet!temprepview1;
	WHERE ccsMatch14(Card_No)

*************	
USE temprepview2  
*Dimension cardolno(6,2) && array is declared row=6,col=2
Dimension cardolno(81,2) && array is declared row=12,col=2
Store '' to cardolno && initialize array with '', by default .F.
Copy to Array Cardolno FIELDS Card_no,Ol_no

	CREATE SQL VIEW temprepview3 AS SELECT Issdt,Po_no,Ol_no,Card_no,Supplier,Design,Colour,Quality,szcode,Sum(Qty)Qty,breadth,length,wev_last_dt;
	FROM  Carpet!temprepview2;
	Group by Design,Quality,Colour,szcode &&[3/9/2015  added szcode as Tenzin & NP Reqment]

	*Array Display in Order form****************************
	Dimension ordfrm(4,4)
	Store ' ' to orderform
	Select Qty,Design,Colour,Szcode;
	From temprepview3;
	Into Cursor temp1
	Select temp1
	copy to ARRAY ordfrm
	*****************************************************

	CREATE SQL VIEW temprepview AS SELECT j.*,k.Issdt, k.Ol_no, k.Po_no, k.Colour, k.Supplier, k.szcode, k.Qty, k.breadth, k.length, k.wev_last_dt,j.slno;
	FROM  Carpet!yrcalc j, Carpet!temprepview3 k;
	Where j.design=k.design .and. j.basecolour=k.colour .and. j.quality=k.quality .and. !empty(j.date) 

***This is HT spcial to print both design chart list & empty list
USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	WAIT WINDOW"Either Colour Chart is Not Defined/ [Not Verified] - Date is empty in Yarn Chart for above Design!" NOWAIT
	  USE temprepview3 shared   
	   Do Case
		 Case m.PrnStat="V"
			Report form rordform-emty.frx PREVIEW WINDOW wReport 
			DEACTIVATE WINDOW wReport 
   		 Case m.PrnStat="P"
			Report form rordform-emty.frx to printer prompt noconsole
 	   Endcase
Else
  Do Case
	Case m.PrnStat="V"
		Report form rordform.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P"
		Report form rordform.frx to printer prompt noconsole
  Endcase
Endif
RETURN
**************

