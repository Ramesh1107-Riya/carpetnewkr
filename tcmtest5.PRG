close all
clear
*?sys(3054,11)
*?'***********'
Select t1.ol_no,t2.design,t3.quality,t4.colour,t5.szcode,t6.bcode;
From cabuyordt1 t1;
Left Join Cabuyordt2 t2;
On t1.ol_no=t2.ol_no;
Left Join Cabuyordt3 t3;
On t1.ol_no=t3.ol_no;
Left Join Cabuyordt4 t4;
On t1.ol_no=t4.ol_no;
Left Join Cabuyordt5 t5;
On t1.ol_no=t5.ol_no;
Left Join Cabuyordt6 t6;
On t1.ol_no=t6.ol_no;
Left Join Cabuyordt7 t7;
On t1.ol_no=t7.ol_no
