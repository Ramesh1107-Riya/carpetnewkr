*Updating 2 files
Close all
USE Packtran IN 0
USE TCMPACK IN 0
select Tcmpack && values come FROM this table 
do while .not. eof()
update Packtran ;
set Packtran.invno=Tcmpack.invno;
Where packtran.carpetno=tcmpack.carpetno
	Select Tcmpack
	If .not. eof()
		skip
	Endif
enddo
USE IN Packtran
USE IN Tcmpack
*****************************
Select p.invno,t.invno as invno1,p.comment,p.carpetno,p.datetime,p.remark;
From Packtran p, Tcmpack t;
Where p.carpetno=t.carpetno

