Private m.invno,m.headtop
Local m.washtype
m.washtype=""

Select * from cacost;
Into Cursor CuCost

*Cost for Cotton,Silk,Yarn
Dimension ACost (1,5)
store ' ' to ACost
Select CuCost
Copy To Array ACost

Public Pcotton,Pyarn,PSilk
*Query to find cabuyer and casupord detail for card no., for Kamal Rug there is no cotndust, to make cotndust=0 sclue-sclue
SELECT b.ol_no, b.design, b.quality, b.colour, b.szcode, b.cstatus, s.weaver, s.supplier,b.qty as LoomNo, s.Issdt, s.loomdt,;
  s.carpetno, s.bthweav, s.lthweav, s.finsqmt,  s.fdate, s.grade, s.carpetwt, s.sclue,s.sclue-s.sclue as cotndust,s.dandi,s.rate,s.amt,;
  s.Penalamt,s.extramt,b.qty*0.0 as silkper,b.qty*102 as qltyusd,b.qty*0.0,s.wev_last_dt,b.Washtype,b.bcode;
FROM  Cabuyord b;
INNER JOIN Casupord s ;
ON  b.ol_no = s.ol_no;
WHERE b.ol_no=alltrim(m.ol_no);
INTO CURSOR bscardetail

SELECT bscardetail
If RECNO()>RECCOUNT()
	Messagebox("Carpet Not Received form Supplier for the above OL_No!!!")
	Return
Endif

Dimension cardetail (1,29)
Store '' to cardetail
SELECT bscardetail
COPY TO ARRAY cardetail

**** For Company head Pema Rug or Kamal Rug on bill top**** 6/10/2021
Select k.compname;
From cabuyer i;
Join bscardetail j;
On i.bcode=j.bcode;
Join packhead k;
On i.compcode=k.compcode;
Into Cursor billhead
Select billhead
m.headtop=billhead->compname
*pcname=billhead->compname
******************************************************************
*m.washtype=ALLTRIM(bscardetail.washtype)
*if(m.washtype="P-RUG")
*		Messagebox("Company : P-RUG")
*		m.headtop="Pema Rug Industries Pvt. Ltd."
*else	
*		Messagebox("Company : K-RUG")
*		m.headtop="Kamal Rug Industries Pvt. Ltd."
*endif
***********************************************************
******Extracting Invoice No. ********************
Select invno;
From bscardetail i,packtran p;
Where i.ol_no=p.ol_no;
into Cursor cInvno

select cInvno
m.invno=cInvno->invno
************************************************

*PsqmUSD=Round((cardetail(1,26)*psilk1per)+cardetail(1,27)+cardetail(1,28),2)
*PsqmRS=Round((cardetail(1,22)/pusdrs),2)

****Total consumption of Silk, other dyed Yarn, Cotton
	**We require only quality, but colour and olno is for check
	Select sum(quantity) quantity,Quality,Colour,ytype,ol_no,rate,amt;
	FROM wiissue;
	WHERE ol_no=alltrim(m.ol_no);
	GROUP BY ytype; 
	ORDER BY ytype;
	INTO CURSOR wiiss1
	
	Select sum(quantity) quantity,Quality,Colour,ytype,ol_no,rate,amt;
	FROM wireturn;
	WHERE ol_no=alltrim(m.ol_no);
	GROUP BY ytype; 
	ORDER BY ytype;
	INTO CURSOR wiret1
	
	***--------Cotton Calculation------------------------------
	Select quantity as wicotton;
	FROM wiiss1 ;
	WHERE ytype='COTTON';
	INTO cursor wic 
	
	Select quantity as wrcotton;
	FROM wiret1 ;
	WHERE ytype='COTTON';
	INTO cursor wrc 

	Pcotton=wic->wicotton-wrc->wrcotton
	
	**-----------Yarn Calculation-----------------------
	Select quantity as wiiyarn;
	FROM wiiss1 ;
	WHERE ytype='YARN';
	INTO cursor wi1 
	
	Select quantity as wretyarn;
	FROM wiret1 ;
	WHERE ytype='YARN';
	INTO cursor wr1 
	
	Pyarn=wi1->wiiyarn-wr1->wretyarn
	***-----------------------------------
	
	Select quantity as wisilk;
	FROM wiiss1 ;
	WHERE ytype='SILK';
	INTO cursor wis 
	
	Select quantity as wrsilk;
	FROM wiret1 ;
	WHERE ytype='SILK';
	INTO cursor wrs 
	
	Psilk=wis->wisilk-wrs->wrsilk
	
	***Total Carpet Cost for HAC and TAMARIAN
	*Hac Total Cost of a Carpet
*	Public pHACTCOST,pTAMTCOST
*	pHACTCOST=Round((Psilk*acost(1,1))+(Pyarn*acost(1,2))+(Pcotton*acost(1,3))+(cardetail(1,15)*acost(1,5))+cardetail(1,23),2)

	*TAMARIAN Total Cost of a Carpet
*	pTAMTCOST=ROUND((((cardetail(1,26)*psilk1per)+cardetail(1,27)+cardetail(1,28))*cardetail(1,15)*pusdrs),2)

***Yarn Consumption Chart, Grouping is Done to exactly match issue,return
	Select ol_no,date,Quality,Colour,sum(quantity) IQuantity,ytype,rate,sum(amt) Iamt;
	FROM wiissue;
	WHERE ol_no=alltrim(m.ol_no);
	GROUP BY Quality,Colour;
	ORDER BY Quality,Colour;
	INTO CURSOR issue
	
	Select ol_no,date,Quality,Colour,sum(quantity) RQuantity,ytype,rate,sum(amt) Ramt;
	FROM wireturn;
	WHERE ol_no=alltrim(m.ol_no);
	GROUP BY Quality,Colour;
	ORDER BY Quality,Colour;
	INTO CURSOR retn
	
	Select i.date,i.Quality,i.Colour,sum(iquantity) IQuantity,sum(rquantity) RQuantity,i.ytype,i.rate,sum(Iamt) Iamt,sum(Ramt) Ramt ;
	FROM issue i;
	LEFT OUTER JOIN retn r;
	ON i.ol_no=r.ol_no .and. i.quality=r.quality .and. i.colour=r.colour ;
	WHERE i.ol_no=alltrim(m.ol_no);
	GROUP BY i.Quality,i.Colour;
	ORDER BY i.Quality,i.Colour,i.date;
	INTO CURSOR consumpchart1
		
	Select date,Quality,Colour,iif(IQuantity>0,IQuantity,0.000) as Iquantity,iif(RQuantity>0,RQuantity,0.000) as RQuantity,ytype,Rate,Iamt,iif(Ramt>0,Ramt,0.00) as Ramt;
	FROM consumpchart1 i;
	ORDER BY ytype,Quality,Colour,date;
	INTO CURSOR consumpchart
	
select consumpchart	
*select bscardetail
If RECNO()>RECCOUNT()
	Messagebox("No Yarn Issue/ Received Entry, Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form YrPrdCard.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P"
		Report form YrPrdCard.frx to printer prompt noconsole
Endcase
Endif
