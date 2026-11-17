**GRPIDAUTO.PRG will see next grpid of the carpets having same issdt,supplier,design,quality and allot no
*!*	Public m.pubGrpID
*!*	Local m.maxGrpID
*!*	Select max(grpid) as maxgrpid;
*!*	From casupord;
*!*	Into Cursor cmaxid

*!*	select cmaxid
*!*	m.maxGrpID=cmaxid->maxgrpid
*!*	if m.maxGrpID>1
*!*		m.pubGrpID=m.maxGrpID+1
*!*	else
*!*		m.pubGrpID=1001
*!*	endif

PUBLIC pubGrpID
LOCAL lnMaxGrpID, lnOldSel

lnOldSel = SELECT()

SELECT MAX(grpid) AS maxgrpid ;
   FROM casupord ;
   INTO CURSOR cmaxid

lnMaxGrpID = NVL(cmaxid.maxgrpid, 0)
USE IN cmaxid

IF m.lnMaxGrpID >= 1001
   m.pubGrpID = m.lnMaxGrpID + 1
ELSE
   m.pubGrpID = 1001
ENDIF

SELECT (lnOldSel)