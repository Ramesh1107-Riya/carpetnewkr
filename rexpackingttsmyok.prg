*Quality,Design Not used from Packtran.dbf instead Cadesing.dbf->Dgndesc, Caqlty.dbf->QltyInv, Cabuyord.dbf->Notes and CaDesing->DgnDesc are same
* PACKING LIST  ALL report 
SET TALK OFF
SET CENTURY ON
SET DATE TO BRITISH
SET SAFE OFF
SET ANSI ON
*OPEN DATABASE CARPET

Select *;
From expackingnp;
where Alltrim(invno)=Alltrim(m.invno);
Into cursor packdtl

Dimension packdata (1,32)
Store ' ' to packdata
Select packdtl
copy to ARRAY packdata

Do Case
	Case m.Option="C" .and. m.qlty='Y'
		***Grouping Based on Acutal Quality
		SELECT INVNO,Quality,sum(SQMT) Actualsqmt,sum(sqmtord) as StdSqmt,count(carpetno) as pcs;
		FROM Packtran;
		Where invno=m.invno;
		Group by Quality;
		Order by Quality;
		Into Cursor Temp1A
		
		SELECT p.INVNO,q.QltyInv,p.Actualsqmt,p.StdSqmt,pcs;
		FROM Temp1A p;
		Inner Join Caqlty q;
		On p.quality=q.code;
		Into Cursor temp1
				
		*2)*******Getting Rate from Invoice in Dollar
		Select Invno,Quality,Sqmt,Ratenpr,Exchngrate,Round((Ratenpr/Exchngrate),2) as rateusd,ratedollar;
		From Invdata;
		Where invno=m.invno;
		Into Cursor Inv3
	
		*3a)*****Getting Amount from Invoice
		Select Invno,Sqmt,Quality,rateusd,Round((Sqmt*rateusd),2) as amtusd,Round((Sqmt*ratedollar),2) as amt2usd ;
		From Inv3;		
		Into Cursor Inv2
		
		*3b)****Calcualtion Inventory Qltywise
		Select Invno,QUALITY AS Qltyinv,sum(amtusd) as amtusd,sum(amt2usd) as amt2usd;
		From Inv2 ;
		Group by QUALITY;
		Order by QUALITY;
		Into Cursor Inv1
		
		*4)****Calculation of Amt for Std. Qlty (Knotwise)
		Select Invno,p.Qltyinv,sum(amtusd) as amtusd,sum(amt2usd) as amt2usd;
		From Inv1 p;
		Inner Join Caqlty q;
		On p.Qltyinv=q.qltyinv;
		Group by q.qltyinv;
		Into Cursor Inv
		
		*5)**combine Temp1 & Inv
		SELECT p.INVNO,p.Qltyinv as QUALITY,p.Actualsqmt,p.StdSqmt,p.pcs,q.amtusd,q.amt2usd;
		FROM temp1 p;
		Left Join Inv q;
		On p.Qltyinv=q.Qltyinv;
		Order by p.Qltyinv; 
		Into Cursor temprepview	
			
	Case m.Option="D" .and. m.Knot='Y'
		*1)********Grouping Based on Knotwise
		SELECT INVNO,q.QltyKnot,sum(SQMT) Actualsqmt,sum(sqmtord) as StdSqmt,count(carpetno) as pcs;
		FROM Packtran p;
		Inner Join Caqlty q;
		On p.quality=q.code;
		Where invno=m.invno; 
		Group by q.QltyKnot;
		Order by q.QltyKnot; 
		Into Cursor temp1

		*2)*******Getting Rate from Invoice in Dollar
		Select Invno,Quality,Sqmt,Ratenpr,Exchngrate,Round((Ratenpr/Exchngrate),2) as rateusd,ratedollar;
		From Invdata;
		Where invno=m.invno;
		Into Cursor Inv3

		*3a)*****Getting Amount from Invoice
		Select Invno,Sqmt,Quality,rateusd,Round((Sqmt*rateusd),2) as amtusd,Round((Sqmt*ratedollar),2) as amt2usd;
		From Inv3;
		Order by Quality;
		Into Cursor Inv2
		
		*3b)****Calcualtion Inventory Qltywise
		Select Invno,QUALITY AS Qltyinv,sum(amtusd) as amtusd,sum(amt2usd) as amt2usd;
		From Inv2 ;
		Group by QUALITY;
		Order by QUALITY;
		Into Cursor Inv1
		
		*4)****Calculation of Amt for Std. Qlty (Knotwise)
		Select Invno,q.QltyKnot,p.Qltyinv,sum(amtusd) as amtusd,sum(amt2usd) as amt2usd;
		From Inv1 p;
		Inner Join Caqlty q;
		On p.Qltyinv=q.qltyinv;
		Group by q.QltyKnot;
		Into Cursor Inv
				
		*5)**combine Temp1 & Inv
		SELECT p.INVNO,p.QltyKnot as QUALITY,p.Actualsqmt,p.StdSqmt,p.pcs,q.amtusd,q.amt2usd;
		FROM temp1 p;
		Inner Join Inv q;
		On p.QltyKnot=q.QltyKnot;
		Order by p.QltyKnot; 
		Into Cursor temprepview
Endcase

Select temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case

		*Summary Qualitywise
	Case m.PrnStat="V" .and. m.Option="C" .and. Empty(m.SendOption)
		Report form expackSmryQlty.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="C" .and. Empty(m.SendOption)
		Report form expackSmryQlty.frx to printer prompt noconsole

		*Summary Knot-wise
	Case m.PrnStat="V" .and. m.Option="D" .and. Empty(m.SendOption)
		Report form expackSmryKnot.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="D" .and. Empty(m.SendOption)
		Report form expackSmryKnot.frx  to printer prompt noconsole

	Case  m.PrnStat="V" .and. (m.SendOption="C" .or.  m.SendOption="D")
	    *Set path to //ExclReport
		EXPORT TO &exclfile TYPE XL5 FIELDS INVNO,QUALITY,pcs,Actualsqmt,StdSqmt
			Messagebox("Packing List Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Otherwise		
		Messagebox("Invalid choice, make correct Choice!!")
Endcase
Endif
SET ANSI OFF
Return


