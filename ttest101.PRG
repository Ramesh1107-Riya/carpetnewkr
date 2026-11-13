Select i.carpetno,j.carpetno as stkcarpet,i.ol_no;
From CaSupord i;
Join Stkcarpet j;
On i.ol_no=j.ol_no