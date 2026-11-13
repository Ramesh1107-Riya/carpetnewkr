SET DELETED ON
SET TALK OFF
SET SAFE OFF
Do Case
	Case !empty(m.quality) .and. !empty(m.colour)
		SELECT date,quality,colour,netwt,rackno,remark;
		FROM Yrndystopn;
		WHERE quality=m.quality .and. colour=m.colour;
		ORDER BY Quality,Colour;
		INTO CURSOR avlopn
	Case !empty(m.quality) .and. empty(m.colour)
		SELECT date,quality,colour,netwt,rackno,remark;
		FROM Yrndystopn;
		WHERE quality=m.quality;
		ORDER BY Quality,Colour;
		INTO CURSOR avlopn
	Case empty(m.quality) .and. !empty(m.colour)
		SELECT date,quality,colour,netwt,rackno,remark;
		FROM Yrndystopn;
		WHERE colour=m.colour;
		ORDER BY Quality,Colour;
		INTO CURSOR avlopn
Endcase

SELECT avlopn
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrndystopn.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport	
	Case m.PrnStat="P"
		Report form yrndystopn.frx to printer prompt noconsole
Endcase
Endif
RETURN


