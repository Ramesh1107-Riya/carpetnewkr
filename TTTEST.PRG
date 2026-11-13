select po_no,baleno,design,QUALITY,SUM(sqmt) AS SQMT,count(Design) as dcount;
from packtran;
where invno='TFK-24/18';
GROUP BY pO_NO,DESIGN;
ORDER BY PO_NO
*MODI COMM TTTEST
select carpetno,po_no,baleno,design,QUALITY;
from packtran;
where invno='TFK-24/18' .AND. PO_NO='9440';
order by carpetno