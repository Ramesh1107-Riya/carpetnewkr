*Washing Received Report
SET DELETED ON
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

SELECT s.CARPETNO, b.DESIGN, b.QUALITY, b.COLOUR, b.OL_NO, s.ISSDTWASH, s.RCDDTWASH, b.Sqmt, b.Szcode;
FROM  Cabuyord b, Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.IssDtWash) ;
HAVING s.ISSDTWASH>=m.Text1 .and. s.ISSDTWASH<=m.Text2;
Into Cursor washiss

Select washiss
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form washibill.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form washrbill.frx to printer prompt noconsole
Endcase
Endif
Return


