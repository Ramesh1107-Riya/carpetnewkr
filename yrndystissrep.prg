SET DELETED ON
SET TALK OFF
SET SAFE OFF
Do Case
	Case !empty(m.quality) .and. !empty(m.colour)
		SELECT date,quality,colour,netwt,remark;
		FROM Yrndysttrn;
		WHERE quality=m.quality .and. colour=m.colour;
		ORDER BY Quality,Colour;
		INTO CURSOR avliss
	Case !empty(m.quality) .and. empty(m.colour)
		SELECT date,quality,colour,netwt,remark;
		FROM Yrndysttrn;
		WHERE quality=m.quality;
		ORDER BY Quality,Colour;
		INTO CURSOR avliss
	Case empty(m.quality) .and. !empty(m.colour)
		SELECT date,quality,colour,netwt,remark;
		FROM Yrndysttrn;
		WHERE colour=m.colour;
		ORDER BY Quality,Colour;
		INTO CURSOR avliss
Endcase

SELECT avliss
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form yrndystissrep.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport	
	Case m.PrnStat="P"
		Report form yrndystissrep.frx to printer prompt noconsole
Endcase
Endif
RETURN


