*rordformeth1.prg Find History Estimation by Carpet No.
*SET PROCEDURE TO Catool
* Error Trapping Procedure
*ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()
*Yarn Issue/Return to Supplier Multiple Report
SET DELETED ON
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

***Supplier Adusjment in repdyerecmul.prg report, same form used to retrive history 25/11/2018

SELECT Po_no,Ol_no,Design,Colour,Quality,szcode,Sqmt,Qty,breadth,length,po_dt,bcode,notes,spcl_inst,fringes,comment,silkpr,Quality as supplier;
FROM  cabuyord;
Where Ol_no=m.psOl_no;
Into Cursor temprepview1

Select i.pno,j.po_no,i.quality,i.colour,i.sqmt,i.ply,i.construction,i.rod,estkg,i.design,i.basecolour,j.szcode,i.caqlty,j.bcode,i.refno,;
		i.Qty,j.breadth,j.length,j.po_dt,j.notes,j.spcl_inst,j.fringes,j.comment,j.silkpr,j.po_no as orderno,j.ol_no,supplier,i.carpetno;  
From Yrnchtran i, temprepview1 j;
Where  i.carpetno=j.ol_no;
ORDER BY i.pno,i.ply desc;
Into cursor temp3
*ORDER BY i.pno,i.quality,i.colour orginal on 29/10/2018 change by Ramesh

SELECT temp3
SET COLOR TO
If RECNO()>RECCOUNT()
	WAIT WINDOW"Record Not found with this Carpet No." NOWAIT
Else
  Do Case
	Case m.PrnStat="V" 
		Report form rordformlngethis.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P" 
		Report form rordformlngethis.frx to printer prompt noconsole
  Endcase
Endif
RETURN

