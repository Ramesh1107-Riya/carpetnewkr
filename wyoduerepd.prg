*******Wool Yarn Due Report - Detail/Summary
*1) You need to collect all Non Existing rono data in wool and yarn purchase file
*2)For partial wool/yarn received, you need to collect those that p.tran=F (incompelete transaction);
* and order netwt> purchase netwt and o.netwt-p.netwet!=0, 

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
	
	SELECT rono,date,quality,netwt,sum(netwt1) netwt1,rate,rate*(netwt-sum(netwt1)) amt,suplier;
	FROM wyorddue1;
	GROUP BY rono;
	order by rono;
	into cursor wyorddue
 
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		*Report form wyodued.frx to console preview in screen
		Report form wyodued.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form wyodued.frx to printer prompt noconsole
Endcase
Endif


