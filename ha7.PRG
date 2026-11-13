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
Local pusdrs,psilk1per
pusdrs=105 && purchase rate of USD vs Rs. 1 USD=Rs.105
psilk1per=6.25

SELECT s.Ol_no,s.Carpetno,b.Design,b.Colour,b.Quality,s.Weaver,b.szcode,s.FinSqmt,s.amt as Weavcost,s.Finsqmt*m.ovheadsqm as Overhead,;
b.silkper,b.qtyusd,b.addusd,ROUND((((b.silkper*psilk1per)+b.qtyusd+b.addusd)*s.finsqmt*pusdrs),2)  as tamcost;    
FROM  Cabuyord b, Casupord s;
Where b.ol_no=s.ol_no .and. s.finsqmt>0;
Order by b.design,b.Quality,s.Weaver;
Into Cursor wocost

*7) Combine both Weaving cost + Ovhead cost with Yarn cost, Cost of our production
	Select b.Ol_no,b.Carpetno,b.Design,b.Colour,b.Quality,b.szcode,b.Weaver,b.FinSqmt,Round(b.Weavcost,2) as weavcost,;
				round(b.Overhead,2) as overhead,Round(r.costycs,2) as yarncost,Round(b.Weavcost,2)+round(b.Overhead,2)+;
				Round(r.costycs,2) as HACcost,b.TAMcost;
	FROM wocost b, ycost r;
	Where b.ol_no=r.ol_no;
	ORDER BY b.ol_no;
	INTO CURSOR Cost1
	
	Select Ol_no,Carpetno,Design,Colour,Quality,szcode,Weaver,FinSqmt,Weavcost,overhead,yarncost,HACcost,TAMcost,;
		TAMcost-HACcost as Balance, iif(TAMcost-HACcost>0,'Profit','Loss') As Remark;
	FROM Cost1;
	ORDER BY ol_no
	*INTO CURSOR Cost2
	
	
	
*A) Caculating Buyer cost (Price paid by buyer)

*TAMARIAN Total Cost of a Carpet 
*ROUND(((b.silkper*psilk1per)+b.qtyusd+b.addusd)*s.finsqmt*pusdrs),2)  as tamcost       
 
