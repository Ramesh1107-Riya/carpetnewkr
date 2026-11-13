*Inserting from one table to another table single field
********************************************************
*Select * from Fringe into cursor Frng
*SELECT Frng
*SCAN 
*	INSERT INTO Fringesnew (fringes) VALUES (frng.fringes) 
*ENDSCAN 

*Inserting from one table to another table multiple fields
**********************************************************
Select * from Period into Table Periodnew
*****************************************
Select * From Period into cursor cPrd
Select cPrd
SCAN 
	INSERT INTO Periodnew(monthid,monthname) VALUES (monthid,monthname) 
ENDSCAN

Selec * From Periodnew
close all
dele file Periodnew.dbf

*OK 29/5/2018
*INSERT INTO Periodnew(monthid,monthname) VALUES (cPrd.monthid,cPrd.monthname) 