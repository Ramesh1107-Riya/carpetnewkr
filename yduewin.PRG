 	*9/11/2014 for raw material purchase yarn/silk/cotton, as we receive materials order must decrease 
procedure yarnwinrep
  	open database carpet
 	SELECT o.rono,o.date,o.quality,o.suplier,o.netwt,o.rate,o.amt,o.orderby;
 	FROM yrnorder o,yrnrecvd p;
 	WHERE o.rono=p.rono .and. p.ptran=.F. .and. (o.netwt>p.netwt) .and.  (o.netwt-p.netwt)!=0;
	GROUP BY p.rono;
	INTO CURSOR ydues

	create sql view yarnwin as;
	SELECT rono,date,quality,suplier,netwt,rate,amt,orderby;
 	FROM yrnorder;
 	WHERE .NOT. EXISTS(SELECT rono FROM yrnrecvd;
 						WHERE yrnorder.rono=yrnrecvd.rono);
	UNION ALL;
	SELECT rono,date,quality,suplier,netwt,rate,amt,orderby;
 	FROM ydues
 	
return

*******Wool purchase window for pending wool order	 
procedure woolwinrep
  	open database carpet
 	SELECT o.rono,o.date,o.wqlty,o.suplier,o.netwt,o.rate,o.amt,o.orderby;
 	FROM woolorder o,woolpu p;
 	WHERE o.rono=p.rono .and. p.ptran=.F. .and. (o.netwt>p.netwt) .and.  (o.netwt-p.netwt)!=0;
	GROUP BY p.rono;
	INTO CURSOR wdues

	create sql view woolwin as;
	SELECT rono,date,wqlty,suplier,netwt,rate,amt,orderby;
 	FROM woolorder;
 	WHERE .NOT. EXISTS(SELECT rono FROM woolpu;
 						WHERE woolorder.rono=woolpu.rono);
	UNION ALL;
	SELECT rono,date,wqlty,suplier,netwt,rate,amt,orderby;
 	FROM wdues
 	
 	USE woolwin
 	INDEX on rono tag rono
 	set order to rono
return 						

