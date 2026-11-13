*Quality,Design Not used from Packtran.dbf instead Cadesing.dbf->Dgndesc, Caqlty.dbf->QltyInv, Cabuyord.dbf->Notes and CaDesing->DgnDesc are same
*spcl_inst in cabuyord and packing subbuyer are same
* PACKING LIST  ALL report 
SET TALK OFF
SET CENTURY ON
SET DATE TO BRITISH
SET SAFE OFF
SET ANSI ON
*OPEN DATABASE CARPET

Select *;
From expackingnp;
where Alltrim(invno)=Alltrim(m.invno);
Into cursor packdtl

Dimension packdata (1,32)
Store ' ' to packdata
Select packdtl
copy to ARRAY packdata


SELECT p.BCODE,INVNO,baleno,SLNO,CARPETNO,NotQltyPO_NO,P.Design,Notes,COLOUR,p.QUALITY,SHIPBRTH,SHIPLNGTH,SQMT,Ln,Br,Ht,nwt,gwt,buyerno,skuno,subbuyer,d.Matcomp;
FROM Packtran p;
Inner Join Cadesign q;
On p.design=q.code;
Where invno=m.invno;
Into Cursor temprepview1


SELECT DISTIN BCODE,INVNO,BALENO,SLNO,CARPETNO,NotQlty,PO_NO,Design,Notes,COLOUR,QUALITY,SHIPBRTH,SHIPLNGTH,SQMT,Ln,Br,Ht,nwt,gwt,buyerno,skuno,Matcomp,;
	j.br_feet,j.br_inch,j.ln_feet,j.ln_inch,j.sqft;
FROM temprepview1 i;
Inner Join casize j;
on i.szcode=j.szcode;
Order by Baleno,slno;
Into Cursor temprepview

		
Select temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	*Packing by Sea
	Case m.PrnStat="V" .and. m.Option="A" .and. Empty(m.SendOption) .and. m.chk1=0
		Report form expackingSea.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="A" .and. Empty(m.SendOption) .and. m.chk1=0
		Report form expackingSea.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.Option="A" .and. Empty(m.SendOption) .and. m.chk1=1
		Report form expackingSea1.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="A" .and. Empty(m.SendOption) .and. m.chk1=1
		Report form expackingSea1.frx  to printer prompt noconsole

		*Packing by Air
	Case m.PrnStat="V" .and. m.Option="B" .and. Empty(m.SendOption) .and. m.chk1=0
		Report form expackingAir.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B" .and. Empty(m.SendOption) .and. m.chk1=0
		Report form expackingAir.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.Option="B" .and. Empty(m.SendOption) .and. m.chk1=1
		Report form expackingAir1.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B" .and. Empty(m.SendOption) .and. m.chk1=1
		Report form expackingAir1.frx  to printer prompt noconsole

	Case  m.PrnStat="V" .and. (m.SendOption="A" .OR. m.SendOption="B") .and. (m.chk1=0 .or. m.chk1=1)
	    *Set path to //ExclReport
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,INVNO,BALENO,SLNO,CARPETNO,PO_NO,Design,Notes,COLOUR,QUALITY,SHIPBRTH,SHIPLNGTH,SQMT,Ln,Br,Ht,nwt,gwt,buyerno,skuno,subbuyer
			Messagebox("Packing List Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Otherwise		
		Messagebox("Invalid choice, make correct Choice!!")
Endcase
Endif
SET ANSI OFF
Return


