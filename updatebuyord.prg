********************************************************************************
procedure __RI_UPDATE_cabuyord
** "Referential integrity update trigger for" cabuyord
LOCAL llRetVal
llRetVal = .t.
PRIVATE pcParentDBF,pnParentRec,pcChildDBF,pnChildRec,pcParentID,pcChildID
PRIVATE pcParentExpr,pcChildExpr
STORE "" TO pcParentDBF,pcChildDBF,pcParentID,pcChildID,pcParentExpr,pcChildExpr
STORE 0 TO pnParentRec,pnChildRec
IF _triggerlevel=1 
	IF YesUpdate="Y" && CODE ADDED FOR UPDATING CSTATUS IN CABUYORD ON 29/6/2010 DEFINED IN MAIN.PRG
		RETURN       && Done by Ramesh Basnet to allow updation 
	 ENDIF
  BEGIN TRANSACTION
  
Endif