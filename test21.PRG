SELECT  *;
FROM oldstk;
Where .NOT. EXISTS(Select * From CASIZE Where CASIZE.SZCODE=oldstk.SZCODE)
