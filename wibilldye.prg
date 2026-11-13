SET DELETED ON
SET TALK OFF
SET SAFE OFF

Do case
	Case !empty(m.BillNo) .and. empty(Colour)
		SELECT DATE,OL_NO,DESIGN,ACNO,BILLNO,MATCH,QUALITY,COMMENT AS REMARK,PARTY,YTYPE,COLOUR,RATE,QUANTITY,AMT,REMARK AS REMARK1;
		FROM Witrnord;
		WHERE Billno=Alltrim(m.BillNo);
		ORDER BY ol_no,acno,Colour;
		INTO CURSOR ISS1
	Case empty(m.BillNo) .and. !empty(Colour)
		SELECT DATE,OL_NO,DESIGN,ACNO,BILLNO,MATCH,QUALITY,COMMENT AS REMARK,PARTY,YTYPE,COLOUR,RATE,QUANTITY,AMT,REMARK AS REMARK1;
		FROM Witrnord;
		WHERE colour=Alltrim(m.colour);
		ORDER BY ol_no,acno,Colour;
		INTO CURSOR ISS1
	Case !empty(m.BillNo) .and. !empty(Colour)		
		SELECT DATE,OL_NO,DESIGN,ACNO,BILLNO,MATCH,QUALITY,COMMENT AS REMARK,PARTY,YTYPE,COLOUR,RATE,QUANTITY,AMT,REMARK AS REMARK1;
		FROM Witrnord;
		WHERE Billno=Alltrim(m.BillNo)  .and. colour=Alltrim(m.colour);
		ORDER BY ol_no,acno,Colour;
		INTO CURSOR ISS1
Endcase
   
SELECT ISS1
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V" .and. m.DyePlan=.T.
		Report form wibilldyePlan.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport	
	Case m.PrnStat="P" .and. m.DyePlan=.T.
		Report form wibilldyePlan.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. m.DyeIss=.T.
		Report form wibilldye.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport	
	Case m.PrnStat="P" .and. m.DyeIss=.T.
		Report form wibilldye.frx to printer prompt noconsole
Endcase
Endif
RETURN
