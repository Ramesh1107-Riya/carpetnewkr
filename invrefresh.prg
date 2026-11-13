*Do InvRefresh
close all

Use Invdata Exclu
if Rlock()
	Pack
	Unlock
	use in Invdata
Else
	Wait Window "Invdata.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif
*
Use Expackingnp Exclu
if Rlock()
	Pack
	Unlock
	use in Expackingnp
Else
	Wait Window "Expackingnp.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif
*
Use Invtran Exclu
if Rlock()
	Pack
	Unlock
	use in Invtran
Else
	Wait Window "Invtran.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif