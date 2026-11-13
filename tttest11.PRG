Close all
USE Cabuyord IN 0
USE Packtran IN 0
select Packtran && values come FROM this table 
scan
update Cabuyord ;
set cstatus='Packed';
Where Packtran.ol_no=Cabuyord.ol_no .and. Packtran.invno='TFK-17/2019'
endscan
USE IN Cabuyord
USE IN Packtran
***********************
*Select Ol_no,cstatus from Cabuyord where cstatus='Packed'