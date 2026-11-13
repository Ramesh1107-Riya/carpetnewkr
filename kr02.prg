close all
m.carpetno="RH-7873"
SELECT s.CARPETNO,s.DESIGN,s.QUALITY,s.COLOUR,s.breadth,s.length,s.sqmt,s.Amt,d.matcomp;
FROM  Stkcarpet s;
Join caDesign d;
ON s.Design=d.code;
Where carpetno=m.Carpetno
