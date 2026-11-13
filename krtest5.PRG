Select Invno,count(carpetno) as Pcs,PO_NO,Alltrim(Quality)+'....'+Alltri(Matcomp) as Description,sum(Sqmt) as Sqmt,Round(sum(SqFt),1) as SqFt,RateFeet,RateSqmt;
FROM Packtran p;
Where alltrim(invno)='NAJ/008/20';
Group by Po_no,Rcode,Quality;
Order by PO_NO;
Into Cursor Invoice1

Select Distinct Po_No;
From Invoice1;
Order by Po_No;
Into Cursor InvPono


Dimension pono(1,3)
Store ' ' to pono
Select InvPono
copy to ARRAY pono
?pono(1,1)
?pono(1,2)
?pono(1,3)
