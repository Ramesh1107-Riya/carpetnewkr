	
	SELECT INVNO,q.QltyInv,(SQMT) Actualsqmt,(sqmtord) as StdSqmt;
		FROM Packtran p;
		Inner Join Caqlty q;
		On p.quality=q.code;
		Where invno='TFK-23/19' .AND. q.QltyInv='60 KNOT';
		Group by q.QltyInv;
		Order by q.QltyInv;
		Into Cursor temp1
		Select temp1
		brow

		
		*2)*******Getting Rate from Invoice in Dollar
		Select Invno,Quality,Sqmt,Ratenpr,Exchngrate,Round((Ratenpr/Exchngrate),2) as rateusd,ratedollar;
		From Invdata;
		Where invno='TFK-23/19';
		Into Cursor Inv3
		Select Inv3
		brow

		*3a)*****Getting Amount from Invoice
		Select Invno,Sqmt,Quality,rateusd,Round((Sqmt*rateusd),2) as amtusd,Round((Sqmt*ratedollar),2) as amt2usd ;
		From Inv3;
		Order by Quality;
		Into Cursor Inv2
		select Inv2
		brow
		
		*3b)****Calcualtion Inventory Qltywise
		Select Distinct Invno,QUALITY AS Qltyinv,sum(amtusd) as amtusd,sum(amt2usd) as amt2usd;
		From Inv2 ;
		Group by QUALITY;
		Order by QUALITY;
		Into Cursor Inv1
		select Inv1
		brow
		
		*4)****Calculation of Amt for Std. Qlty (Knotwise)
		Select Distinc Invno,p.Qltyinv,(amtusd*1.0) as amtusd,(amt2usd*1.0) as amt2usd;
		From Inv1 p;
		Left Join Caqlty q;
		On p.Qltyinv=q.qltyinv;
		Into Cursor Inv
		select Inv
		brow
		
	*	Group by p.qltyinv;
	*	Order by p.Qltyinv; 
		
		*5)**combine Temp1 & Inv
		SELECT p.INVNO,p.Qltyinv as QUALITY,Q.Qltyinv,p.Actualsqmt,p.StdSqmt,q.amtusd,q.amt2usd;
		FROM temp1 p;
		Left Join Inv q;
		On p.Qltyinv=q.Qltyinv;
		Order by p.Qltyinv; 
		Into Cursor temprepview
		
		select temprepview
		brow	