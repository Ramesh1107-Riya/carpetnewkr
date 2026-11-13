*Updating 2 files
Close all
USE availtcm IN 0
USE Cadgnsilkpr IN 0
select Cadgnsilkpr && values come FROM this table 
do while .not. eof()
update Cabuyord ;
set silkper=Cadgnsilkpr.silkper,addusd=Cadgnsilkpr.addusd;
Where Alltrim(Cabuyord.Design)=Alltrim(Cadgnsilkpr.Design) .and. Alltrim(Cabuyord.Quality)=Alltrim(Cadgnsilkpr.Code);
 .and. Alltrim(Cabuyord.Colour)=Alltrim(Cadgnsilkpr.Colour)
	Select Cadgnsilkpr
	If .not. eof()
		skip
	Endif
enddo
USE IN Cabuyord
USE IN Cadgnsilkpr
*****************************
Select Design,Colour,Quality,qltyusd,Addusd,Silkper From Cabuyord where silkper>0 order by Design
*set silkper=Cadgnsilkpr.silkper,addusd=Cadgnsilkpr.addusd 
*Select Design,Colour,Code,Addusd,Silkper From Cadgnsilkpr 