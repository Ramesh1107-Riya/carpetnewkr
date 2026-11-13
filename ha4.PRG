**Generating a Table OL_No,Yarn,Cotton,Silk Qty issue Return in Single Row
*1) Issue Data
	Select ol_no,ytype,sum(quantity) IQuantity;
	FROM wiissue;
	Group by ol_no,ytype;
	INTO CURSOR issue
*2) Return Data	
	Select ol_no,ytype,sum(quantity) RQuantity;
	FROM wireturn;
	Group by ol_no,ytype;
	INTO CURSOR retn
*3) Combine both Issue and Return
	Select i.ol_no,i.ytype,sum(iquantity) IQuantity,sum(rquantity) RQuantity;
	FROM issue i LEFT OUTER JOIN retn r;
	ON i.ol_no=r.ol_no .and. i.ytype=r.ytype ;
	Group by i.ol_no,i.ytype;
	ORDER BY i.ol_no,i.ytype;
	INTO CURSOR cIssRet
*****************************
*1) Extract YARN only from Combined Cursor
	Select ol_no,ytype as yty,IQuantity as Iqtyy,Rquantity  as Rqtyy;
	From cIssRet;
	Where ytype="YARN";
	Order by ol_no;
	into Cursor cyarn
*2) Extract COTTON only from Combined Cursor	
	Select ol_no,ytype as ytc,IQuantity as Iqtyc,Rquantity as Rqtyc;
	From cIssRet;
	Where ytype="COTTON";
	Order by ol_no;
	into Cursor ccotn

*3) Extract SILK only from Combined Cursor
	Select ol_no,ytype as yts,IQuantity as Iqtys,Rquantity as Rqtys;
	From cIssRet;
	Where ytype="SILK";
	Order by ol_no;
	into Cursor csilk
***************
*4) Combine 1 & 2		
	Select i.ol_no,i.yty,i.Iqtyy,i.Rqtyy,r.ytc,r.Iqtyc,r.Rqtyc;
	From cyarn i LEFT  OUTER JOIN ccotn r;
	ON i.ol_no=r.Ol_no;
	Order by i.ol_no;
	into cursor ccoty
	
*5) Combine 3 & 4, To get Overall Data of YARN,COTTON,SILK, in One OL_No Row		
	Select i.ol_no,iif(i.Rqtyy>=0,i.Iqtyy-i.Rqtyy,i.Iqtyy) as YarnKg,iif(i.Rqtyc>=0,i.Iqtyc-i.Rqtyc,i.Iqtyc) as CotnKg,;
	iif(r.Rqtys>=0,r.Iqtys-r.Rqtys,r.Iqtys) as SilkKg;
	From ccoty i LEFT  OUTER JOIN csilk r;
	ON i.ol_no=r.Ol_no;
	Order by i.ol_no
	*Into Cursor cYrnCtnSlk
*6) Inserting 0 in NULL column
	Select ol_no,iif(YarnKg>0,YarnKg,0) as Yarnkg,CotnKg,iif(SilkKg>0,SilkKg,0) as Silkkg;
	From cYrnCtnSlk;
	Order by ol_no
	
*5) Combine 3 & 4, To get Overall Data of YARN,COTTON,SILK, in One OL_No Row		
	*Select i.ol_no,i.Iqtyy,i.Rqtyy,iif(i.Rqtyy>=0,i.Iqtyy-i.Rqtyy,i.Iqtyy) as Yarnkg,i.Iqtyc,i.Rqtyc,;
	*iif(i.Rqtyc>=0,i.Iqtyc-i.Rqtyc,i.Iqtyc) as Cotnkg,r.Iqtys,r.Rqtys,iif(r.Rqtys>=0,r.Iqtys-r.Rqtys,r.Iqtys) as Silkkg;
	*From ccoty i LEFT  OUTER JOIN csilk r;
	*ON i.ol_no=r.Ol_no;
	*Order by i.ol_no
	
	
