Public m.puacno
	Select max(acno) as maxacno ;
	FROM Casupplr;
	Into cursor macno

	Select macno
	m.puacno=macno->maxacno+1


