select s.carpetno,s.ol_no;
From oldstk s, casupord b;
Where  s.carpetno=b.carpetno;
into cursor stk2
return

close all
USE stk2 IN 0
USE oldstk IN 0
brow
select stk2 && values come FROM this table 
scan
update oldstk ;
Set Delclose=.T. ;
Where oldstk.ol_no=stk2.Ol_no
endscan
USE IN stk2
USE IN oldstk



   	 	UPDATE Cabuyord;
   	 	Set Delclose=.T.;
   	 	Where Ol_No IN(Select Ol_No From Packmark)