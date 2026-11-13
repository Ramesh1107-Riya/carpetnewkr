*Finds the Graph Available for NotDistri Carpet
SET DELETED ON
SET TALK OFF
SET SAFE OFF
 
Private m.allpcs, m.unmatchpcs, m.matchpcs, m.totmatdgn

SELECT  design, szcode, quality, bcode, order_type, po_no, Po_dt,ol_no,cstatus;
FROM  Cabuyord ;
WHERE CSTATUS="NotDistri";
Into Cursor buytemp1

* 1 Find Not Matching record in Graph Stock with Order pcs
*Temporarily 3/3/2012 Where b.bcode  = r.bcode .and. ;b.bcode  = r.bcode .and. ;

SELECT  b.design, b.szcode, b.quality, b.order_type, b.bcode, b.po_no, b.Po_dt,b.ol_no;
FROM buytemp1 b;
ORDER BY b.design, b.szcode, b.quality;
WHERE EXISTS(SELECT * FROM GRREGSTR r;
			WHERE  b.design = r.design .and. ;
				  b.szcode = r.szcode .and. ;
				  b.quality= r.quality);
INTO cursor UnmatOrd1 

Select design, szcode, quality, order_type, bcode, po_no, Po_dt, ol_no;
FROM UnmatOrd1;
Where order_type = m.Order_type;
INTO cursor UnmatOrd2 NOFILTER

*Filter m.bcode

Select design, szcode, quality, order_type, bcode, po_no, Po_dt, ol_no;
FROM UnmatOrd2;
Where bcode = m.bcode;
INTO cursor UnmatOrd NOFILTER


Select UnmatOrd 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form grnotdisavl.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form grnotdiavl.frx to printer prompt noconsole
Endcase
Endif
Return

				
