*Updating 2 files
Close all
USE availtcm IN 0
USE dqltygrpnot IN 0
select dqltygrpnot && values come FROM this table 
do while .not. eof()
update availtcm  ;
set qltygroup=dqltygrpnot.qltygroup;
Where Alltrim(availtcm.oqltygroup)=Alltrim(dqltygrpnot.oqltygroup) 
	Select dqltygrpnot
	If .not. eof()
		skip
	Endif
enddo
USE IN dqltygrpnot
USE IN availtcm 
*****************************
Select * from availtcm
*set silkper=Cadgnsilkpr.silkper,addusd=Cadgnsilkpr.addusd 
*Select Design,qltygroup,Code,Addusd,Silkper From Cadgnsilkpr 