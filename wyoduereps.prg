*******Wool Yarn Due Report - Detail/Summary
    SELECT rono,date,quality,netwt,(netwt-netwt) netwt1,rate,amt,suplier,entryby;
 	FROM yrnorder;
 	WHERE .NOT. EXISTS(SELECT rono FROM yrnrecvd;
 						WHERE yrnorder.rono=yrnrecvd.rono);
 	UNION ALL;
 	SELECT rono,date,wqlty,netwt,(netwt-netwt) netwt1,rate,amt,suplier,entryby;
 	FROM woolorder;
 	WHERE .NOT. EXISTS (SELECT rono FROM woolpu;
 						WHERE woolorder.rono=woolpu.rono);
 	UNION ALL;					
 	SELECT o.rono,o.date,o.quality,o.netwt,p.netwt,p.rate,p.amt,p.suplier,p.entryby;
 	FROM yrnorder o,yrnrecvd p;
 	WHERE (o.rono=p.rono .and. o.otran=.F.) .and. (o.netwt>p.netwt) .and.  (o.netwt-p.netwt)!=0;
 	UNION ALL;
 	SELECT o.rono,o.date,o.wqlty,o.netwt,p.netwt,p.rate,p.amt,p.suplier,p.entryby;
 	FROM woolorder o,woolpu p;
 	WHERE (o.rono=p.rono .and. o.otran=.F.) .and. (o.netwt>p.netwt) .and.  (o.netwt-p.netwt)!=0;
	into cursor wyorddue1
 	
 	select rono,quality,netwt,sum(netwt1) netwt1,rate*(netwt-sum(netwt1)) amt;
	from wyorddue1;
	group by rono;
	order by rono;
	into cursor test3

If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		*Report form wyodues.frx to console preview in screen		
		Report form wyodues.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wyodues.frx to printer prompt noconsole
Endcase
Endif



