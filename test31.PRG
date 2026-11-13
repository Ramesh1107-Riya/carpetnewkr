Local m.Quality
m.Quality='100 ALLO'

Select i.Date, i.Bill, i.Suplier, i.Quality, i.Colour, i.Netwt, PADR('Opn',3) as RCODE;
FROM  yrnop i;
WHERE i.Quality=m.Quality;
union all;
Select j.Date, j.Billno, j.Suplier, j.Quality, j.Colour, j.quantity as Netwt, PADR('Dye',3) as RCODE;
FROM yrnissdy j;
WHERE j.Quality=m.Quality;
union all;
Select l.Recdt, l.Recno, l.Suplier, l.Quality, l.Colour, l.Netwt, PADR('Pur',3) as RCODE;
FROM  yrnrecvd l;
WHERE l.Quality=m.Quality;


