*RepFinAllTcm Report, Integrated Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo7a      && Trim Information for Check Purpose !
Open Database Carpet

Set Date to Briti
Set Century off
SELECT b.BCODE,s.CARPETNO, b.DESIGN,b.COLOUR,b.QUALITY,b.SZCODE,b.Sqmt,b.PO_NO,s.issdt,s.Fdate,s.RCDDTWASH as WshRdt,s.ISSDTWASH as WshIdt;
FROM Cabuyord b, Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.FDate) .and. b.Cstatus<>'Exported';
Into Cursor Fini1

SELECT f.BCODE,f.CARPETNO,f.DESIGN,f.COLOUR,f.QUALITY,f.SZCODE,f.sqmt,f.PO_NO,f.Issdt,f.FDate,f.WshRdt,f.WshIdt,;  && Casupord
		iif(ISNULL(r.startdt),{},r.startdt) as rsdt,iif(ISNULL(r.finidt),{},r.finidt) as rfdt,; && repair
		iif(ISNULL(p.startdt),{},p.startdt) as psdt,iif(ISNULL(p.finidt),{},p.finidt) as pfdt,; && painting
		iif(ISNULL(fi.finidt),{},fi.finidt) as fifdt; && finish
FROM Fini1 f;
Left Join repair r;
On f.carpetno=r.carpetno;
Left Join Painting p;
On f.carpetno=p.carpetno;
Left Join Finitcm fi;
On f.carpetno=c.carpetno;
Into Cursor Fini2

Select BCODE,CARPETNO,DESIGN,COLOUR,QUALITY,SZCODE,SQMT,PO_NO,Issdt,FDate,FDate-Issdt as Wvd,WshRdt,WshIdt,WshRdt-WshIdt as Whd,;
	rsdt,rfdt,rfdt-rsdt as rpd,psdt,pfdt,pfdt-psdt as ptd,fifdt,fifdt-issdt as tod; 
From Fini2;
Where Fdate>=m.Text1 .and. Fdate<=m.Text2;
Into Table Fini3
 
SELECT *;
FROM Fini3;
WHERE ccsMatch18a(Bcode,CarpetNo,DESIGN,Quality,Colour,Szcode,PO_NO);
ORDER BY CARPETNO ASC;
INTO CURSOR Fini4a

SELECT Fini4a
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repfinalltcm.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repfinalltcm.frx to printer prompt noconsole
Endcase
Endif
use in Fini4a
unlock all
Return
