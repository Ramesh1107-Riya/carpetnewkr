*Updating 2 files
Close all
USE Yrnissrecsup IN 0
USE Available IN 0
select Available && values come FROM this table 
do while .not. eof()
update Yrnissrecsup ;
set Label=.T.;
Where Yrnissrecsup.carpetno=Available.carpetno
	Select Available
	If .not. eof()
		skip
	Endif
enddo
USE IN Yrnissrecsup
USE IN Available
*****************************
