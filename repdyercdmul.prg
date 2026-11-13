*Dyeing Recd Multiple Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo10      && Trim Information for Check Purpose !
Open Database Carpet

*Before 19/04/2022 this is modified as per Mr. Chomphel

*SELECT Bcode,Quality as Caqlty,DESIGN,Colour as Basecolour,PO_NO,OL_NO,PO_DT;
*FROM  Carpet!Cabuyord b;
*Group By bcode,caqlty,Design,Colour;
*INTO CURSOR temprep

*SELECT b.Caqlty,b.DESIGN,b.Basecolour,b.PO_NO,b.OL_NO,s.carpetno,s.pno,s.quality,s.colour,s.refno,s.qty,s.dyeisskg,s.hank,s.dyeissdt,s.dyename,s.bcode,;
*				s.dyrecdt,s.dyerecvkg,s.remark,s.repeatno,s.redydt;
*FROM  temprep b, Carpet!Yrnchtran s;
*WHERE b.bcode=s.bcode .and. b.Design=s.Design .and. b.Caqlty=s.Caqlty .and. b.BaseColour=s.basecolour .and. s.dyrecdt>=m.Text1 .and. s.dyrecdt<=m.Text2;
*INTO CURSOR temprep1
 
SELECT Bcode,Caqlty,DESIGN,Basecolour,alltrim(substr(Carpetno,1,6)) as PO_NO,Carpetno as OL_NO,Carpetno,pno,quality,colour,ply,refno,qty,estkg,dyeisskg,hank,dyeissdt,dyename,construction,;
		dyrecdt,dyerecvkg,remark,repeatno,redydt;
FROM  Yrnchtran;
WHERE dyrecdt>=m.Text1 .and. dyrecdt<=m.Text2;
INTO CURSOR temprep1

SELECT *;
FROM temprep1;
WHERE ccsMatch21(DyeName,Bcode,Quality,DESIGN,PO_NO,OL_NO);
ORDER BY carpetno;
INTO CURSOR cYrntemp

SELECT cYrntemp
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repdyercdmul.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repdyercdmul.frx to printer prompt noconsole
Endcase
Endif
Return
