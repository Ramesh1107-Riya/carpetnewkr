
SELECT s.carpetno,s.ol_no;
FROM oldstk i,stkcarpet s;
Where  i.carpetno=s.carpetno;

SELECT s.carpetno,s.ol_no;
FROM oldstk i,packtran s;
Where  i.carpetno=s.carpetno;

select s.carpetno,s.ol_no,b.cstatus;
From oldstk s, cabuyord b;
Where  s.ol_no=b.ol_no
*into cursor cstk1


*Update oldstk;
*Set Delclose=.T.;
*Where Ol_No IN(Select Ol_No From cstk1)
