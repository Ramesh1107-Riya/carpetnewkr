CLOSE ALL
Open Database carpet exclusive
validate database
clea
set procedure to catool
Public m.FileLocked
m.FileLocked=.F.
Use cabuyord in select(0) alias cabuyord exclusive
SET ORDER TO OL_NO
Use Packtran in select(0) alias Packtran exclusive
index on ol_no to ol_no
set order to ol_no
if !(m.FileLocked)
	UPDATE Cabuyord ;
	Set Exported=.T., CStatus="Exported";
	Where OL_NO IN (SELECT OL_NO FROM PACKTRAN)
else
	@ 11,63 say "Cabuyord File is Bussy"
Endif

Use Casupord in select(0) alias Casupord exclusive
if !(m.FileLocked)
	UPDATE Stkcarpet;
	Set Exported=.T., CStatus="Exported";
	Where OL_NO IN (SELECT OL_NO FROM PACKTRAN)
else
	@ 11,63 say "Cabuyord File is Bussy"
Endif