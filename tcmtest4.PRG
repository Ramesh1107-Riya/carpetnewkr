close all
Select b.*;
From Cabuyord b,pptcm p;
Where b.ol_no=p.ol_no;
Into Cursor buy1

Select b.*,p.*;
From Casupord b,buy1 p;
Where b.ol_no=p.ol_no

SELECT i.*;
FROM pptcm i;
WHERE .NOT. EXISTS (SELECT ol_no FROM Cabuyord p;
					WHERE p.ol_no=i.ol_no);
Into table notinbuy1

use notinbuy1
brow

