use cabuyord IN 1
SCAN
SELEC CABUYORD
If bcode="PR" .OR. bcode="HC" .OR. bcode="AJ" .OR. bcode="AK" .OR. bcode="TB" .OR. bcode="RS" .OR. bcode="HR" .OR.  bcode="DP" .OR. bcode="MS" 
	repl washtype with "P-RUG"
Else
	repl washtype with "K-RUG"
ENDIF
ENDSCAN

CLOSE ALL
SELECT DISTINC BCODE,WASHTYPE FROM CABUYORD ORDER BY WASHTYPE