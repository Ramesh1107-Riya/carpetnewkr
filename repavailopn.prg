*repavailretn.prg
set procedure to catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo11      && Trim Information for Check Purpose !
Open Database Carpet

SELECT Id as OL_No,Quality,QltyGroup as Supplier,Colour as PO_No,NetWt,Rackno,Remark as Design,Remark as Bcode,Remark;
FROM Yrndystopn;
Into Cursor availopn

Select * ;
From availopn;
WHERE ccsMatch22(Supplier,Bcode,Quality,DESIGN,PO_NO,OL_NO);
Into Cursor availopn2

SELECT OL_NO as Id,Quality,Supplier as QltyGroup,PO_NO as Colour,Netwt,Rackno,Remark;
From availopn2;
Into Cursor availopn3

SELECT availopn3
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repavailopn.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repavailopn.frx to printer prompt noconsole
Endcase
Endif
UNLOCK ALL
USE IN SELECT([availopn3])
RETURN
* EoP()

