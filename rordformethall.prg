*rordformeth1.prg Find History Estimation by Carpet No.
*SET PROCEDURE TO Catool
* Error Trapping Procedure
*ON ERROR DO SystemErr WITH ERROR(), MESSAGE(), LINENO(), MESSAGE(1), PROGRAM()
*Yarn Issue/Return to Supplier Multiple Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo11      && Trim Information for Check Purpose !
Open Database Carpet

***Supplier Adusjment in repdyerecmul.prg report, same form used to retrive history 25/11/2018

SELECT Po_no,Ol_no,Design,Colour,Quality,szcode,Sqmt,Qty,breadth,length,po_dt,bcode,notes,spcl_inst,fringes,comment,silkpr,Quality as supplier,estdt;
FROM  cabuyord;
Into Cursor temprepview1

Select i.pno,j.po_no,i.quality,i.colour,i.sqmt,i.ply,i.construction,i.rod,estkg,i.design,i.basecolour,j.szcode,i.caqlty,j.bcode,i.refno,;
		i.Qty,j.breadth,j.length,j.po_dt,j.notes,j.spcl_inst,j.fringes,j.comment,j.silkpr,j.po_no as orderno,j.ol_no,supplier,i.carpetno,j.estdt;  
From Yrnchtran i, temprepview1 j;
Where  i.carpetno=j.ol_no .and. j.EstDt>=m.Text1 .and. j.EstDt<=m.Text2;
ORDER BY i.carpetno;
Into cursor temp1

SELECT *;
FROM temp1;
WHERE ccsMatch22(Supplier,Bcode,Quality,DESIGN,PO_NO,OL_NO);
INTO CURSOR temprepview2

SELECT temprepview2
SET COLOR TO
If RECNO()>RECCOUNT()
	WAIT WINDOW"Record Not found with this Carpet No." NOWAIT
Else
  Do Case
	Case m.PrnStat="V" 
		Report form rordformethall.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P" 
		Report form rordformethall.frx to printer prompt noconsole
  Endcase
Endif
RETURN

