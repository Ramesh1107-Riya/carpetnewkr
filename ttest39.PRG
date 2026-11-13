Select Distinc Design,Quality,szcode,count(Design);
From Cabuyord;
Group by Design,Quality,Szcode;
Where Order_type="REGULAR" .or. Order_type="SAMPLE";
Into Cursor Dgn

Select Distinc Design,Count(Design) as ctn;
From Dgn;
Group by Design;
Into Cursor Dgn1

Select Design,ctn;
From Dgn1;
Where ctn>=5;
Order by Design,Ctn 

