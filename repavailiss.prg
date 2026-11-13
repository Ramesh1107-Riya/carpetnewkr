*repavailretn.prg
set procedure to catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo11      && Trim Information for Check Purpose !
Open Database Carpet

SELECT Id as OL_No,Quality,QltyGroup as Supplier,Colour as PO_No,NetWt,Remark as Design,Party as Bcode,Remark,Date;
FROM Yrndysttrn;
Where Date=>m.Text1 .and. Date<=m.Text2;
Into Cursor Availiss

Select * ;
From Availiss;
WHERE ccsMatch22(Supplier,Bcode,Quality,DESIGN,PO_NO,OL_NO);
Into Cursor Availiss2

SELECT OL_NO as Id,Quality,Supplier as QltyGroup,PO_NO as Colour,Netwt,Remark,Bcode as Party,Date;
From Availiss2;
Into Cursor Availiss3

SELECT Availiss3
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repavailiss.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repavailiss.frx to printer prompt noconsole
Endcase
Endif
UNLOCK ALL
USE IN SELECT([availopn3])
RETURN
* EoP()

