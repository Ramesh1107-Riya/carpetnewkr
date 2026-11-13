**Reindex, and Validation of Databasebase
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
Use GrSuptran Exclu
if Rlock()
	Pack
	Unlock
	use in GrSuptran
Else
	Wait Window "GRSUPTRAN.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Grregstr Exclu
if Rlock()
	Pack
	Unlock
	use in Grregstr
Else
	Wait Window "GRREGSTR.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Grmaster Exclu
if Rlock()
	Pack
	Unlock
	use in Grmaster
Else
	Wait Window "GRMASTER.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 2
Endif
****End of Graph Transaction

***Wool Files Refresh
Use Wiissue Exclu
if Rlock()
	Pack
	Unlock
	use in Wiissue
Else
	Wait Window "WIISSUE.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Wirecv Exclu
if Rlock()
	Pack
	Unlock
	use in wirecv
Else
	Wait Window "WIRECV.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Wistock Exclu
if Rlock()
	Pack
	Unlock
	use in Wistock
Else
	Wait Window "WISTOCK.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Witrnord Exclu
if Rlock()
	Pack
	Unlock
	use in Witrnord
Else
	Wait Window "WITRNORD.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Wiqlty Exclu
if Rlock()
	Pack
	Unlock
	use in Wiqlty
Else
	Wait Window "WIQLTY.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

***End of Wool Transaction Files

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

Use Expackingf Exclu
if Rlock()
	Pack
	Unlock
	use in Expackingf
Else
	Wait Window "EXPACKINGF.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Expackingnp Exclu
if Rlock()
	Pack
	Unlock
	use in Expackingnp
Else
	Wait Window "EXPACKINGNP.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Casupord Exclu
if Rlock()
	Pack
	Unlock
	use in Casupord
Else
	Wait Window "CASUPORD.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Cabuyord Exclu
if Rlock()
	Pack
	Unlock
	use in Cabuyord
Else
	Wait Window "CABUYORD.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Stkcarpet Exclu
if Rlock()
	Pack
	Unlock
	use in Stkcarpet
Else
	Wait Window "STKCARPET.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Cabuyer Exclu
if Rlock()
	Pack
	Unlock
	use in Cabuyer
Else
	Wait Window "CABUYER.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Yrcalc Exclu
if Rlock()
	Pack
	Unlock
	use in YrcalC
Else
	Wait Window "YRCALC.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

 Use Casize Exclu
if Rlock()
	Pack
	Unlock
	use in Casize
Else
	Wait Window "CASIZE.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Cacolour Exclu
if Rlock()
	Pack
	Unlock
	use in Cacolour
Else
	Wait Window "CACOLOUR.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

*stop in 11 Sept,2012 by Ramesh due to unable to delete design DUNAND, problem in Entry part of Design
Use CaDesign Exclu
if Rlock()
	Pack
	Unlock
	use in CaDesign
Else
	Wait Window "CADESIGN.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Cafield Exclu
if Rlock()
	Pack
	Unlock
	use in Cafield
Else
	Wait Window "CAFIELD.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use CaCategory Exclu
if Rlock()
	Pack
	Unlock
	use in CaCategory
Else
	Wait Window "CACATEGORY.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
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

Use Carcdwea Exclu
if Rlock()
	Pack
	Unlock
	use in Carcdwea
Else
	Wait Window "CARCDWEA.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use CaSupplr Exclu
if Rlock()
	Pack
	Unlock
	use in CaSupplr
Else
	Wait Window "CASUPPLR.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use CaWshtyp Exclu
if Rlock()
	Pack
	Unlock
	use in CaWshtyp
Else
	Wait Window "CAWSHTYPE.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Ctype Exclu
if Rlock()
	Pack
	Unlock
	use in Ctype
Else
	Wait Window "CTYPE.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Destination Exclu
if Rlock()
	Pack
	Unlock
	use in Destination
Else
	Wait Window "DESTINATION.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Ordtype Exclu
if Rlock()
	Pack
	Unlock
	use in Ordtype
Else
	Wait Window "ORDTYPE.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use CaWeaver Exclu
if Rlock()
	Pack
	Unlock
	use in CaWeaver
Else
	Wait Window "CAWEAVER.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Password Exclu
if Rlock()
	Pack
	Unlock
	use in Password
Else
	Wait Window "PASSWORD.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Via Exclu
if Rlock()
	Pack
	Unlock
	use in Via
Else
	Wait Window "VIA.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

***White Yarn & Wool
Use Yrecp Exclu
if Rlock()
	Pack
	Unlock
	use in Yrecp
Else
	Wait Window "YRECP.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Yrnissdy Exclu
if Rlock()
	Pack
	Unlock
	use in Yrnissdy
Else
	Wait Window "YRNISSDY.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Yrnop Exclu
if Rlock()
	Pack
	Unlock
	use in Yrnop
Else
	Wait Window "YRNOP.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Yrnorder Exclu
if Rlock()
	Pack
	Unlock
	use in Yrnorder
Else
	Wait Window "YRNORER.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Yrnrecvd Exclu
if Rlock()
	Pack
	Unlock
	use in Yrnrecvd
Else
	Wait Window "YRNRECVD.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Yrsupop Exclu
if Rlock()
	Pack
	Unlock
	use in Yrsupop
Else
	Wait Window "YRSUPOP.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Woolqlty Exclu
if Rlock()
	Pack
	Unlock
	use in Woolqlty
Else
	Wait Window "WOOLQLTY.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif
Use Woolorder Exclu
if Rlock()
	Pack
	Unlock
	use in Woolorder
Else
	Wait Window "WOOLORDER.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Woolop Exclu
if Rlock()
	Pack
	Unlock
	use in Woolop
Else
	Wait Window "WOOLOP.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Woolissu Exclu
if Rlock()
	Pack
	Unlock
	use in Woolissu
Else
	Wait Window "WOOLISSU.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Wireturn Exclu
if Rlock()
	Pack
	Unlock
	use in Wireturn
Else
	Wait Window "WIRETURN.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Location Exclu
if Rlock()
	Pack
	Unlock
	use in Location
Else
	Wait Window "LOCATION.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Wisupop Exclu
if Rlock()
	Pack
	Unlock
	use in Wisupop
Else
	Wait Window "WISUPOP.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Woolpu Exclu
if Rlock()
	Pack
	Unlock
	use in Woolpu
Else
	Wait Window "WOOLPU.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use YrnWshIss Exclu
if Rlock()
	Pack
	Unlock
	use in YrnWshIss
Else
	Wait Window "YRNWSHISS.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use YrnWshRcd Exclu
if Rlock()
	Pack
	Unlock
	use in YrnWshRcd
Else
	Wait Window "YRNWSHRCD.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif

Use Packhead Exclu
if Rlock()
	Pack
	Unlock
	use in Packhead
Else
	Wait Window "PACKHEAD.DBF File  is used by Another user, FAIL To Refresh,  Later on!!!" Timeout 1
Endif


***End of Carpet *.dbf
dele file *.bak

Wait Window "Refresh Successful for Not Used Files..." Timeout 2
RETURN

*Do CloseFile
