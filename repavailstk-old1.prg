*repavailstk.prg
set procedure to catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo11      && Trim Information for Check Purpose !
Open Database Carpet

*Create Cursor Availstock(CARPETNO C(18),ID C(7),BCODE C(10),DESIGN C(20),COLOUR C(10),PNO C(2),QUALITY C(12),QLTYGROUP C(15),RACKNO C(15),REMARK C(30),NETWT N(7,3),ISSNETWT N(7,3))

*SELECT Id,Carpetno,bcode,Design,Quality,QltyGroup,Colour,SRetQty as Netwt,Rackno,Remark,Pno;
*FROM Available;
*Order by Id;
*Into Cursor AvalRet

*1)Get all YARN DATA FOR STOCK OP+RETURN
*SELECT AVAILSTOCK
*Appen from Yrndystopn
*Appen from Available
*APPEN from dbf('AvalRet')

*1) Available Issue is grouped and Added by Id to get total Issue Qty by ID
SELECT Id,Quality,QltyGroup,Colour,sum(netwt) as IssNetwt;
FROM Yrndysttrn;
Group by Id;
Order by Id;
Into Cursor cIssue

*2)Get all YARN DATA FOR (STOCK RETURN - Isssue)
SELECT a.Id,a.Carpetno,a.bcode,a.Design,a.Quality,a.QltyGroup,a.Colour,a.SRetQty as Netwt,a.Rackno,a.Remark,a.Pno,i.IssNetwt;
FROM Available a;
Left Join cIssue i;
on a.Id=i.Id;
Order by a.id;
Into Cursor Availstock;


*Select cIssue
*Scan 
*	Update Availstock;
*	Set IssNetwt=cIssue.Netwt;
*	Where Id=cIssue.Id
*Endscan

SELECT Id,Carpetno,Carpetno as OL_NO,Bcode,Design,Quality,QltyGroup,QltyGroup as Supplier,Colour,Colour as Po_No,NetWt-iif(IssNetwt>0,IssNetwt,0.0) as Qty,Rackno,Remark,Pno;
FROM Availstock;
Into Cursor Availstok1

Select * ;
From Availstok1;
WHERE ccsMatch22(Supplier,Bcode,Quality,DESIGN,PO_NO,OL_NO);
Into Cursor cTemprep

SELECT cTemprep
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repavailstk.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repavailstk.frx to printer prompt noconsole
Endcase
Endif
UNLOCK ALL
USE IN SELECT([cTemprep1])
RETURN
* EoP()

