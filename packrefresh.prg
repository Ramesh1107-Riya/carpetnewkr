**Reindex, and Validation of Databasebase for all Packing and Invoice related tables
Set talk off
Set safe off
Set Reprocess to 1
**Calling program
  	 ON ERROR DO errhand IN errutil WITH SYS(0), ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO(1), DBF(), DATE(), TIME()
**End of error trap setup.

*Open Database carpet 
*validate database
*clea
****Graph *.dbf Refresh
***Carpet *.dbf files

Use Invtran Exclu
if Rlock()
	Pack
	Unlock
	use in Invtran
Else
	Wait Window "INVTRAN.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Packtran Exclu
if Rlock()
	Pack
	Unlock
	use in Packtran
Else
	Wait Window "PACKTRAN.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Expackingnp Exclu
if Rlock()
	Pack
	Unlock
	use in Expackingnp
Else
	Wait Window "EXPACKINGNP.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Cabuyer Exclu
if Rlock()
	Pack
	Unlock
	use in Cabuyer
Else
	Wait Window "CABUYER.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use CaDesign Exclu
if Rlock()
	Pack
	Unlock
	use in CaDesign
Else
	Wait Window "CADESIGN.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Capo  Exclu
if Rlock()
	Pack
	Unlock
	use in Capo
Else
	Wait Window "CAPO.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Caqlty Exclu
if Rlock()
	Pack
	Unlock
	use in Caqlty
Else
	Wait Window "CAQLTY.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use CaWshtyp Exclu
if Rlock()
	Pack
	Unlock
	use in CaWshtyp
Else
	Wait Window "CAWSHTYPE.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use BuyRate Exclu
if Rlock()
	Pack
	Unlock
	use in BuyRate
Else
	Wait Window "BUYRATE.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Bankdtl Exclu
if Rlock()
	Pack
	Unlock
	use in Bankdtl
Else
	Wait Window "BANKDTL.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Packhead Exclu
if Rlock()
	Pack
	Unlock
	use in Packhead
Else
	Wait Window "PACKHEAD.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Curncytypes Exclu
if Rlock()
	Pack
	Unlock
	use in Curncytypes
Else
	Wait Window "CURNCYTYPES.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use InvData Exclu
if Rlock()
	Pack
	Unlock
	use in InvData
Else
	Wait Window "INVDATA.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Invprofma Exclu
if Rlock()
	Pack
	Unlock
	use in Invprofma
Else
	Wait Window "INVPROFMA.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

***End of Carpet *.dbf
dele file *.bak

Wait Window "Refresh Successful for Not Used Files..." Timeout 2
RETURN

*Do CloseFile
