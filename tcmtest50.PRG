SELECT *;
FROM TEST2A;
WHERE .NOT. EXISTS (SELECT * FROM Available;
					WHERE Test2a.carpetno=Available.carpetno .and. Test2a.pno=Available.pno)
					
Select i.carpetno,i.pno,i.quality,i.colour,i.sretqty,j.pno as pno1,j.sretqty as sretqty1;
From Test2a i;
Left Join Available j;
On i.carpetno=j.carpetno .and. i.pno=j.pno;

Select * From test2a
Select * From Available