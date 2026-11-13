*Rcostsmry.prg Costing Summary Report
SET DELETED ON
SET PROCEDURE TO Catool
SET TALK OFF
SET SAFE OFF
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfoa      && Trim Information for Check Purpose !
CREATE CURSOR REPSTOCK (OL_NO C(15),YTYPE C(6),ISSQTYC N(11,3),ISSQTYS N(11,3),ISSQTYY N(11,3),RETNQTYC N(11,3),RETNQTYS N(11,3),RETNQTYY N(11,3),RCOD C(3))

SELECT YTYPE,OL_NO,SUM(QUANTITY) AS QUANTITY,PADR('RTN',3) as RCOD;
FROM WIRETURN;
GROUP BY ol_no,ytype; 
ORDER BY ol_no;
INTO CURSOR RETN

SELECT YTYPE,OL_NO,SUM(QUANTITY) AS QUANTITY,PADR('ISS',3) as RCOD;
FROM WIISSUE;
GROUP BY ol_no,ytype; 
ORDER BY ol_no;
INTO CURSOR ISSUE

SELECT YTYPE,OL_NO,QUANTITY,RCOD;
FROM RETN;
UNION ALL;
SELECT YTYPE,OL_NO,QUANTITY,RCOD;
FROM ISSUE;
INTO CURSOR wstk

***** distribute all data according issue/retun
SELECT wstk 
DO WHILE .NOT. EOF()
SELECT REPSTOCK
APPEN BLANK
repl ytype with wstk->ytype,ol_no with wstk->ol_no,rcod with wstk->rcod
do case
	case rcod='ISS' .AND. YTYPE='COTTON'
		repl repstock->ISSQTYC with wstk->Quantity		
	case rcod='ISS' .AND. YTYPE='YARN'
		repl repstock->ISSQTYY with wstk->Quantity	
	case rcod='ISS' .AND. YTYPE='SILK'
		repl repstock->ISSQTYS with wstk->Quantity	
	case rcod='RTN' .AND. YTYPE='COTTON'
		repl repstock->RETNQTYC with wstk->Quantity		
	case rcod='RTN' .AND. YTYPE='YARN'
		repl repstock->RETNQTYY with wstk->Quantity	
	case rcod='RTN' .AND. YTYPE='SILK'
		repl repstock->RETNQTYS with wstk->Quantity	
  endcase
   SELECT wstk
	IF .NOT. EOF()
	   SKIP
	ENDIF
ENDDO

Select  OL_NO, YTYPE, SUM(ISSQTYC) ISSQTYC, SUM(ISSQTYS) ISSQTYS, SUM(ISSQTYY) ISSQTYY, SUM(RETNQTYC) RETNQTYC, SUM(RETNQTYS) RETNQTYS, SUM(RETNQTYY) RETNQTYY;
FROM Repstock;
Group by ol_no;
Order by ol_no;
Into Cursor Repstock1

Select  OL_NO, YTYPE, SUM(ISSQTYC-RETNQTYC) as bcotn, SUM(ISSQTYS-RETNQTYS) as bsilk, SUM(ISSQTYY-RETNQTYY) as byarn;
FROM Repstock;
Group by ol_no;
Order by ol_no;
Into Cursor cCostYrnAll

  * Select Cost of Silk,yarn,Cotton,Overhead Sqm Rate	
  Private m.yarncost,m.cotncost,m.silkcost,m.ovheadsqm
  Store 0.0 to m.yarncost,m.cotncost,m.silkcost,m.ovheadsqm
  Select * from CaCost into cursor cost
  select cost
  
  m.yarncost=cost->yarn
  m.cotncost=cost->cotton
  m.silkcost=cost->silk
  m.ovheadsqm=cost->ovhead
  
*************************************    
*5) Combine 3 & 4, To get Overall Data of YARN,COTTON,SILK, in One OL_No Row 17-7-2018 original
	*Select ol_no,byarn,bcotn,bsilk,iif(byarn>0.0,byarn*m.yarncost,0.0)+iif(bco-tn>0.0,bcotn*m.cotncost,0.0)+iif(bsilk>0.0,bsilk*m.silkcost,0.0) as costycs;
	*From cCostYrnAll;
	*Where !empty(ol_no);
	*Order by ol_no;
	*Into Cursor Ycost
***************************************************
	*Select ol_no,byarn,bcotn,bsilk,iif(byarn>0.0,byarn*m.yarncost,0.0) as costyr,iif(bcotn>0.0,bcotn*m.cotncost,0.0) as costco,iif(bsilk>0.0,bsilk*m.silkcost,0.0) as costsl;
	*From cCostYrnAll;
	*Where !empty(ol_no);
	*Order by ol_no;
	*Into Cursor Ycost
	
	Select ol_no,byarn,bcotn,bsilk,(byarn*m.yarncost) as costyr,(bcotn*m.cotncost) as costco,(bsilk*m.silkcost) as costsl;
	From cCostYrnAll;
	Where !empty(ol_no);
	Order by ol_no;
	Into Cursor Ycosta
	
	Select ol_no,byarn,bcotn,bsilk,costyr+costco+costsl as costycs;
	From Ycosta;
	Order by ol_no;
	Into Cursor Ycost
		
*6) CaSupord.dbf

SELECT b.Bcode,b.po_no,s.Ol_no,s.Carpetno,b.Design,b.Colour,b.Quality,s.Supplier,b.szcode,s.fdate,s.FinSqmt,s.amt as Weavcost,s.Finsqmt*m.ovheadsqm as Overhead;
FROM  Cabuyord b, Casupord s;
Where b.ol_no=s.ol_no .and. s.finsqmt>0 .and. s.fdate>=m.Text1 .and. s.fdate<=m.Text4 ;
Order by b.design,b.Quality;
Into Cursor wocost

*6) Combine both Weaving cost + Ovhead cost with Yarn cost, Cost of our production
	Select b.Bcode,b.po_no,b.Ol_no,b.Carpetno,b.Design,b.Colour,b.Quality,b.fdate,b.szcode,b.Supplier,b.FinSqmt,Round(b.Weavcost,2) as weavcost,;
				round(b.Overhead,2) as overhead,Round(r.costycs,2) as yarncost,Round(b.Weavcost,2)+round(b.Overhead,2)+Round(r.costycs,2) as HACcost;
	FROM wocost b;
	Left Join ycost r;
	ON b.ol_no=r.ol_no;
	ORDER BY b.ol_no;
	INTO CURSOR Cost1	
	*Round(r.costycs,2) as HACcost,b.TAMcost-b.TAMcost*(b.dper/100) as TAMcost
DO CASE
  CASE m.check1=0		
	Select Bcode,po_no,fdate,Ol_no,Carpetno,Design,Colour,Quality,szcode,Supplier,FinSqmt,Weavcost,overhead,yarncost,HACcost;
	FROM Cost1;
	WHERE ccsMatch3a1(BCODE, CARPETNO, PO_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, SUPPLIER );
	ORDER BY Quality,FinSqmt,Design;
	INTO CURSOR Cost2

	Select Cost2
	SET COLOR TO
	If RECNO()>RECCOUNT()
		Messagebox("Record Not Found for the above seletion!!!")
	Else
	Do Case
		Case m.PrnStat="V" .and. m.Option="A"
			Report form rcostsmry.frx PREVIEW WINDOW wReport 
			DEACTIVATE WINDOW wReport
		Case m.PrnStat="P" .and. m.Option="B"
			Report form rcostsmry.frx to printer prompt noconsole
		Case  m.PrnStat="V" .and. m.Option="E" 
			EXPORT TO &exclfile TYPE XL5 FIELDS Ol_no,Carpetno,Design,Colour,Quality,szcode,Supplier,FinSqmt,Weavcost,overhead,yarncost,HACcost
			Messagebox("Costing Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Endcase
	Endif
*		
  CASE m.check1=1	
	Select Bcode,po_no,fdate,Ol_no,Carpetno,Design,Colour,Quality,szcode,Supplier,FinSqmt,Weavcost,overhead,yarncost,HACcost;
	FROM Cost1;
	WHERE ccsMatch3a1(BCODE, CARPETNO, PO_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, SUPPLIER );
	ORDER BY Design,Quality;
	INTO CURSOR Cost2	
	
	Select Cost2
	SET COLOR TO
	If RECNO()>RECCOUNT()
		Messagebox("Record Not Found for the above seletion!!!")
	Else
	Do Case
		Case m.PrnStat="V" .and. m.Option="A"
			Report form rcostsmryd.frx PREVIEW WINDOW wReport 
			DEACTIVATE WINDOW wReport
		Case m.PrnStat="P" .and. m.Option="B"
			Report form rcostsmryd.frx to printer prompt noconsole
		Case  m.PrnStat="V" .and. m.Option="E" 
			EXPORT TO &exclfile TYPE XL5 FIELDS Ol_no,Carpetno,Design,Colour,Quality,szcode,Supplier,FinSqmt,Weavcost,overhead,yarncost,HACcost
			Messagebox("Costing Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Endcase
	Endif
ENDCASE


