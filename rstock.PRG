*Stock Report, UnWashed+Issued Washed+Recd Wash - Exported  (chek validity)
SET TALK OFF
SET SAFE OFF
SET PROCEDURE TO Catool

DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

SELECT b.BCODE, b.PO_NO, b.CTRL_NO, b.OL_NO, b.QUALITY, b.DESIGN, b.SZCODE, b.COLOUR, b.FIELDCODE, s.BTHWEAV, s.LTHWEAV,;
	 s.FINSQMT,	b.WASHTYPE, b.SPCL_INST, b.COMMENT, b.CSTATUS, b.ORDER_TYPE, b.CTYPE, b.SQMT, b.DELIRY_DT, s.CARPETNO, s.CARD_NO, s.FDATE, s.PALATE,s.RATE,s.AMT;
FROM  Cabuyord b, Casupord s;
WHERE b.OL_NO=s.OL_NO .AND. !EMPTY(s.FDATE) .AND. b.EXPORTED <> .T. .and. s.FDATE>=m.Text1 .and. s.FDATE<=m.Text2;
INto cursor Stock1


SELECT *;
FROM stock1;
WHERE ccsMatch6(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE,WASHTYPE, SPCL_INST, COMMENT, CSTATUS, CTYPE );
ORDER BY fdate,carpetno;
Into Cursor Stock

Select Stock 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form rstock.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form rstock.frx to printer prompt noconsole
	Case m.PrnStat="E"	 
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,CARPETNO,PO_NO,QUALITY,DESIGN,COLOUR,BTHWEAV,LTHWEAV,FINSQMT,RATE,AMT,CSTATUS,ORDER_TYPE
   	 	Messagebox("Order Carpet Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	
Endcase
Endif
Return

