Set talk off
set safe off
SELECT Distinc carpetno as ol_no;
From yrnissrecsup;
Where !empty(ibillno) .and. carpetno="190913/03018";
Order by carpetno

*Into cursor Cabuyordsel


SELECT *;
From yrnissrecsup;
Where !empty(ibillno) .and. carpetno="190913/03018";
Order by carpetno
