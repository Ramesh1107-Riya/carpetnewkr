*Updating 2 files
Close all
USE Packtran IN 0
USE pptcm IN 0
select pptcm && values come FROM this table 
do while .not. eof()
update Packtran ;
set Packtran.invno=pptcm.invno;
Where packtran.carpetno=pptcm.carpetno
	Select pptcm
	If .not. eof()
		skip
	Endif
enddo
USE IN Packtran
USE IN pptcm
*****************************
Select p.invno,t.invno as invno1,p.comment,p.carpetno,p.datetime,p.remark;
From Packtran p, pptcm t;
Where p.carpetno=t.carpetno

