*All Tag issue PRC report (RepPrcTag)
do srchweaver
SET COLOR TO

Use temprepview Share
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form prctag.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form prctag.frx to printer prompt noconsole
Endcase
Endif
Return