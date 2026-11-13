*******Wool Yarn Payment Outstanding - Detail/Summary
SET TALK OFF
SET SAFE OFF
SET DATE TO BRITISH

Procedure Detail
  	SELECT suplier,date,desc,amt,dramt;
  	FROM carpet!ywpayent;
  	WHERE Suplier=alltrim(m.Suplier);
  	UNION ALL;
  	SELECT suplier,date,PADR('RM '+ALLTRIM(woolpu.rono)+' '+ALLTRIM(woolpu.wqlty)+' Rs '+Alltrim(STR(woolpu.Rate))+', '+;
 						Alltrim(STR(woolpu.Netwt))+' Kg',40) As Desc,dramt,amt;
 	FROM carpet!woolpu;
 	WHERE Suplier=alltrim(m.Suplier);
 	UNION ALL; 	
 	SELECT suplier,recdt,PADR('RM '+ALLTRIM(yrnrecvd.rono)+' '+ALLTRIM(yrnrecvd.quality)+' Rs '+Alltrim(STR(yrnrecvd.Rate))+', '+;
 							Alltrim(STR(yrnrecvd.Netwt)) +' Kg',40) As Desc,dramt,amt;
 	FROM carpet!yrnrecvd;
 	WHERE Suplier=alltrim(m.Suplier);
 	UNION ALL;
   	SELECT suplier,issdt,PADR('ISU '+ALLTRIM(woolissu.issno)+' '+ALLTRIM(woolissu.wqlty)+' Rs '+Alltrim(STR(woolissu.Rate))+', '+;
 						Alltrim(STR(woolissu.Netwt))+' Kg',40) As Desc,amt,dramt;
 	FROM carpet!woolissu;
 	WHERE Suplier=alltrim(m.Suplier);
 	UNION ALL; 	
 	SELECT suplier,date,PADR('RCD '+ALLTRIM(yrecp.recno)+' '+ALLTRIM(yrecp.quality)+' Rs '+Alltrim(STR(yrecp.Rate))+', '+;
 							Alltrim(STR(yrecp.Netwt)) +' Kg',40) As Desc,dramt,amt;
 	FROM carpet!yrecp;
 	WHERE Suplier=alltrim(m.Suplier);
 	UNION ALL; 	
 	SELECT supplier,fdate,PADR('CN '+ALLTRIM(casupord.carpetno)+' '+ALLTRIM(STR(casupord.bthweav))+'x'+ALLTRIM(STR(casupord.lthweav))+' '+ALLTRIM(casupord.grade)+' Rs ';
 			+Alltrim(STR(casupord.Rate))+', '+Alltrim(STR(casupord.finsqmt,5,2)) +' Sq.Mtr',40) As Desc,(amt*0) as dramt,amt;
 	FROM carpet!casupord;
 	WHERE Supplier=alltrim(m.Suplier) .and. !empty(fdate);
  	UNION ALL; 	
 	SELECT supplier,fdate,PADR('CN '+ALLTRIM(casupord.carpetno)+' '+ALLTRIM(STR(casupord.bthweav))+'x'+ALLTRIM(STR(casupord.lthweav))+' '+ALLTRIM(casupord.grade)+' ';
 			+Alltrim('Mistake ')+', '+Alltrim(STR(casupord.finsqmt,5,2)) +' Sq.Mtr',40) As Desc,(Penalamt) as dramt,(amt*0) as amt;
 	FROM carpet!casupord;
 	WHERE Supplier=alltrim(m.Suplier) .and. !empty(penalamt);
   	UNION ALL; 	
 	SELECT supplier,fdate,PADR('CN '+ALLTRIM(casupord.carpetno)+' '+ALLTRIM(STR(casupord.bthweav))+'x'+ALLTRIM(STR(casupord.lthweav))+' '+ALLTRIM(casupord.grade)+' Rs ';
 			+Alltrim('Extra ')+', '+Alltrim(STR(casupord.finsqmt,5,2)) +' Sq.Mtr',40) As Desc,(amt*0) as dramt,(Extramt) as amt;
 	FROM carpet!casupord;
 	WHERE Supplier=alltrim(m.Suplier) .and. !empty(extramt);
 	into cursor ywpayd
 	
 	select *;
 	from ywpayd;
 	order by date;
 	into cursor ywpaydr
 
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form ywpayd.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form ywpayd.frx to printer prompt noconsole
Endcase
Endif
RETURN

* Qualitywise summary
Procedure Sumary
 	SELECT suplier,date,amt,dramt;
  	FROM carpet!ywpayent;
  	WHERE date<=medate;
  	UNION ALL;
  	SELECT suplier,date,dramt,amt;
 	FROM carpet!woolpu;
 	WHERE date<=medate;
 	UNION ALL; 	
 	SELECT suplier,recdt,dramt,amt;
 	FROM carpet!yrnrecvd;
 	WHERE recdt<=medate;
 	UNION ALL;
   	SELECT suplier,issdt,amt,dramt;
 	FROM carpet!woolissu;
 	WHERE issdt<=medate;
 	UNION ALL; 	
 	SELECT suplier,date,dramt,amt;
 	FROM carpet!yrecp;
 	WHERE date<=medate;
 	UNION ALL; 	
 	SELECT supplier,fdate,(amt*0) as dramt,amt;
 	FROM carpet!casupord;
 	WHERE Supplier=alltrim(m.Suplier) .and. !empty(fdate) .and. fdate<=medate;
 	UNION ALL; 	
 	SELECT supplier,fdate,(Penalamt) as dramt,(amt*0) as amt;
 	FROM carpet!casupord;
 	WHERE Supplier=alltrim(m.Suplier) .and. !empty(fdate) .and. fdate<=medate;
 	UNION ALL;
 	SELECT supplier,fdate,(amt*0) as dramt,(Extramt) as amt;
 	FROM carpet!casupord;
 	WHERE Supplier=alltrim(m.Suplier) .and. !empty(fdate) .and. fdate<=medate;
 	INTO CURSOR ywpays1
 		
 	SELECT suplier,sum(dramt) dramt,sum(amt) Amt;
  	FROM ywpays1;
  	Group by Suplier;
  	Order by Suplier;
  	INTO CURSOR ywpays
 
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form ywpays.frx PREVIEW WINDOW wReport 
		*Report form ywpays.frx to console preview in screen
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form ywpays.frx to printer prompt noconsole
Endcase
Endif
RETURN

		
		
