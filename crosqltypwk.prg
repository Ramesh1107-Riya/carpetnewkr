* Cross Table of Weekly Purchase Report
*cdow(s.fdate) as Weekday
Set Deleted ON
Set Date to Briti
Set Safe Off

SELECT dow(s.fdate) as Wkno,b.quality,s.FinSqmt as Sqmt;
FROM casupord s, cabuyord b;
WHERE b.ol_no=s.ol_no ;
Having s.fdate>=m.Text1 .and. s.fdate<=m.Text2 ; 
ORDER BY b.quality;
INTO CURSOR RECV1

SELECT r.wkno,r.quality,r.Sqmt,w.Weekday;
FROM RECV1 r,WEEKDAYS w;
WHERE r.wkno=w.wkno;
INTO CURSOR RECV2

SELECT Weekday,wkno,quality,sum(Sqmt) as Sqmt;
FROM RECV2;
ORDER BY quality;
GROUP BY Weekday,Quality;
INTO CURSOR RECV

*Fix position of field, acutal filed is put in the pos... variables
Private pso1,pos2,pos3,pos4,pos5,pso6,pos7,pos8
Local qltyVar1,qltyVar2,qltyVar3,qltyVar4,qltyVar5,qltyVar6,qltyVar7,qltyVar8
Local qlty1,qlty2,qlty3,qlty4,qlty4,qlty5,qlty6,qlty7,qlty8
Local fldcount,countf
store 0 to fldcount
**Cursor is created to allow filter in any quality
CREATE CURSOR PARTYQLTY1 (Weekday C(9),Quality C(12),sqmt N(9,2))

SELECT WEEKDAY FROM WEEKDAYS INTO CURSOR WKDAY
*Creating atlease one dummy record [to make work cross table algo in any condition] which has 0 effect in report
SELECT PARTYQLTY1
APPEND FROM DBF('WKDAY')
Replace all Quality with 'ZZZCATE',sqmt WITH 0


SELECT PARTYQLTY1
APPEND FROM DBF('RECV')

SELECT Quality,WeekDay,sum(sqmt) as Sqmt;
 FROM PartyQlty1;
 GROUP BY WeekDay,quality;
 ORDER BY quality;
 INTO CURSOR SYS(2015)
 DO (_GENXTAB) WITH 'Query1'
Select Query1

gnFieldcount = AFIELDS(gaMyArray)  && Create array and counts nos of filed in the array
qlty1=gaMyArray(1,1)  
qlty2=gaMyArray(2,1)
qlty3=gaMyArray(3,1)
qlty4=gaMyArray(4,1)  
qlty5=gaMyArray(5,1)
qlty6=gaMyArray(6,1)
qlty7=gaMyArray(7,1)  

*get local var value local var by removing 1st two char from field name that is not required 
*for heading for field len >5
qltyvar1=qlty1 && as it is ok
qltyvar2=qlty2
qltyvar3=qlty3
qltyvar4=qlty4
qltyvar5=qlty5
qltyvar6=qlty6
qltyvar7=qlty7

**Fix the postion of data Headings (Fields),fields arranged in report order 1,16,15,14,18,19.20,7,3,4,6,5,12,11...
** For Carpet normal position 1,2,3,4...
pos1=qltyvar1
pos2=qltyvar2
pos3=qltyvar4
pos4=qltyvar3
pos5=qltyvar6
pos6=qltyvar7
pos7=qltyvar5

Select Query1
DELETE FOR Quality="ZZZCATE"
SET COLOR TO
*If RECNO()>RECCOUNT()
*	Messagebox("Record Not Found for the above seletion!!!")
*Else
Do Case
	Case m.PrnStat="V"
		Report form crosqltypwk.frx to console preview in screen
	Case m.PrnStat="P"
		Report form crosqltypwk.frx to printer prompt noconsole
Endcase
*Endif
RETURN
