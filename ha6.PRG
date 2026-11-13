	Select ol_no,ytype,sum(quantity) IQty;
	FROM wiissue;
	Group by ol_no,ytype;
	INTO CURSOR issue
	select issue
	brow
	
	Select ol_no,ytype,sum(quantity) RQty;
	FROM wireturn;
	Group by ol_no,ytype;
	INTO CURSOR retn

	Select i.ol_no,i.ytype,IQty,RQty,iif(IQty>=0,iif(Rqty>=0,IQty-RQty,IQty),IQty) as Balance;
	FROM issue i LEFT OUTER JOIN retn r;
	ON i.ol_no=r.ol_no .and. i.ytype=r.ytype ;
	ORDER BY i.ol_no,i.ytype;
	INTO CURSOR cIssRet
	
	select cIssRet
	brow
	
	*Select i.ol_no,iif(i.Rqtyy>=0,i.Iqtyy-i.Rqtyy,i.Iqtyy) as YarnKg,iif(i.Rqtyc>=0,i.Iqtyc-i.Rqtyc,i.Iqtyc) as CotnKg,;
	*iif(r.Rqtys>=0,r.Iqtys-r.Rqtys,r.Iqtys) as SilkKg;
	*From ccoty i LEFT  OUTER JOIN csilk r;
	*ON i.ol_no=r.Ol_no;
	*Order by i.ol_no