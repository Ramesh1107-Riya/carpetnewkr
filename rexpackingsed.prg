* PACKING LIST  ALL report 
SET TALK OFF
SET CENTURY ON
SET DATE TO BRITISH
SET SAFE OFF
SET ANSI ON
OPEN DATABASE CARPET

Select *;
From expackingnp;
where Alltrim(invno)=Alltrim(m.invno);
Into cursor packdtl

Dimension packdata (1,22)
Store ' ' to packdata
Select packdtl
copy to ARRAY packdata


Select temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="F" .and. m.chk1=0
		Report form expackingGR.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="F" .and. m.chk1=0
		Report form expackingGR.frx to printer prompt noconsole
	
	Case m.PrnStat="V" .and. m.Option="S" .and. m.chk1=0
		Report form expackingUS.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="S" .and. m.chk1=0
		Report form expackingUS.frx to printer prompt noconsole
	

	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BALENO,CARPETNO,DgnDesc,CoDesc,Size,SQMT,SpecialMark,QltyDesc,Buyerno,DgnCode,SizeCode1,SUBBUYER,PO_NO
			Messagebox("Packing List Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Otherwise		
		Messagebox("Invalid choice, make correct Choice!!")
Endcase
Endif
SET ANSI OFF
Return


