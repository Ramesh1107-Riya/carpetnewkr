*Updated Carpet if carpetno is available

Set safe off
Set talk off
do test


select ol_no;
From Casupord s,ttcarpetno t;
Where alltrim(s.carpetno)=alltrim(t.carpetno);
Into table updol_no

*A) Cabuyord Updated*(Look for Ol_no)
Close all
USE Cabuyord IN 0
USE Updol_no IN 0
SELECT Updol_no && values come FROM this table 
SCAN
Update Cabuyord;
Set Exported= .T.,Cstatus='Exported';
Where Cabuyord.Ol_no=Updol_no.ol_no
ENDSCAN
Use IN Cabuyord 
USE IN Updol_no
***********************
SELECT ol_no,Exported,cstatus;
From CaBuyord;
Where Exported=.T.

SELECT *;
From Updol_no

*B)***Stkcarpet.dbf (Look for Carpetno)
Close all
USE Stkcarpet IN 0
USE Ttcarpetno IN 0
SELECT Ttcarpetno && values come FROM this table 
SCAN
Update Stkcarpet;
Set Exported= .T.,Cstatus='Exported';
Where Stkcarpet.carpetno=Ttcarpetno.carpetno
ENDSCAN
Use IN Stkcarpet 
USE IN Ttcarpetno

SELECT carpetno,Exported,cstatus;
From Stkcarpet;
Where Exported=.T.

*C)***Update Packtran.dbf cstatus (Look for Carpet No.)
Close all
USE packtran IN 0
USE TTcarpetno IN 0
SELECT Ttcarpetno && values come FROM this table 
SCAN
Update packtran;
Set Cstatus='Exported';
Where packtran.carpetno=Ttcarpetno.carpetno
ENDSCAN
Use IN packtran 
USE IN Ttcarpetno

SELECT carpetno,Exported,cstatus;
From Stkcarpet;
Where cstatus='Exported'