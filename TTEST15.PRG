select b.*,a.notes as notes2;
From stkcarpet a;
Righ Join tt2019S b;
on a.carpetno=b.carpetno;
order by a.carpetno;
into table tt2019SFNL
