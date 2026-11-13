*Payment Pending FINISHED PRC report 
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo5      && Trim Information for Check Purpose !
Open Database Carpet
SELECT b.BCODE, b.QUALITY, s.CARD_NO, s.WEAVER, s.CARPETNO,  b.DESIGN, b.COLOUR, s.BTHWEAV,;
s.LTHWEAV, s.FINSQMT, b.OL_NO, s.ISSDT, s.GRADE, s.FDate, b.PO_NO, b.NOTES,s.Rate,s.amt,s.Penalamt,s.extramt,b.FIELDCODE,s.DANDI,s.ALLOWPAY,s.PaidStatus;
FROM  Carpet!Cabuyord b, Carpet!Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) .AND. s.PaidStatus<>.T.;
INTO CURSOR temprepview1 

*HAVING s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2 && temporarily removed by ramesh, just to scan every pending carpet

SELECT *;
FROM temprepview1;
WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes, BillNo);
ORDER BY Weaver,FDate ASC;
INTO CURSOR temprepview 	

SELECT i.*,j.CompName;
FROM temprepview i,casupplr j;
WHERE i.Weaver=j.code;
ORDER BY i.Weaver;
INTO CURSOR temprepviewf


Select temprepviewf
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prcfinipend.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcfinipend.frx to printer prompt noconsole
Endcase
Endif
Return


