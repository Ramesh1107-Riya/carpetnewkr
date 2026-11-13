SET DELETED ON
SET PROCEDURE TO Catool
SET TALK OFF
SET SAFE OFF
Set Date to Briti
Set Century off

DO csTrimInfo3a      && Trim Information for Check Purpose !

***Null Report, see po of all report
SELECT BCODE, CARPETNO, PO_NO, Buyerno, OL_NO, QUALITY, DESIGN, COLOUR, Shipbrth, Shiplngth, Subbuyer,SQMT,Invno,expdt;
FROM  Packtran;
WHERE  !empty(EXPDT) .and. EXPDT>=m.Text1 .and. EXPDT<=m.Text10 .and. ccsMatch3a(BCODE, CARPETNO, PO_NO, BUYERNO, OL_NO, QUALITY, DESIGN,  COLOUR, SUBBUYER, INVNO );
Order By Invno,Bcode;
Into Cursor BuyPack1

SELECT b.BCODE, a.CARPETNO, a.PO_NO, Buyerno, a.OL_NO, a.QUALITY, a.DESIGN, a.COLOUR, a.Shipbrth, a.Shiplngth, a.Subbuyer,a.SQMT,a.Invno,a.expdt,b.Washtype;
FROM BuyPack1 a, Cabuyord b;
WHERE a.OL_NO=b.OL_NO .and. ccsMatch4A(WASHTYPE);
Into Cursor BuyPack


Select BuyPack
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form rsearchallexp.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form rsearchallexp.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
	EXPORT TO &exclfile TYPE XL5 FIELDS BCODE, CARPETNO, PO_NO, Buyerno, OL_NO, QUALITY, DESIGN, COLOUR, Shipbrth, Shiplngth, Subbuyer,SQMT,Invno,expdt,Washtype
		Messagebox("Search Production Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
Endcase
Endif
Return
