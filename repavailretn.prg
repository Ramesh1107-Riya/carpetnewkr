*repavailretn.prg
set procedure to catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo11      && Trim Information for Check Purpose !
Open Database Carpet

SELECT Id,Carpetno,bcode,Design,Quality,QltyGroup,Colour,SRetQty as Netwt,Rackno,Remark,Pno,SRetDt;
FROM Available;
Where Colour<>'NATURAL' .and. SRetDt=>m.Text1 .and. SRetDt<=m.Text2 ;
Into Cursor AvalRet

SELECT Id,Carpetno as OL_NO,Bcode,Design,Quality,QltyGroup as Supplier,Colour as Po_No,NetWt as Qty,Rackno,Remark,Pno,SRetDt;
FROM AvalRet;
Into Cursor cAvalRet1

Select * ;
From cAvalRet1;
WHERE ccsMatch22(Supplier,Bcode,Quality,DESIGN,PO_NO,OL_NO);
Into Cursor cAvalRet2

SELECT Id,OL_No as Carpetno,Bcode,Design,Quality,Supplier as QltyGroup,PO_NO as Colour,Qty,Rackno,Remark,Pno,SRetDt;
From cAvalRet2;
Into Cursor cAvalRet2

SELECT cAvalRet2
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repavailretn.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repavailretn.frx to printer prompt noconsole
Endcase
Endif
UNLOCK ALL
USE IN SELECT([cAvalRet2])
RETURN
* EoP()

