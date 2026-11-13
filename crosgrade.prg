***Cross Table Generating, Max upto 20 Filed, But if field Quality Filed reduced to less than 20 program does not work
***Future Developement required: Ramesh Basnet 15 July,2009, i.e. Limiting & initializing variables less than 20 
*** Now Field is limited to 10

PROCEDURE CARPETCAT
croshead="Grade Categorywise"
SELECT s.Category,s.grade,SUM(s.finsqmt);
 FROM Carpet!casupord s;
 WHERE fdate>=m.Text1 .and. fdate<=m.Text2 .and. !empty(s.Fdate) ;
 GROUP BY s.Category,s.grade;
 ORDER BY s.Category,s.grade;
 INTO CURSOR  RECV
RETURN

PROCEDURE CARPETSUP1
croshead="Quality Supplier"
SELECT Supplier,grade,SUM(finsqmt);
FROM Carpet!casupord ;
WHERE fdate>=m.Text1 .and. fdate<=m.Text2 .and. !empty(Fdate) .and. Supplier=m.Supplier ;
GROUP BY Supplier,grade;
ORDER BY Supplier,grade;
INTO CURSOR  RECV
RETURN	

PROCEDURE CARPETSUP  && This require Category & Quality selection
Do Case
	Case !empty(m.category) .and. !empty(m.quality)
		 Set procedure to catool
		 DO csTrimInfo4      && Trim Information for Check Purpose !
		 Open Database Carpet
	
		 croshead="Quality Supplier"
		 CREATE SQL VIEW REV1 AS SELECT s.Supplier, s.grade, SUM(s.finsqmt), s.Category;
		 FROM Carpet!casupord s, cabuyord b;
		 WHERE b.ol_no=s.ol_no .and. s.fdate>=m.Text1 .and. s.fdate<=m.Text2 .and. !empty(s.fdate) .and. b.quality=m.quality;
		 GROUP BY s.Supplier,s.grade;
		 ORDER BY s.Supplier,s.grade 
		
		 SELECT *;
		 FROM Carpet!REV1;
		 WHERE ccsMatch9(Category);
		 INTO CURSOR RECV
		 
	Case !empty(m.category) .and. empty(m.quality)
		 Set procedure to catool
		 DO csTrimInfo4      && Trim Information for Check Purpose !
		 Open Database Carpet
		 
		 croshead="Quality Supplier"
		 CREATE SQL VIEW REV1 AS SELECT Supplier, grade, SUM(finsqmt), Category;
		 FROM Carpet!casupord;
		 WHERE fdate>=m.Text1 .and. fdate<=m.Text2 .and. !empty(fdate);
		 GROUP BY Supplier,grade;
		 ORDER BY Supplier,grade
		
 		 SELECT *;
		 FROM Carpet!REV1;
		 WHERE ccsMatch9(Category);
		 INTO CURSOR RECV
		 
	Case empty(m.category) .and. !empty(m.quality)
		 croshead="Quality Supplier"
		 SELECT s.Supplier,s.grade,SUM(s.finsqmt);
		 FROM Carpet!casupord s, cabuyord b;
		 WHERE b.ol_no=s.ol_no .and. s.fdate>=m.Text1 .and. s.fdate<=m.Text2 .and. !empty(s.Fdate) .and. b.quality=m.quality  ;
		 GROUP BY s.Supplier,s.grade;
		 ORDER BY s.Supplier,s.grade;
		 INTO CURSOR  RECV		 
		 
	Case empty(m.category) .and. empty(m.quality)
		 croshead="Quality Supplier"
		 SELECT Supplier,grade,SUM(finsqmt);
		 FROM Carpet!casupord ;
		 WHERE fdate>=m.Text1 .and. fdate<=m.Text2 .and. !empty(Fdate) ;
		 GROUP BY Supplier,grade;
		 ORDER BY Supplier,grade;
		 INTO CURSOR  RECV		 
Endcase
RETURN

PROCEDURE CARPETBOTH
*Fix position of field, acutal filed is put in the pos... variables
Private pso1,pos2,pos3,pos4,pos5,pso6,pos7,pos8

Local qltyVar1,qltyVar2,qltyVar3,qltyVar4,qltyVar5,qltyVar6,qltyVar7,qltyVar8
Local qlty1,qlty2,qlty3,qlty4,qlty4,qlty5,qlty6,qlty7,qlty8
Local fldcount,countf
store 0 to fldcount

**Cursor is created to allow filter in any quality
CREATE CURSOR PARTYQLTY (Category C(10),Grade C(1),Sum_Finsqmt N(9,2))

SELECT grade;
 FROM Carpet!cagrade;
 ORDER BY grade;
 INTO CURSOR QLTY

*Creating atlease one dummy record [to make work cross table algo in any condition] which has 0 effect in report
SELECT PARTYQLTY
APPEND FROM DBF('QLTY')
Replace all Category with 'ZZZCATE',Sum_Finsqmt WITH 0

SELECT PARTYQLTY
APPEND FROM DBF('RECV')

SELECT Category,Grade,sum_Finsqmt;
 FROM PartyQlty;
 GROUP BY Category,Grade;
 ORDER BY Category,Grade;
 INTO CURSOR SYS(2015)
 DO (_GENXTAB) WITH 'Query'

select Query
gnFieldcount = AFIELDS(gaMyArray)  && Create array and counts nos of filed in the array
*CLEAR
*FOR nCount = 1 TO gnFieldcount 
*	?gaMyArray(nCount,1)  && Display field names
*ENDFOR
* WHERE Wirecv.date>={^2009/06/01};
*intializing variable with current field value, Total can NOT be captured
*Get field name for heading1,...2,...3 etc, Limitation is 20 fields=1 party=19 CARPET Grade 60K Tib,100K Tib etc.

qlty1=gaMyArray(1,1)  
qlty2=gaMyArray(2,1)
qlty3=gaMyArray(3,1)
qlty4=gaMyArray(4,1)  
qlty5=gaMyArray(5,1)
qlty6=gaMyArray(6,1)
qlty7=gaMyArray(7,1)  
qlty8=gaMyArray(8,1)  


*get local var value local var by removing 1st two char from field name that is not required 
*for heading for field len >5
qltyvar1=qlty1 && as it is ok
qltyvar2=qlty2
qltyvar2=RIGHT(qlty2,iif(LEN(qlty2)>5,LEN(qlty2)-0,LEN(qlty2))) && this is original version kept intack
qltyvar3=RIGHT(qlty3,iif(LEN(qlty3)>5,LEN(qlty3)-0,LEN(qlty3)))
qltyvar4=RIGHT(qlty4,iif(LEN(qlty4)>5,LEN(qlty4)-0,LEN(qlty4)))
qltyvar5=RIGHT(qlty5,iif(LEN(qlty5)>5,LEN(qlty5)-0,LEN(qlty5)))
qltyvar6=RIGHT(qlty6,iif(LEN(qlty6)>5,LEN(qlty6)-0,LEN(qlty6)))
qltyvar7=RIGHT(qlty7,iif(LEN(qlty7)>5,LEN(qlty7)-0,LEN(qlty7)))
qltyvar8=RIGHT(qlty8,iif(LEN(qlty8)>5,LEN(qlty8)-0,LEN(qlty8)))

**Fix the postion of data Headings (Fields),fields arranged in report order 1,16,15,14,18,19.20,7,3,4,6,5,12,11...
** For Carpet normal position 1,2,3,4...
pos1=qltyvar1
pos2=qltyvar2
pos3=qltyvar3
pos4=qltyvar4
pos5=qltyvar5
pos6=qltyvar6
pos7=qltyvar7
pos8=qltyvar8

Select Query
DELETE FOR Category="ZZZCATE"
SET COLOR TO 
*If RECNO()>RECCOUNT()
*	Messagebox("Record Not Found for the above seletion!!!")
*Else
Do Case
	Case m.PrnStat="V"
		Report form crosgrade.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form crosgrade.frx to printer prompt noconsole
Endcase
*Endif
RETURN

PROCEDURE CARPETBOTH2
*Fix position of field, acutal filed is put in the pos... variables
Private pso1,pos2,pos3,pos4,pos5,pso6,pos7,pos8

Local qltyVar1,qltyVar2,qltyVar3,qltyVar4,qltyVar5,qltyVar6,qltyVar7,qltyVar8
Local qlty1,qlty2,qlty3,qlty4,qlty5,qlty6,qlty7,qlty8

Local fldcount,countf
store 0 to fldcount

**Cursor is created to allow filter in any Grade
CREATE CURSOR PARTYQLTY (Supplier C(15),Grade C(1),Sum_Finsqmt N(9,2), Category C(10))
 SELECT Grade;
 FROM Carpet!cagrade;
 ORDER BY Grade;
 INTO CURSOR QLTY

*Creating atlease one dummy record [to make work cross table algo in any condition] which has 0 effect in report
SELECT PARTYQLTY
APPEND FROM DBF('QLTY')
Replace all Supplier with 'ZZZCATE',Sum_Finsqmt WITH 0

SELECT PARTYQLTY
APPEND FROM DBF('RECV')

SELECT Supplier,Grade,sum_Finsqmt;
 FROM PartyQlty;
 GROUP BY Supplier,Grade;
 ORDER BY Supplier,Grade;
 INTO CURSOR SYS(2015)
 DO (_GENXTAB) WITH 'Query'

select Query
gnFieldcount = AFIELDS(gaMyArray)  && Create array and counts nos of filed in the array
*CLEAR
*FOR nCount = 1 TO gnFieldcount 
*	?gaMyArray(nCount,1)  && Display field names
*ENDFOR
* WHERE Wirecv.date>={^2009/06/01};
*intializing variable with current field value, Total can NOT be captured
*Get field name for heading1,...2,...3 etc, Limitation is 20 fields=1 party=19 CARPET Grade 60K Tib,100K Tib etc.

qlty1=gaMyArray(1,1)  
qlty2=gaMyArray(2,1)
qlty3=gaMyArray(3,1)
qlty4=gaMyArray(4,1)  
qlty5=gaMyArray(5,1)
qlty6=gaMyArray(6,1)
qlty7=gaMyArray(7,1)  
qlty8=gaMyArray(8,1)  



*get local var value local var by removing 1st two char from field name that is not required 
*for heading for field len >5
qltyvar1=qlty1 && as it is ok
qltyvar2=qlty2
qltyvar3=RIGHT(qlty3,iif(LEN(qlty3)>5,LEN(qlty3)-0,LEN(qlty3)))&& this is original version kept intack
qltyvar4=RIGHT(qlty4,iif(LEN(qlty4)>5,LEN(qlty4)-0,LEN(qlty4)))
qltyvar5=RIGHT(qlty5,iif(LEN(qlty5)>5,LEN(qlty5)-0,LEN(qlty5)))
qltyvar6=RIGHT(qlty6,iif(LEN(qlty6)>5,LEN(qlty6)-0,LEN(qlty6)))
qltyvar7=RIGHT(qlty7,iif(LEN(qlty7)>5,LEN(qlty7)-0,LEN(qlty7)))
qltyvar8=RIGHT(qlty8,iif(LEN(qlty8)>5,LEN(qlty8)-0,LEN(qlty8)))

**Fix the postion of data Headings (Fields),fields arranged in report order 1,16,15,14,18,19.20,7,3,4,6,5,12,11...
** For Carpet normal position 1,2,3,4...
pos1=qltyvar1
pos2=qltyvar2
pos3=qltyvar3
pos4=qltyvar4
pos5=qltyvar5
pos6=qltyvar6
pos7=qltyvar7
pos8=qltyvar8

Select Query
DELETE FOR Supplier="ZZZCATE"
SET COLOR TO
*If RECNO()>RECCOUNT()
*	Messagebox("Record Not Found for the above seletion!!!")
*Else
Do Case
	Case m.PrnStat="V"
		Report form crosgrades.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form crosgrades.frx to printer prompt noconsole
Endcase
*Endif
RETURN





