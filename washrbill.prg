*Washing Received Report
SET DELETED ON
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

If (m.PrnStat="P" .and. !empty(s.RCDDTWASH))
	Do AutoSlpWhi
	SELECT s.CARPETNO, b.DESIGN, b.QUALITY, b.COLOUR, b.OL_NO, s.ISSDTWASH, s.RCDDTWASH, b.Sqmt, b.Szcode,s.whIslip,s.whRslip;
	FROM  Cabuyord b, Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.IssDtWash) ;
	HAVING s.RCDDTWASH>=m.Text1 .and. s.RCDDTWASH<=m.Text2;
	Into Cursor Temp1

	UPDATE Casupord;
	SET WhISlip=m.pWhISlip;
	WHERE ol_no IN (SELECT Ol_no FROM Temp1) 
Endif

SELECT s.CARPETNO, b.DESIGN, b.QUALITY, b.COLOUR, b.OL_NO, s.ISSDTWASH, s.RCDDTWASH, b.Sqmt, b.Szcode,s.whIslip,s.whRslip;
FROM  Cabuyord b, Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.IssDtWash) ;
HAVING s.RCDDTWASH>=m.Text1 .and. s.RCDDTWASH<=m.Text2;
Into Cursor washrcd

Select washrcd
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form washrbill.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form washrbill.frx to printer prompt noconsole
Endcase
Endif
Return


