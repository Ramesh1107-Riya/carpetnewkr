SET DELETED ON
SET TALK OFF
SET SAFE OFF

IF !EMPTY(m.OL_NO)
	SELECT i.DATE,i.BILLNO,i.SLIPNO,i.QUALITY,i.PARTY,i.COLOUR,i.RATE,SUM(i.QUANTITY) AS quantity,i.AMT,i.OL_NO,j.design,i.GrpID;
	FROM WIISSUE i;
	Join CABUYORD j;
	ON i.OL_NO=j.OL_NO;
	WHERE i.OL_NO==Alltrim(m.OL_NO);
	ORDER BY i.Quality,i.Colour;
	GROUP BY i.Quality,i.Colour;
	INTO CURSOR ISS1

	SELECT DISTINCT OL_NO;  &&This will display single ol_NO
	FROM WIISSUE;
	WHERE OL_NO==Alltrim(m.OL_NO);
	INTO CURSOR temp2
	
	Select temp2
	Dimension cardolno(20,1) && array is declared row=20,col=1
	Store '' to cardolno && initialize array with '', by default .F.
	Copy to Array Cardolno FIELDS Ol_no
Else
	SELECT i.DATE,i.BILLNO,i.SLIPNO,i.QUALITY,i.PARTY,i.COLOUR,i.RATE,SUM(i.QUANTITY) AS quantity,i.AMT,i.OL_NO,j.design,i.GrpID;
	FROM WIISSUE i;
	Join CABUYORD j;
	ON i.OL_NO=j.OL_NO;
	WHERE i.Billno==Alltrim(m.BillNo);
	ORDER BY i.Quality,i.Colour;
	GROUP BY i.Quality,i.Colour;
	INTO CURSOR ISS1


	SELECT DISTINCT OL_NO;  &&This will display max 12 ol_nos
	FROM WIISSUE;
	WHERE Billno==Alltrim(m.BillNo);
	INTO CURSOR temp2
	
	Select temp2
	Dimension cardolno(20,1) && array is declared row=20,col=1
	Store '' to cardolno && initialize array with '', by default .F.
	Copy to Array Cardolno FIELDS Ol_no
Endif


SELECT ISS1
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form wibilliss.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport	
	Case m.PrnStat="P"
		Report form wibilliss.frx to printer prompt noconsole
Endcase
Endif
RETURN

