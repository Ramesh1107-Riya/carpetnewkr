Select * from cacost;
Into Cursor CuCost

*Cost for Cotton,Silk,Yarn, only overhead cost acost(1,5) is used 13/10/2022 rest cotton,silk,yarn cost from wiissue.dbf->costrate(field)
Dimension ACost (1,5)
store ' ' to ACost
Select CuCost
Copy To Array ACost

Public Pcotqty,Pyarnqty,PSilkqty,Prate,Pcotamt,Psilkam,Pyarnamt
PcotAmt=0.00
PsilkAmt=0.00
PyarnAmt=0.00
**Total Quantity by type
Pcotqty=0.00
Pyarnqty=0.00
PSilkqty=0.00


*Query to find cabuyer and casupord detail for card no.
SELECT b.ol_no, b.design, b.quality, b.colour, b.szcode, b.cstatus, s.weaver, s.supplier,b.qty as LoomNo, s.Issdt, s.loomdt,;
  s.carpetno, s.bthweav, s.lthweav, s.finsqmt,  s.fdate, s.grade, s.carpetwt, s.sclue,s.sclue as cotndust,s.dandi,s.rate,s.amt,;
  s.Penalamt,s.extramt,b.qty*0.0 as silkper,b.qty*102 as qltyusd,b.qty*0.0,s.wev_last_dt,b.bcode,b.washtype;
FROM  carpet!Cabuyord b INNER JOIN carpet!Casupord s ;
ON  b.ol_no = s.ol_no;
WHERE s.ol_no=alltrim(m.ol_no);
INTO CURSOR bscardetail

Dimension cardetail (1,31)
Store '' to cardetail
SELECT bscardetail
COPY TO ARRAY cardetail

******Extracting Invoice No. ********************
Private m.invno
Select invno;
From bscardetail i,packtran p;
Where i.ol_no=p.ol_no;
into Cursor cInvno

select cInvno
m.invno=cInvno->invno
************************************************

****Total consumption of Silk, other dyed Yarn, Cotton
	*Select sum(i.quantity)-sum(r.quantity) as balqty,i.Quality,i.Colour,i.ytype,i.ol_no,i.costrate,i.rate,i.amt,sum(i.amt)-sum(r.amt) as totamt
	**********Total cost Calculation
	
	Select sum(quantity) iquantity,Quality,ytype,costrate,colour,rate;
	FROM wiissue;
	WHERE ol_no=alltrim(m.ol_no);
	GROUP BY quality,colour; 
	ORDER BY quality,colour;
	INTO CURSOR wiis
	***********	
	Select sum(quantity) as rquantity,Quality,ytype,colour,rate;
	FROM wireturn;
	WHERE ol_no=alltrim(m.ol_no);
	GROUP BY quality,colour;  
	ORDER BY quality,colour;
	INTO CURSOR wiRet	
	****************
	*Select i.quality,i.colour,i.iquantity-iif(r.rquantity>0,r.rquantity,0.000) as balqty,i.ytype,i.costrate,(i.iquantity-iif(r.rquantity>0,r.rquantity,0.000))*i.costrate  as Totamt,i.rate;	
	**Real Cost we include only issue item not balance as per  Mr. Palzor 11/03/2022
	*Pcotton=wic->wicotton-wrc->wrcotton
	*Pcotton=wic->wicotton && 11/03/2022
	Select i.quality,i.colour,i.iquantity as balqty,i.ytype,i.costrate,i.iquantity*i.costrate  as Totamt,i.rate;
	FROM wiis i LEFT OUTER JOIN wiRet r;
	ON i.quality=r.quality .and. i.colour=r.colour;
	ORDER BY i.quality,i.colour;
	INTO CURSOR wiisRetA	
	
	Select Quality,Colour,iif(balqty>0,balqty,0.000) as balqty,ytype,iif(Totamt>0,Totamt,0.00) as Totamt,rate;
	FROM wiisRetA;
	ORDER BY ytype,Quality,Colour;
	INTO CURSOR wiisRet
	
	Prate=wiisRet->rate && 11/03/2022
	
	***--------Cotton Costing Calculation------------------------------
	Select sum(Totamt)as CotAmt,sum(balqty) CotQty;
	FROM wiisRet;
	Where ytype='COTTON';
	Group by ytype;
	INTO cursor wirc 
	Select wirc
	Pcotqty=wirc->CotQty
	PcotAmt=wirc->CotAmt
	**-----------Yarn Costing Calculation-----------------------
	Select sum(totamt)as YarnAmt,sum(balqty) YarnQty;
	FROM wiisRet;
	Where ytype='YARN';
	Group by ytype;
	INTO cursor wiry 
	Select wirc
	Pyarnqty=wiry->YarnQty
	PyarnAmt=wiry->YarnAmt
	**-----------Silk Costing Calculation-----------------------
	Select sum(totamt)as SilkAmt,sum(balqty) SilkQty;
	FROM wiisRet;
	Where ytype='SILK';
	Group by ytype;
	INTO cursor wirs 
	Select wirc
	Psilkqty=wirs->SilkQty
	PsilkAmt=wirs->SilkAmt
	***-----------------------------------
***Yarn Consumption Chart, Grouping is Done to exactly match issue,return
	Select ol_no,date,Quality,Colour,sum(quantity) IQuantity,ytype,rate,sum(amt) Iamt,costrate;
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
	
	Select i.date,i.Quality,i.Colour,sum(iquantity) IQuantity,sum(rquantity) RQuantity,i.ytype,i.rate,sum(Iamt) Iamt,sum(Ramt) Ramt,i.costrate ;
	FROM issue i LEFT OUTER JOIN retn r;
	ON i.ol_no=r.ol_no .and. i.quality=r.quality .and. i.colour=r.colour ;
	WHERE i.ol_no=alltrim(m.ol_no);
	GROUP BY i.Quality,i.Colour;
	ORDER BY rquantity desc;  && 26/11/2021 done for space value taken hightest first/ in the second we arrange  ORDER BY ytype,Quality,Colour,date
	INTO CURSOR consumpchart1
				
	Select date,Quality,Colour,iif(IQuantity>0,IQuantity,0.000) as Iquantity,iif(RQuantity>0,RQuantity,0.000) as RQuantity,ytype,Rate,Iamt,iif(Ramt>0,Ramt,0.00) as Ramt,costrate;
	FROM consumpchart1 i;
	ORDER BY ytype,Quality,Colour,date;
	INTO CURSOR consumpchart

select consumpchart	
*select bscardetail
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form YrPrdRealC.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport 
	Case m.PrnStat="P"
		Report form YrPrdRealC.frx to printer prompt noconsole
Endcase
Endif
