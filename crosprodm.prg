***Cross Table Generating, Max upto 20 Field, But if field Quality Field reduced to less than 20 program does not work
***Future Developement required: Ramesh Basnet 15 July,2009, i.e. Limiting & initializing variables less than 20 
*** Now Field is limited to 11

croshead="Quality Monthwise Production"
Open Database Carpet

SELECT s.fdate,b.Quality,SUM(s.finsqmt) fsqmt;  && this is copied modify
FROM Carpet!casupord s, cabuyord b;
WHERE b.ol_no=s.ol_no .and. s.fdate>=m.Text1 .and. s.fdate<=m.Text2 .and. !empty(s.Fdate); 
GROUP BY s.fdate,b.Quality;
ORDER BY s.fdate,b.Quality;
INTO CURSOR  RECV1		

SELECT p.monthname, r.quality, sum(r.fsqmt) fsqmt, p.monthid;
FROM period p, RECV1 r;
WHERE  month(r.fdate)=p.monthid;
GROUP BY p.monthid,r.quality;
ORDER BY p.monthid,r.quality;
INTO CURSOR  RECV

*Fix position of field, acutal filed is put in the pos.mo.. variables
Private pso1,pos2,pos3,pos4,pos5,pso6,pos7,pos8,pos9,pos10,pos11

Local qltyVar1,qltyVar2,qltyVar3,qltyVar4,qltyVar5,qltyVar6,qltyVar7,qltyVar8,qltyVar9,qltyVar10,qltyVar11

Local qlty1,qlty2,qlty3,qlty4,qlty5,qlty6,qlty7,qlty8,qlty9,qlty10,qlty11

Local fldcount,countf
store 0 to fldcount

**Cursor is created to allow filter in any quality
CREATE CURSOR PARTYQLTY (monthname C(10),Quality C(12),fsqmt N(9,2))

SELECT code quality;
 FROM Carpet!caqlty;
 ORDER BY code;
 INTO CURSOR QLTY

*Creating atlease one dummy record [to make work cross table algo in any condition] which has 0 effect in report
SELECT PARTYQLTY
APPEND FROM DBF('QLTY')
Replace all monthname with 'ZZZ',fsqmt WITH 0


SELECT PARTYQLTY
APPEND FROM DBF('RECV')

SELECT i.monthname, i.quality, i.fsqmt;
 FROM PartyQlty i;
 ORDER BY i.quality;
 INTO CURSOR SYS(2015)
 DO (_GENXTAB) WITH 'Query'

select Query
gnFieldcount = AFIELDS(gaMyArray)  && Create array and counts nos of filed in the array

* GROUP BY i.monthid,i.quality;

*CLEAR
*FOR nCount = 1 TO gnFieldcount 
*	?gaMyArray(nCount,1)  && Display field names
*ENDFOR
* WHERE Wirecv.date>={^2009/06/01};
*intializing variable with current field value, Total can NOT be captured
*Get field name for heading1,...2,...3 etc, Limitation is 20 fields=1 party=19 CARPET quality 60K Tib,100K Tib etc.

qlty1=gaMyArray(1,1)  
qlty2=gaMyArray(2,1)
qlty3=gaMyArray(3,1)
qlty4=gaMyArray(4,1)  
qlty5=gaMyArray(5,1)
qlty6=gaMyArray(6,1)
qlty7=gaMyArray(7,1)  
qlty8=gaMyArray(8,1)
qlty9=gaMyArray(9,1)
qlty10=gaMyArray(10,1)
qlty11=gaMyArray(11,1)

*get local var value local var by removing 1st two char from field name that is not required 
*for heading for field len >5
qltyvar1=qlty1 && as it is ok
qltyvar2=SUBSTR(qlty2,3)
qltyvar3=SUBSTR(qlty3,3)
qltyvar4=RIGHT(qlty4,iif(LEN(qlty4)>5,LEN(qlty4)-0,LEN(qlty4)))&& this is original version kept intack
qltyvar5=RIGHT(qlty5,iif(LEN(qlty5)>5,LEN(qlty5)-0,LEN(qlty5)))
qltyvar6=RIGHT(qlty6,iif(LEN(qlty6)>5,LEN(qlty6)-0,LEN(qlty6)))
qltyvar7=RIGHT(qlty7,iif(LEN(qlty7)>5,LEN(qlty7)-0,LEN(qlty7)))
qltyvar8=RIGHT(qlty8,iif(LEN(qlty8)>5,LEN(qlty8)-0,LEN(qlty8)))
qltyvar9=RIGHT(qlty9,iif(LEN(qlty9)>5,LEN(qlty9)-0,LEN(qlty9)))
qltyvar10=RIGHT(qlty10,iif(LEN(qlty10)>5,LEN(qlty10)-0,LEN(qlty10)))
qltyvar11=RIGHT(qlty11,iif(LEN(qlty11)>5,LEN(qlty11)-0,LEN(qlty11)))

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
pos9=qltyvar9
pos10=qltyvar10
pos11=qltyvar11

Select Query
DELETE FOR monthname="ZZZ"
SET COLOR TO

*If RECNO()>RECCOUNT()
*	Messagebox("Record Not Found for the above seletion!!!")
*Else
Do Case
	Case m.PrnStat="V"
		Report form crosprodm.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form crosprodm.frx to printer prompt noconsole
Endcase
*Endif
RETURN

