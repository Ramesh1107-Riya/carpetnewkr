*Purpose: Issue dyed & white yarn to supplier, show stock blance from dyed stock & white stock
*wistockdata, Show Quality,Colour,Netweight for Matching Quality
*Incoming field PSQUALITY, PSCOLOUR
*Calling program wiissue.dbf
*Assumption: Opening entry can either be in white yarn opening->yrnop.dbf [or] in dye yarn opening->wistock.dbf
*1. Check in white Yarn opening
Select Quality,Colour;
From yrnop;
Where QUALITY=PSQUALITY .AND. COLOUR=PSCOLOUR;
Into cursor wyop
Select wyop
IF !(RECNO()>RECCOUNT()) &&IF Record found
	Set Procedure to yarnstk     && White Yarn Stock					
	Do Querygen
	Do Whitestk
	SELECT QUALITY,COLOUR,BALANCE;
	FROM WHTSTOCK;
	WHERE QUALITY=PSQUALITY .AND. COLOUR=PSCOLOUR;
	INTO CURSOR Whtstk
	Select WhtStk
	Pbalance=WhtStk->balance
	Pcomment="White Yarn Issue"
	Pdyewht='W'
ELSE
*2. Check in Dyed Yarn opening
	Select Quality,Colour;
	From wistock;
	Where QUALITY=PSQUALITY .AND. COLOUR=PSCOLOUR;
	Into Cursor dyop
	Select dyop
	IF RECNO()>RECCOUNT() &&IF Record not found empty
		Messagebox("Record Not Found in [White Yarn Opening] or [Dyed Yarn Opening] Please Enter in one of it",16)
	Else  && IF RECORD FOUND
		Do wstk
		Do wrecv
		Do wrtn
		Do wiss
		Select Quality,Colour,sum(openbal+recqty+retnqty-issqty) balance;
		From Wstock;
		Into Cursor Wstock1
		Select Wstock1
		Pbalance=Wstock1->balance
		Pcomment="Dyed Yarn Issue"
		Pdyewht='D'		
	Endif
ENDIF
		****end of program******
		Procedure wstk
		CREATE CURSOR WSTOCK (QUALITY C(10),COLOUR C(10),OPENBAL N(10,3),RECQTY N(11,3),RETNQTY N(11,3),ISSQTY N(11,3))
		SELECT WSTOCK
		APPEND FIELDS QUALITY,COLOUR,OPENBAL FROM WISTOCK FOR QUALITY=PSQUALITY .AND. COLOUR=PSCOLOUR
		RETURN 

		Procedure wrecv
		SELECT QUALITY,COLOUR,SUM(QUANTITY) RECQTY;
		FROM WIRECV;
		WHERE QUALITY=PSQUALITY .AND. COLOUR=PSCOLOUR;
		GROUP BY QUALITY,COLOUR;
		ORDER BY QUALITY,COLOUR;
		INTO CURSOR RECV
		SELECT WSTOCK
		APPEND FIELDS QUALITY,COLOUR,RECQTY FROM DBF ('RECV') FOR QUALITY=PSQUALITY .AND. COLOUR=PSCOLOUR
		RETURN

		Procedure wrtn
		SELECT QUALITY,COLOUR,SUM(QUANTITY) RETNQTY;
		FROM WIRETURN;
		WHERE QUALITY=PSQUALITY .AND. COLOUR=PSCOLOUR .AND. dyewht='D';
		GROUP BY QUALITY,COLOUR;
		ORDER BY QUALITY,COLOUR;
		INTO CURSOR RETN
		SELECT WSTOCK
		APPEND FIELDS QUALITY,COLOUR,RETNQTY FROM DBF ('RETN') FOR QUALITY=PSQUALITY .AND. COLOUR=PSCOLOUR
		RETURN

		Procedure wiss
		SELECT QUALITY,COLOUR,SUM(QUANTITY) ISSQTY;
		FROM WIISSUE;
		WHERE QUALITY=PSQUALITY .AND. COLOUR=PSCOLOUR .AND. dyewht='D';
		GROUP BY QUALITY,COLOUR;
		ORDER BY QUALITY,COLOUR;
		INTO CURSOR ISSUE
		SELECT WSTOCK
		APPEND FIELDS QUALITY,COLOUR,ISSQTY FROM DBF ('ISSUE') FOR QUALITY=PSQUALITY .AND. COLOUR=PSCOLOUR
		RETURN
