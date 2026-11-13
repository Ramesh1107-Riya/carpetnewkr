*Updating 2 files
Close all
USE availtcm IN 0
USE dcolournot IN 0
select dcolournot && values come FROM this table 
do while .not. eof()
update availtcm  ;
set colour=dcolournot.colour;
Where Alltrim(availtcm.ocolour)=Alltrim(dcolournot.ocolour) 
	Select dcolournot
	If .not. eof()
		skip
	Endif
enddo
USE IN dcolournot
USE IN availtcm 
*****************************
Select * from availtcm
*set silkper=Cadgnsilkpr.silkper,addusd=Cadgnsilkpr.addusd 
*Select Design,Colour,Code,Addusd,Silkper From Cadgnsilkpr 