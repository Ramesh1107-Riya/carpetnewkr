*FINISHED PRC Summary report report, Paid
Set Century on
SET DELETED ON
*SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

*DO csTrimInfo5      && Trim Information for Check Purpose !
Open Database Carpet

SELECT b.BCODE, b.QUALITY, s.CARD_NO, s.WEAVER, s.CARPETNO,  b.DESIGN, b.COLOUR, s.BTHWEAV,;
s.LTHWEAV, s.FINSQMT, b.OL_NO, s.ISSDT, s.GRADE, s.FDate, b.PO_NO, b.NOTES,s.Rate,s.amt,s.Penalamt,s.extramt, S.ALLOWPAY, S.PAIDSTATUS;
FROM  Carpet!Cabuyord b, Carpet!Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.Fdate) .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2;
INTO CURSOR temprepview1

SELECT Weaver,sum(Finsqmt) Finsqmt,sum(Amt) Amt,sum(penalamt) penalamt,sum(extramt) extramt;
FROM  temprepview1;
Where !empty(amt).AND. ALLOWPAY=.T. .AND. PAIDSTATUS=.F.; && pending implement later
Group by Weaver;
ORDER BY Weaver,FDate ASC;
INTO CURSOR temprepview	

SELECT i.*,j.CompName;
FROM temprepview i,casupplr j;
WHERE i.Weaver=j.code;
ORDER BY i.Weaver ASC;
INTO CURSOR temprepviewf

Select temprepviewf  
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prcfinis.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prcfinis.frx to printer prompt noconsole
Endcase
Endif
Return


