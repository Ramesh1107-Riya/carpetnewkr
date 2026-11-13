Select Quality,Colour;
From yrnop;
Where QUALITY=PSQUALITY .AND. COLOUR=PSCOLOUR;
Into cursor wyop
Select wyop
IF !(RECNO()>RECCOUNT()) &&IF Record found
	PcommentR="White Yarn Return"
	Pdyewhtr='W'
ELSE
*2. Check in Dyed Yarn opening
	Select Quality,Colour;
	From wistock;
	Where QUALITY=PSQUALITY .AND. COLOUR=PSCOLOUR;
	Into Cursor dyop
	Select dyop
	IF RECNO()>RECCOUNT() &&IF Record not found empty
		Messagebox("Record Not Found in [White Yarn Opening] or [Dyed Yarn Opening] Please Enter in one of it",16)
	Else  && IF RECORD FOUND
		PcommentR="Dyed Yarn Return"
		Pdyewhtr='D'
	Endif
ENDIF