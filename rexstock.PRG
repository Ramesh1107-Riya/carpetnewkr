*STOCK CHECKING = weaved carpet+issuedwash+recdwash-export
*Exclude Packing= weaved carpet+issuedwash+recdwash-export-packing
Private head1
SET PROCEDURE TO Catool
DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

Do Case
	Case m.check1=0
		SELECT  b.PO_NO, s.CARPETNO, s.CARD_NO, b.OL_NO, b.DESIGN, b.COLOUR, s.BTHWEAV, s.LTHWEAV, s.FINSQMT, s.FDATE,  b.QUALITY, b.ORDER_TYPE, b.BCODE, b.CSTATUS, b.SHIP_INST, s.RATE,s.AMT ;
		FROM Cabuyord b,Casupord s;
		Where b.ol_no=s.ol_no .and. !empty(s.Fdate) .and. b.exported <> .T.;
		INTO CURSOR temp3
		head1="Stock Report of All Order Carpets"
	Case m.check1=1
		SELECT  b.PO_NO, s.CARPETNO, s.CARD_NO, b.OL_NO, b.DESIGN, b.COLOUR, s.BTHWEAV, s.LTHWEAV, s.FINSQMT, s.FDATE,  b.QUALITY, b.ORDER_TYPE, b.BCODE, b.CSTATUS, b.SHIP_INST,s.RATE,s.AMT ;
		FROM Cabuyord b,Casupord s;
		Where b.ol_no=s.ol_no .and. !empty(s.Fdate) .and. b.exported <> .T. .and. b.CSTATUS<>"Packed";
		INTO CURSOR temp3
		head1="Stock Report of Order (Exclude Packing)"
Endcase

SELECT PO_NO, CARPETNO, CARD_NO, OL_NO, DESIGN, COLOUR, BTHWEAV, LTHWEAV, FINSQMT, FDATE, QUALITY, ORDER_TYPE, BCODE, CSTATUS, SHIP_INST,RATE,AMT ;
FROM temp3;
WHERE ccsMatch8(BCODE, PO_NO, QUALITY, ORDER_TYPE);
ORDER BY fdate,carpetno;
INTO CURSOR temp


SELECT temp
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form exstock.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form exstock.frx to printer prompt noconsole
	Case  m.PrnStat="E" 
	 EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,CARPETNO,PO_NO,QUALITY,DESIGN,COLOUR,BTHWEAV,LTHWEAV,FINSQMT,RATE,AMT,CSTATUS,ORDER_TYPE
   	 Messagebox("Order Carpet Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
Endcase
Endif
Return

