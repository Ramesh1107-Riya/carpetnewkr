*Update casupord;
*Set WshSupplier='GYTSO WASHING';
*Where !empty(Issdtwash)

UPDATE Casupord;
SET Billno='1000',PaidStatus=.T.,PaidDate=Date();
WHERE Fdate<={^2018/12/31} .AND. !EMPTY(fdate)
close all

select ol_no,carpetno,fdate,billno;
From Casupord;
Where billno='1000'