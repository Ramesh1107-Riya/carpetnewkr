*help to cashistory.prg to print
Set Date to Briti
Set Date to Briti
Set Century on
SET SAFE OFF
SET TALK OFF
SET ANSI ON

Do Case
	Case m.PrnStat="V" 
		Report form cahistory.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" 
		Report form cahistory.frx to printer prompt noconsole
Endcase