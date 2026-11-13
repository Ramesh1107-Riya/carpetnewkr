*Transpose colomun into rows 6/01/2017 Ramesh Basent,In a Quality there is Multiple nos rows.
Local m.Quality,m.Quality1,m.Dgn1,m.Dgn2,m.Dgn3,m.Dgn4,m.Dgn5
store '' to m.Quality,m.Quality1,m.Dgn1,m.Dgn2,m.Dgn3,m.Dgn4,m.Dgn5

Dimension DngArray(5)
Store ' ' to DngArray

SELECT QUALITY,DESIGN;
FROM Packtran;
WHERE Invno='G40/2016';
ORDER BY Quality,Design;
Group by Quality,Design;
Into Cursor Pack1


Select p.Quality,p.Design,d.Dgndesc;
From Pack1 p,CaDesign d;
Where p.Design=d.Code .and. p.Quality=d.Quality;
Order by p.Quality,p.Design;
Into Cursor Pack2

Select distinc quality;
From Pack2;
Into Cursor Pack3

Create cursor QltyDgn(Quality c(12),Dgn1 c(20),Dgn2 c(20),Dgn3 c(20),Dgn4 c(20),Dgn5 c(20))

select Pack3  
m.Quality=Pack3->Quality

do while .not. eof()
Select DgnDesc;
From Pack2;
Where Quality=m.Quality;
Into Array QlyArray

	ACOPY(QlyArray,DngArray)	
	
	m.Quality1=m.Quality
	m.Dgn1=iif(!empty(DngArray(1)),Alltrim(DngArray(1)),'')
	m.Dgn2=iif(!empty(DngArray(1)),Alltrim(DngArray(2)),'')
	m.Dgn3=iif(!empty(DngArray(1)),Alltrim(DngArray(3)),'')
	m.Dgn4=iif(!empty(DngArray(1)),Alltrim(DngArray(4)),'')
	m.Dgn5=iif(!empty(DngArray(1)),Alltrim(DngArray(5)),'')
	Insert into QltyDgn(Quality,Dgn1,Dgn2,Dgn3,Dgn4,Dgn5) values (m.Quality1,m.Dgn1,m.Dgn2,m.Dgn3,m.Dgn4,m.Dgn5)
	store '' to m.Quality,m.Quality1,m.Dgn1,m.Dgn2,m.Dgn3,m.Dgn4,m.Dgn5
	Store ' ' to DngArray
	Select Pack3
	If .not. eof()  
		skip
	m.Quality=Pack3->Quality
	Endif
enddo
*****************************
*iif() condition did not work altogether, check pieces by pcs using 4 iif() separately, closeing ')' at end condition.
Select Alltrim(Quality)+'  (' +Alltrim(Dgn1)+iif(!empty(Dgn2),+[, ]+Alltrim(Dgn2),'')+;
iif(!empty(Dgn3),+[, ]+Alltrim(Dgn3),'')+ iif(!empty(Dgn4),+[, ]+Alltrim(Dgn4),'')+ ;
iif(!empty(Dgn5),+[, ]+Alltrim(Dgn5),[)]) as DgnDesc;
From QltyDgn

