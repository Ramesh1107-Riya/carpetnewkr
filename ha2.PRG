SET ANSI ON
Private m.Colour,m.Design,m.Quality,m.Order_Type
m.Design='SAMLO'
m.colour='BLUE DUSK'
m.Quality='PW'
m.Order_Type='REGULAR'

**use above variable m.Colour,m.Design,m.Quality,m.Order_Type
If(m.Order_Type='REGULAR')
	Select silkper,Addusd;
	From CaDgnSilkPr;
	Where Design=m.Design .and. Colour=m.Colour .and. Quality=m.Quality;
	Into Cursor cSilkp
	
	Select cSilkp
	BROW
	If RECNO()>RECCOUNT()
		Wait Window 'Either Design has No Silk used OR Silk % Not Entered in Design-Silk % Database'
	Endif
Endif
	
	
	
