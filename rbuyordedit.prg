SET DELETED ON
Set Date to Briti
Set Century off
SET SAFE OFF
SET TALK OFF
SET ANSI ON

SET PROCEDURE TO Catool
DO csTrimInfo      && Trim Information for Check Purpose !
*Open Database Carpet shared

IF m.DoNotSrchExp=.T. && exclude Exported Carpet
	SELECT BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, WASHTYPE, SPCL_INST, CSTATUS, CTYPE, NOTES;
	From cabuyord;	
	WHERE cstatus<>"Exported";
	Into Cursor temprepview1 
ELSE && Search All including Exported Carpet Also
	SELECT BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, WASHTYPE, SPCL_INST, CSTATUS, CTYPE, NOTES;
	From buyordview;	
	WHERE cstatus<>"Exported";
	Into Cursor temprepview1 
ENDIF

SELECT OL_NO;
FROM temprepview1;
WHERE ccsMatch12(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, FIELDCODE, WASHTYPE, SPCL_INST, CSTATUS, CTYPE, NOTES);
ORDER BY PO_NO,OL_NO ASC;
Into Cursor temp7

SELECT Casupord
Replace all recd with .F.
GO TOP

UPDATE Carpet!Casupord;
SET RECD=.T.;
WHERE Card_no IN (SELECT Card_no FROM RcdWea)


RETURN
* EoP()
