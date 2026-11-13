*Grsearchrcd.prg**Graph Recd Search***
SET DELETED ON
SET TALK OFF
SET SAFE OFF
*SET PROCEDURE TO Catool
Public mrecno
mrecno=0
DO grTrimInfo15A      && Trim Information for Check Purpose !
Open Database Carpet shared

	SELECT OL_NO,PO_NO,BCODE,DESIGN,SZCODE,SQMT,QUALITY,KNOTS,MASTCOPY,NAME,REMARK,ISUSLIP,ISSDT,RSLIP,GRLASTDT,RCDDATE,RCDDATE-ISSDT AS LATEDAYS,DAYS,RATE,GraphType,Laters,GrPaid,WashType;
 	FROM Graphord; 
 	WHERE ccsMatch21(BCODE,DESIGN,SZCODE,QUALITY,KNOTS,MASTCOPY,NAME,REMARK,ISUSLIP,RSLIP,OL_NO,WASHTYPE) .and. RCDDATE>=m.Startdt .and. RCDDATE<=m.Enddt;
 	Into Cursor Gord2
 
 	SELECT OL_NO,PO_NO,BCODE,DESIGN,SZCODE,SQMT,QUALITY,KNOTS,MASTCOPY,NAME,REMARK,ISUSLIP,ISSDT,RSLIP,GRLASTDT,RCDDATE,iif(Latedays>Days,Latedays-Days,000) as Latedays,Laters,DAYS,RATE,GraphType,GrPaid,WashType;
 	FROM Gord2; 
 	ORDER BY ol_no ASC;
 	Into Cursor Gord1
 	
 	SELECT OL_NO,PO_NO,BCODE,DESIGN,SZCODE,SQMT,QUALITY,KNOTS,MASTCOPY,NAME,REMARK,ISUSLIP,ISSDT,RSLIP,RCDDATE,GRLASTDT,Latedays,Laters,Rate,Round(Latedays*Sqmt*laters,2) as Lamt,DAYS,RATE*Sqmt as Amt,GraphType,GrPaid,WashType;
 	FROM Gord1; 
 	ORDER BY ol_no ASC;
 	Into Cursor Gord
 	
*******UPdate Paid Stattus************************
IF(puPaidUpdate=.T.) && defined in INIT OF the Form
	Update Graphord;
	Set GrPaid=.T.;
	Where OL_NO IN (SELECT OL_NO FROM Gord)
	puPaidUpdate=.F.
Endif	
*********Revert Paid
IF(puPaidRevert=.T.) && defined in INIT of the Form
	Update  Graphord;
	Set GrPaid=.F.;
	Where OL_NO IN (SELECT OL_NO FROM Gord)
	puPaidRevert=.F.
Endif	
**************************************************
***Date Min and Max for Bill Made
Private m.StartDt,m.EndDt
Select Min(RCDDATE) as Min_Date from  Gord into cursor mindate
select mindate
m.StartDt=mindate->Min_Date
Select max(RCDDATE) as Max_Date from  Gord into cursor maxdate 
select maxdate
m.EndDt=maxdate->Max_Date
********************************************
 	
Select Gord
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form grsearchrcd.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form grsearchrcd.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS OL_NO,OL_NO,BCODE,DESIGN,SZCODE,QUALITY,KNOTS,MASTCOPY,NAME,ISUSLIP,ISSDT,RSLIP,GRLASTDT,RCDDATE,RATE,LATEDAYS,LAMT,AMT,GraphType,Laters,REMARK,Washtype
		Messagebox("Graph Order/ Received, Search Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Case  m.PrnStat="V" .and. m.Option="C" && Viw Edit
		DO VIEWEDIT
	Endcase
Endif
Return

******************************************new program start**************
PROCEDURE VIEWEDIT
Private m.coVar1, m.ol_no, srchcall
srchcall=.T.

SET COLOR OF SCHEME 9 TO ;
    W+/BG, W+/BG, B/BG, GR+/W, GR+/B, W+/GR, W+/B, N+/N, GR+/W, N+/W, +

SELECT *;
FROM Graphord;
INTO CURSOR botCursor
?? CHR(7)
WAIT WINDOW ALLTRIM(STR(RECCOUNT("botCursor"))) + " Matching Records Found !" NOWAIT
SELECT botCursor
GO TOP
DEFINE WINDOW cosSrchWn_ FROM 5.5,00 TO 45,120 IN SCREEN DOUBLE CLOSE FLOAT GROW ZOOM MDI ;
	 TITLE "[Order Searched by Criteria / [ESC] to Exit ]" 
ON KEY LABEL F10 KEYBOARD CHR(23)
BROWSE FIELDS OL_NO,PO_NO,BCODE,DESIGN,SZCODE,QUALITY,KNOTS,MASTCOPY,NAME,ISUSLIP,ISSDT,RSLIP,GRLASTDT,RCDDATE,REMARK NOAPPEND NODELETE NOEDIT NOMENU;  && NOMENU TIMEOUT 15
  TITLE "Matching Graph with Search, Select by Arrow key and press [F10] to EDIT / [ESC] to Exit" WINDOW cosSrchWn_ ;
  COLOR SCHEME 9
m.coVar1  = LASTKEY()
m.ol_no=ol_no
ON KEY LABEL F10
USE IN botCursor

*****************************************************8
SELECT Graphord
IF m.coVar1 = 23   && F10 Pressed: Point to the Same Record !    (ON KEY LABEL ENTER    KEYBOARD CHR(13))
  SET ORDER TO  ol_no
  Locate for ol_no=m.ol_no
  IF (.NOT. FOUND())
    ?? CHR(7)
    WAIT WINDOW "This Record is Just Deleted by Another User !!!" TIMEOUT 3
  ELSE
  	 mrecno=recno()
 	Do Form graphrcd
	ENDIF
ENDIF
RELEASE WINDOW cosSrchWn_
RETURN
* EoP()
