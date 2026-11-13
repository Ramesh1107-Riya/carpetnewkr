*RepPaintcm Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo7a      && Trim Information for Check Purpose !
Open Database Carpet

SELECT b.BCODE,b.QUALITY,b.DESIGN,b.COLOUR,s.FINSQMT,b.OL_NO,b.PO_NO,b.PO_DT,b.SZCODE;
FROM  Cabuyord b, Casupord s;
WHERE b.ol_no=s.ol_no;
INTO CURSOR temp1

SELECT t.BCODE,t.QUALITY,t.DESIGN,t.COLOUR,t.FINSQMT,t.OL_NO,t.PO_NO,t.PO_DT,t.SZCODE,s.carpetno,s.startdt,s.finidt,s.remark;
FROM  temp1 t,painting s;
WHERE t.ol_no=s.carpetno .and. !empty(s.startdt) ;
HAVING s.startdt>=m.Text1 .and. s.startdt<=m.Text2;
INTO CURSOR temp2
 
SELECT *;
FROM temp2;
WHERE ccsMatch18a(Bcode,CarpetNo,DESIGN,Quality,Colour,Szcode,PO_NO);
ORDER BY CARPETNO ASC;
INTO CURSOR temp3

SELECT temp3
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form reppaintcm.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form reppaintcm.frx to printer prompt noconsole
Endcase
Endif
Return


