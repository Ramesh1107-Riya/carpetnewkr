SET TALK OFF
SET CENTURY ON
SET DATE TO BRITISH
SET SAFE OFF
SET ANSI ON

SELECT s.CARPETNO,s.DESIGN,s.QUALITY,s.COLOUR,s.breadth,s.length,s.sqmt,s.Amt,d.matcomp;
FROM  Stkcarpet s;
Join caDesign d;
ON s.Design=d.code;
Where carpetno=m.Carpetno;
INTO CURSOR temp1

select temp1
*********Printing
  SET COLOR TO
	If RECNO()>RECCOUNT()
		Messagebox("Record Not Found for the above seletion!!!")
	Else
		Do Case
			Case m.PrnStat="V"
				Label form labelkr5stk.lbx to console preview in screen
			Case m.PrnStat="P"
				Label form labelkr5stk.lbx to printer prompt noconsole
		Endcase
	Endif
*********end print


