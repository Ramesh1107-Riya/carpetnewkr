***Cross Table Generating, Max upto 20 Filed, But if field Quality Filed reduced to less than 20 program does not work
***Future Developement required: Ramesh Basnet 15 July,2009, i.e. Limiting & initializing variables less than 20
SET DELETED ON
SET TALK OFF
SET SAFE OFF

PROCEDURE WOOLISSUE
croshead="Dyed Yarn Issue"

SELECT party,quality,SUM(quantity) as quantity;
 FROM wiissue;
 WHERE date>=msdate .and. date<=medate;
 GROUP BY party,quality;
 ORDER BY party,quality;
 INTO CURSOR  RECV
RETURN

PROCEDURE WOOLRECV
croshead="Dyed Yarn Receive"
SELECT party,quality,SUM(quantity) as quantity;
 FROM wirecv;
 WHERE date>=msdate .and. date<=medate;
 GROUP BY party,quality;
 ORDER BY party,quality;
 INTO CURSOR  RECV
RETURN

PROCEDURE WOOLBOTH

*Fix position of field, acutal filed is put in the pos... variables
Private pso1,pos2,pos3,pos4,pos5,pso6,pos7,pos8,pos9,pos10,pso11,pos12,pos13,pos14,pos15,pso16,pos17,pos18,pos19,pos20

Local qltyVar1,qltyVar2,qltyVar3,qltyVar4,qltyVar5,qltyVar6,qltyVar7,qltyVar8,qltyVar9,qltyVar10,;
qltyVar11,qltyVar12,qltyVar13,qltyVar14,qltyVar15,qltyVar16,qltyVar17,qltyVar18,qltyVar19,qltyVar20

Local qlty1,qlty2,qlty3,qlty4,qlty4,qlty5,qlty6,qlty7,qlty8,qlty9,qlty10,qlty11,qlty12,qlty13,qlty14,;
	qlty15,qlty16,qlty17,qlty18,qlty19,qly20

Local fldcount,countf
store 0 to fldcount

**Cursor is created to allow filter in any quality
CREATE CURSOR PARTYQLTY (Party C(10),Quality C(10),Quantity N(11,3))

SELECT quality;
 FROM wiqlty;
 ORDER BY quality;
 INTO CURSOR QLTY

*Creating atlease one dummy record [to make work cross table algo in any condition] which has 0 effect in report
SELECT PARTYQLTY
APPEND FROM DBF('QLTY')
Replace all party with 'ZZZPARTY',QUANTITY WITH 0

SELECT PARTYQLTY
APPEND FROM DBF('RECV')

SELECT party,quality,quantity;
 FROM PartyQlty;
 GROUP BY party,quality;
 ORDER BY party,quality;
 INTO CURSOR SYS(2015)
 DO (_GENXTAB) WITH 'Query'

select Query
gnFieldcount = AFIELDS(gaMyArray)  && Create array and counts nos of filed in the array
*CLEAR
*FOR nCount = 1 TO gnFieldcount 
*	?gaMyArray(nCount,1)  && Display field names
*ENDFOR
* WHERE Wirecv.date>={^2009/06/01};
*intializing variable with current field value, Total can not be captured
*Get field name for heading1,...2,...3 etc, Limitation is 20 fields=1 party=19 Wool quality 60K Tib,100K Tib etc.

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
qlty12=gaMyArray(12,1)
qlty13=gaMyArray(13,1)
qlty14=gaMyArray(14,1)  
qlty15=gaMyArray(15,1)
qlty16=gaMyArray(16,1)
qlty17=gaMyArray(17,1)
qlty18=gaMyArray(18,1)
qlty19=gaMyArray(19,1)
qlty20=gaMyArray(20,1)

*get local var value local var by removing 1st two char from field name that is not required 
*for heading for field len >5
qltyvar1=qlty1 
qltyvar2=qlty2
qltyvar3=qlty3
qltyvar4=RIGHT(qlty4,iif(LEN(qlty4)>5,LEN(qlty4)-2,LEN(qlty4)))
qltyvar5=RIGHT(qlty5,iif(LEN(qlty5)>5,LEN(qlty5)-2,LEN(qlty5)))
qltyvar6=RIGHT(qlty6,iif(LEN(qlty6)>5,LEN(qlty6)-2,LEN(qlty6)))
qltyvar7=RIGHT(qlty7,iif(LEN(qlty7)>5,LEN(qlty7)-2,LEN(qlty7)))
qltyvar8=RIGHT(qlty8,iif(LEN(qlty8)>5,LEN(qlty8)-2,LEN(qlty8)))
qltyvar9=RIGHT(qlty9,iif(LEN(qlty9)>5,LEN(qlty9)-2,LEN(qlty9)))
qltyvar10=RIGHT(qlty10,iif(LEN(qlty10)>5,LEN(qlty10)-2,LEN(qlty10)))
qltyvar11=RIGHT(qlty11,iif(LEN(qlty11)>5,LEN(qlty11)-2,LEN(qlty11)))
qltyvar12=RIGHT(qlty12,iif(LEN(qlty12)>5,LEN(qlty12)-2,LEN(qlty12)))
qltyvar13=RIGHT(qlty13,iif(LEN(qlty13)>5,LEN(qlty13)-2,LEN(qlty13)))
qltyvar14=RIGHT(qlty14,iif(LEN(qlty14)>5,LEN(qlty14)-2,LEN(qlty14)))
qltyvar15=RIGHT(qlty15,iif(LEN(qlty15)>5,LEN(qlty15)-2,LEN(qlty15)))
qltyvar16=qlty16
qltyvar17=qlty17
qltyvar18=qlty18
qltyvar19=qlty19
qltyvar20=qlty20

**Fix the postion of data Headings (Fields),fields arranged in report order 1,16,15,14,18,19.20,7,3,4,6,5,9,12,11,13,17,2,8,10
pos1=qltyvar1
pos2=qltyvar16
pos3=qltyvar15
pos4=qltyvar14
pos5=qltyvar18
pos6=qltyvar19
pos7=qltyvar20
pos8=qltyvar7
pos9=qltyvar3
pos10=qltyvar4
pos11=qltyvar6
pos12=qltyvar5
pos13=qltyvar9
pos14=qltyvar12
pos15=qltyvar11
pos16=qltyvar13
pos17=qltyvar17
pos18=qltyvar2
pos19=qltyvar8
pos20=qltyvar10

Select Query
DELETE FOR PARTY="ZZZPARTY"
SET COLOR TO

*If RECNO()>RECCOUNT()
*	Messagebox("Record Not Found for the above seletion!!!")
*Else
Do Case
	Case m.PrnStat="V"
		Report form wicrosqlty.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wicrosqlty.frx to printer prompt noconsole
Endcase
*Endif
RETURN


