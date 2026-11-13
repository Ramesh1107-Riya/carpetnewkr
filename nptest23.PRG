**Union Stkcarpet and Cabuyord for szcode*********
Select p.ol_no,b.szcode;
From Packtran p,cabuyord b;
where p.ol_no=b.ol_no .and. invno="G21/2017";
into cursor pabuy

Select p.ol_no,b.szcode;
From Packtran p,stkcarpet b;
where p.ol_no=b.ol_no .and. invno="G21/2017";
into cursor pastk

Select ol_no,szcode;
From pabuy;
union all;
Select ol_no,szcode;
From pastk
into cursor stkbuyord
*********end of ********************************






*Select P.carpetno,P.Baleno,p.subbuyer,P.Quality,P.Design,P.Colour,b.szcode,p.sqmt,int(val(p.baleno)) as bale;
*	From Packtran P;
*	Left outer Join cabuyord b;
*		ON p.ol_no=b.ol_no; 
*	Left Outer Join