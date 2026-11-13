**New Method of Making Cursor Readable 18/10/2023 Ramesh OK Working well faster
**Printing Selected Labels by [Y]
** Label Antique
*set procedure to catool
*do SetColour

**In colour store US$
*SELECT CARPETNO,OL_NO,CTRL_NO,DESIGN,QUALITY,SZCODE,SQMT,LOCATION,SKUNO,SPCL_INST,COMMENT,NOTES,PO_NO,PO_DT,COLOUR,SCODE,PHOTO;
*FROM  Stkcarpet;
*WHERE Carpetno==m.carpetno;		
*Into cursor temp1

SELECT CARPETNO,DESIGN,QUALITY,COLOUR,shbr,shln,blno,rate,pkcomment,offprice;
FROM  Stkcarpet;
WHERE Scode=m.Scode;		
Into cursor temp1

*SELECT CARPETNO,DESIGN,QUALITY,COLOUR,shbr,shln,blno,rate,pkcomment,offprice;
*FROM  Stkcarpet;
*WHERE Carpetno=m.Carpetno;		
*Into cursor temp1

select temp1
*********Printing
  SET COLOR TO
	If RECNO()>RECCOUNT()
		Messagebox("Record Not Found for the above seletion!!!")
	Else
		Do Case
			Case m.PrnStat="V"
				Label form label3mtr.lbx to console preview in screen
			Case m.PrnStat="P"
				Label form label3mtr.lbx to printer prompt noconsole
		Endcase
	Endif
*********end print


