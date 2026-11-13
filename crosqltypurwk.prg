*Rcostsmry.prg Costing Summary Report
SET DELETED ON
*SET PROCEDURE TO Catool
*SET TALK OFF
*SET SAFE OFF
Set Date to briti
Set Century on

*DO csTrimInfoa      && Trim Information for Check Purpose !
*Open Database Carpet

**Generating a Table OL_No,Yarn,Cotton,Silk Qty issue Return in Single Row
**Referce Yrprdcard.prg
*1) Issue Data
	Select ol_no,ytype,sum(quantity) IQty;
	FROM wiissue;
	Group by ol_no,ytype;
	INTO CURSOR issue
*2) Return Data		
	Select ol_no,ytype,sum(quantity) RQty;
	FROM wireturn;	
	Group by ol_no,ytype;
	INTO CURSOR retn
*3) Combine both Issue and Return
	Select i.ol_no,i.ytype,IQty,RQty,iif(IQty>=0,iif(Rqty>=0,IQty-RQty,IQty),IQty) as Balance;
	FROM issue i LEFT OUTER JOIN retn r;
	ON i.ol_no=r.ol_no .and. i.ytype=r.ytype ;
	ORDER BY i.ol_no,i.ytype;
	INTO CURSOR cIssRet	
*****************************
*1) Extract YARN only from Combined Cursor
	Select ol_no,Balance as byarn;
	From cIssRet;
	Where ytype="YARN";
	Order by ol_no;
	into Cursor cyarn
*2) Extract COTTON only from Combined Cursor	
	Select ol_no,Balance as bcotn;
	From cIssRet;
	Where ytype="COTTON";
	Order by ol_no;
	into Cursor ccotn

*3) Extract SILK only from Combined Cursor
	Select ol_no,Balance as bsilk;
	From cIssRet;
	Where ytype="SILK";
	Order by ol_no;
	into Cursor csilk
***************
*4) Combine 1 & 2		
	Select i.ol_no,i.byarn,r.bcotn;
	From cyarn i LEFT  OUTER JOIN ccotn r;
	ON i.ol_no=r.Ol_no;
	Order by i.ol_no;
	into cursor ccoty

  * Select Cost of Silk,yarn,Cotton,Overhead Sqm Rate	
  Private m.yarncost,m.cotncost,m.silkcost,m.ovheadsqm
  Select * from CaCost into cursor cost
  select cost
  
  m.yarncost=cost->yarn
  m.cotncost=cost->cotton
  m.silkcost=cost->silk
  m.ovheadsqm=cost->ovhead
    
*5) Combine 3 & 4, To get Overall Data of YARN,COTTON,SILK, in One OL_No Row 
	Select i.ol_no,i.byarn,i.bcotn,r.bsilk,(i.byarn*m.yarncost)+iif(bcotn>0,bcotn*m.cotncost,0)+iif(bsilk>0,bsilk*m.silkcost,0) as costycs;
	From ccoty i LEFT  OUTER JOIN csilk r;
	ON i.ol_no=r.Ol_no;
	Order by i.ol_no;
	Into Cursor Ycost

*6) CaSupord.dbf
*usdrs,silk1per
*pusdrs=105 
*silk1per=1.35
*ROUND((((b.silkper*b.silk1per)+b.qltyusd+b.addusd)*s.finsqmt*b.usdrs),2)  as tamcost && cost in Rs.
SELECT s.Ol_no,b.Quality,s.fdate,s.FinSqmt,s.amt as Weavcost,s.Finsqmt*m.ovheadsqm as Overhead,;
b.silkper,b.qltyusd,b.addusd,ROUND((((b.silkper*b.silk1per)+b.qltyusd+b.addusd)*s.finsqmt),2)  as tamcost,iif(b.dper>0,b.dper,00.00) as dper,b.usdrs;    
FROM  Cabuyord b,Casupord s;
Where  b.ol_no=s.ol_no .and. s.fdate>=m.Text1 .and. s.fdate<=m.Text2;
Order by b.design,b.Quality;
Into Cursor wocost

*6) Combine both Weaving cost + Ovhead cost with Yarn cost, Cost of our production
	Select b.Ol_no,b.Quality,b.fdate,b.FinSqmt,iif(b.Weavcost>0,b.Weavcost,0)+iif(b.Overhead>0,b.Overhead,0)+iif(r.costycs>0,r.costycs,0) as HACcost,iif(b.usdrs>0, b.usdrs,105) as usdrs,;
					b.TAMcost-iif(b.dper>0,b.TAMcost*b.dper*.01,0) as TAMcost;
	FROM wocost b Left Outer Join ycost r;
	ON b.ol_no=r.ol_no;	
	ORDER BY b.ol_no;
	INTO CURSOR Cost1
	
	Select fdate,Ol_no,Quality,FinSqmt,HACcost/usdrs as HACcost,TAMcost,TAMcost-HACcost/usdrs as Balance;
	FROM Cost1;
	ORDER BY Quality,FinSqmt;
	INTO CURSOR Cost2
	
*** Cross Table of Weekly Purchaser Report	
**Cursor is created to allow filter in any quality
CREATE CURSOR PARTYQLTY (Weekday C(12),Quality C(12),sqmt N(9,2),TamCost N(12,2),HACcost N(12,2),Balance N(12,2),Remark C(10))

Select Quality,dow(fdate)as Wkno,FinSqmt,HACcost,TAMcost,Balance;
FROM Cost2;
ORDER BY Quality;
INTO CURSOR Cost3

SELECT r.wkno,r.quality,r.FinSqmt,r.HACcost,r.TAMcost,r.Balance,w.Weekday;
FROM Cost3 r,WEEKDAYS w;
WHERE r.wkno=w.wkno;
INTO CURSOR Cost4
select cost4

SELECT WKNO,Quality,Weekday,sum(FinSqmt) as Sqmt,sum(Tamcost) as TamCost,sum(HACcost) as HACcost,sum(Balance) as Balance;
FROM Cost4;
ORDER BY quality;
GROUP BY Weekday,Quality;  &&Weekday, Wkno
INTO CURSOR RECV

*******************************************************************************************
*Fix position of field, acutal filed is put in the pos... variables
Private pso1,pos2,pos3,pos4,pos5,pso6,pos7,pos8
Local qltyVar1,qltyVar2,qltyVar3,qltyVar4,qltyVar5,qltyVar6,qltyVar7,qltyVar8
Local qlty1,qlty2,qlty3,qlty4,qlty4,qlty5,qlty6,qlty7,qlty8
Local fldcount,countf
store 0 to fldcount

SELECT WEEKDAY FROM WEEKDAYS INTO CURSOR WKDAY
*Creating atlease one dummy record [to make work cross table algo in any condition] which has 0 effect in report
SELECT PARTYQLTY
APPEND FROM DBF('WKDAY')
Replace all Quality with 'ZZZCATE',sqmt WITH 0
APPEND FROM DBF('RECV')

****Grand Total Balance,Profit/Losss,Remark***************
Local gtper,gtremark
Store 0 to gtper
Store space(7) to gtremark 
SELECT sum(TamCost)-sum(HACcost) as GBal,sum(HACcost) as gHACcost,iif(sum(TAMcost)-sum(HACcost)>0,'Profit','Loss  ') As gRemark;
FROM PartyQlty;
INTO CURSOR cGt

Select cGt
gtper=round(cGt->GBal/cGt->gHACcost*100,0)
gtremark=cGt->gRemark
*******eof Grand Total**********

*******Calculating TamCost Cost and Displaying in Cross Table*******
SELECT Quality,sum(TamCost) as TamCost,sum(HACcost) as HACcost,sum(TamCost)-sum(HACcost) as Balance,iif(sum(TAMcost)-sum(HACcost)>0,'Profit','Loss  ') As Remark;
FROM PartyQlty;
GROUP BY Quality;
ORDER BY Quality;
INTO CURSOR cTamC

Local T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,H1,H2,H3,H4,H5,H6,H7,H8,H9,H10,H11,H12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12
Local R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13
Store 0 to T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,H1,H2,H3,H4,H5,H6,H7,H8,H9,H10,H11,H12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12
Store space(7) to R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12
SELECT Recno() as rec,TamCost,HACcost,Balance,Remark From cTamC Into Cursor cTm

select cTm
Scan
	if recno()=1
		T1=cTm->TamCost
		H1=cTm->HACcost
		B1=cTm->Balance
		P1=Round(cTm->Balance/HACcost*100,0)
		R1=cTm->Remark
	endif	
	if recno()=2
		T2=cTm->TamCost
		H2=cTm->HACcost
		B2=cTm->Balance
		P2=Round(cTm->Balance/HACcost*100,0)
		R2=cTm->Remark
	endif	
	if recno()=3
		T3=cTm->TamCost
		H3=cTm->HACcost
		B3=cTm->Balance
		P3=Round(cTm->Balance/HACcost*100,0)
		R3=cTm->Remark
	endif	
	if recno()=4
		T4=cTm->TamCost
		H4=cTm->HACcost
		B4=cTm->Balance
		P4=Round(cTm->Balance/HACcost*100,0)
		R4=cTm->Remark
	endif	
	if recno()=5
		T5=cTm->TamCost
		H5=cTm->HACcost
		B5=cTm->Balance
		P5=Round(cTm->Balance/HACcost*100,0)
		R5=cTm->Remark
	endif	
	if recno()=6
		T6=cTm->TamCost
		H6=cTm->HACcost
		B6=cTm->Balance
		P6=Round(cTm->Balance/HACcost*100,0)
		R6=cTm->Remark
	endif	
	if recno()=7
		T7=cTm->TamCost
		H7=cTm->HACcost
		B7=cTm->Balance
		P7=Round(cTm->Balance/HACcost*100,0)
		R7=cTm->Remark
	endif	
	if recno()=8
		T8=cTm->TamCost
		H8=cTm->HACcost
		B8=cTm->Balance
		P8=Round(cTm->Balance/HACcost*100,0)
		R8=cTm->Remark
	endif	
	if recno()=9
		T9=cTm->TamCost
		H9=cTm->HACcost
		B9=cTm->Balance
		P9=Round(cTm->Balance/HACcost*100,0)
		R9=cTm->Remark
	endif	
	if recno()=10
		T10=cTm->TamCost
		H10=cTm->HACcost
		B10=cTm->Balance
		P10=Round(cTm->Balance/HACcost*100,0)
		R10=cTm->Remark
	endif	
	if recno()=11
		T11=cTm->TamCost
		H11=cTm->HACcost
		B11=cTm->Balance
		P11=Round(cTm->Balance/HACcost*100,0)
		R11=cTm->Remark
	endif
	if recno()=12
		T12=cTm->TamCost
		H12=cTm->HACcost
		B12=cTm->Balance
		P12=Round(cTm->Balance/HACcost*100,0)
		R12=cTm->Remark
	endif					
Endscan	
******EOF TamCost Calculation*****************************************

SELECT Quality,WeekDay,sum(sqmt) as Sqmt;
 FROM PartyQlty;
 GROUP BY WeekDay,quality;
 ORDER BY quality;
 INTO CURSOR SYS(2015)
 DO (_GENXTAB) WITH 'Query'
Select Query

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

Select Query
DELETE FOR Quality="ZZZCATE"
SET COLOR TO
*If RECNO()>RECCOUNT()
*	Messagebox("Record Not Found for the above seletion!!!")
*Else
Do Case
	Case m.PrnStat="V" 
		Report form crosqltypuwk.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" 
		Report form crosqltypuwk.frx to printer prompt noconsole
Endcase
*Endif

