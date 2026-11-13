select s.carpetno,s.ol_no;
From oldstk s, stkcarpet b;
Where  s.carpetno=b.carpetno;
into cursor stk4


UPDATE oldstk;
Set Delclose=.T.;
Where Ol_No IN(Select Ol_No From stk4)


