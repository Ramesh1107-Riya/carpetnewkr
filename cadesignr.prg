Do Case
Case (!empty(m.quality))
	SELECT a.code, a.quality, a.fldtype,b.fieldcode, b.grate_a,b.grate_b, b.grate_c, b.grate_d;
	FROM carpet!cadesign a, carpet!cafield b;
	WHERE  a.fldtype = b.fldtype .AND.  a.quality = b.quality;
	INTO CURSOR ratelst
	
	SELECT *;
	FROM ratelst;
	HAVING quality=m.quality;
	ORDER BY grate_a desc,code,quality,fldtype;
	INTO CURSOR ratelst1

Case (empty(m.quality))  
	SELECT a.code, a.quality, a.fldtype,b.fieldcode, b.grate_a,b.grate_b, b.grate_c, b.grate_d;
	FROM carpet!cadesign a, carpet!cafield b;
 	WHERE  a.fldtype = b.fldtype .AND.  a.quality = b.quality;
	INTO CURSOR ratelst
		
	SELECT *;
	FROM ratelst;
	ORDER BY grate_a desc,code,quality,fldtype;
	INTO CURSOR ratelst1
	
Endcase

SELECT ratelst1
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. Option="A"
		Report form cadesignr.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. Option="B"
		Report form cadesignr.frx to printer prompt noconsole
	Case m.PrnStat="V" .and. Option="E"
		EXPORT TO &exclfile TYPE XL5 FIELDS CODE,FLDTYPE,QUALITY,FIELDCODE,GRATE_A,GRATE_B,GRATE_C,GRATE_D
		Messagebox("Successfuly converted Excel Format, open folder Carpetnew->Search For Excel File")
		
Endcase
Endif
Return