Select P.Baleno,p.subbuyer,P.Quality,P.Design,P.Colour,b.szcode,count(szcode) as nopcs,sum(p.sqmt) as sqmt;
From Packtran P,cabuyord b;
where p.ol_no=b.ol_no .and. p.invno='G22/2017';
Order BY p.subbuyer,p.QUALITY,p.DESIGN,p.COLOUR,b.szcode;
Group by subbuyer,p.quality,szcode,p.design,p.colour;
Into Table packsmry

Select P.Baleno,p.subbuyer,P.Quality,P.Design,P.Colour,b.szcode,p.sqmt,int(val(p.baleno)) as bale;
From Packtran P,cabuyord b;
where p.ol_no=b.ol_no .and. p.invno='G22/2017';
Order BY p.subbuyer,p.QUALITY,p.DESIGN,p.COLOUR,b.szcode;
Into cursor packsm1


Select bale,Subbuyer,quality,design,colour,szcode,sqmt;
From packsm1;
order by subbuyer,QUALITY,DESIGN,COLOUR,bale,szcode

