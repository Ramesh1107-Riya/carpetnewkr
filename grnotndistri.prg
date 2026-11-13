*Finds the Graph Not available for NotDistri Carpet
SET DELETED ON
SET TALK OFF
SET SAFE OFF
 
Private m.allpcs, m.unmatchpcs, m.matchpcs, m.totmatdgn
*SELECT  design, szcode, quality, bcode, order_type, po_no, Po_dt,ol_no;
*FROM Cabuyord;
*WHERE Cstatus="NotDistri";
*Into Cursor buytemp1

SELECT  design, szcode, quality, bcode, order_type, po_no, Po_dt,ol_no;
FROM  Cabuyord ;
WHERE .NOT. EXISTS (Select *;
 					From Casupord;
 					Where Cabuyord.ol_no = Casupord.ol_no);
Into Cursor buytemp1


*eoq  && end of query

* 1 Find Not Matching record in Graph Stock with Order pcs
*Temporarily 3/3/2012 Where b.bcode  = r.bcode .and. ;b.bcode  = r.bcode .and. ;

SELECT  b.design, b.szcode, b.quality, b.order_type, b.bcode, b.po_no, b.Po_dt,b.ol_no;
FROM buytemp1 b;
ORDER BY b.design, b.szcode, b.quality;
WHERE .NOT. EXISTS(SELECT * FROM GRREGSTR r;
			WHERE  b.design = r.design .and. ;
				  b.szcode = r.szcode .and. ;
				  b.quality= r.quality);
INTO cursor UnmatOrd NOFILTER

Select UnmatOrd 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form grnotndistri.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form grnotndistri.frx to printer prompt noconsole
Endcase
Endif
Return

				
