*FINISHED PRC report Payment Report, Paid
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo5a      && Trim Information for Check Purpose !
Open Database Carpet
* Assumption Before Bill is is Printed, we update Bill No. Starting 1001, Done for Numbering Bill

	SELECT  i.OL_NO,i.carpetno, i.Shipbrth, i.Shiplngth, i.SQMT,i.Invno,i.expdt,j.compcode,j.pname;
	FROM  Packtran i,expackingnp j;
	WHERE EXPDT>=m.Text1 .and. EXPDT<=m.Text2 .and. i.invno = j.invno;
	Order By i.ol_no;
	Into Cursor BuyExpo

		
	SELECT b.BCODE, b.QUALITY, s.CARD_NO, s.WEAVER, s.CARPETNO,  b.DESIGN, b.COLOUR, b.SZCODE, s.BTHWEAV,s.LTHWEAV, s.FINSQMT, b.OL_NO, s.ISSDT, s.GRADE, s.FDate, b.PO_NO,;
	b.NOTES,s.rate,s.amt,s.Penalamt,s.extramt,b.FIELDCODE,s.BILLNO,s.DANDI,s.ALLOWPAY,s.PAIDSTATUS,s.PAIDDATE,b.ORDER_TYPE, b.SPCL_INST, e.Shipbrth, e.Shiplngth,;
	e.SQMT,e.Invno,e.expdt,e.compcode,e.pname;
	FROM Cabuyord b;
	Join  Casupord s;
	ON b.OL_NO=s.OL_NO;
	Join  BuyExpo e;
	ON b.Ol_NO=e.OL_NO;
	INTO CURSOR TEMP1

	
	SELECT *;
	FROM TEMP1;	
	WHERE ccsMatch10a(Bcode, Quality, Weaver, Grade, Po_no, Notes, BillNo, Carpetno, Order_Type, Spcl_Inst);	
	ORDER BY Weaver,FDate ASC;
	INTO CURSOR Temp2	
	
	*WHERE ccsMatch10(Bcode, Quality, Weaver, Grade, Po_no, Notes,BillNo) 

***************** 23/03/2022 Added Portion **** To include yarn total in Supplier bill, We see yarn total yarn qty (issue-return)
	Select ol_no,sum(quantity) IQuantity,rate;
	FROM wiissue;
	GROUP BY ol_no;
	ORDER BY ol_no;
	INTO CURSOR issue
	
	Select ol_no,sum(quantity) RQuantity;
	FROM wireturn;
	GROUP BY ol_no;
	ORDER BY ol_no;
	INTO CURSOR retn
	
	Select i.ol_no,sum(iquantity) IQuantity,sum(rquantity) RQuantity,i.rate ;
	FROM issue i LEFT OUTER JOIN retn r;
	ON i.ol_no=r.ol_no;
	GROUP BY i.ol_no;
	ORDER BY rquantity desc;  && 26/11/2021 done for space value taken hightest first/ in the second we arrange  ORDER BY ytype,Quality,Colour,date
	INTO CURSOR ycost1
				
	Select ol_no,iif(IQuantity>0,IQuantity,0.000) as Iquantity,iif(RQuantity>0,RQuantity,0.000) as RQuantity,Rate;
	FROM ycost1 i;
	ORDER BY ol_no;
	INTO CURSOR ycost2
	
	Select ol_no, (Iquantity-RQuantity) as balqty,Rate;
	FROM ycost2;
	ORDER BY ol_no;
	INTO CURSOR ycost3
	
********End of added 23/03/2022cost

**Report Generation*******************************as yrnamt

*6) Combine both Weaving cost +  Yarn cost for production,for null yarn consumption 4Kg, and Rate Rs.1000
SELECT b.BCODE, b.QUALITY, b.CARD_NO, b.WEAVER, b.CARPETNO,  b.DESIGN, b.COLOUR,b.SZCODE,b.BTHWEAV,b.LTHWEAV, b.FINSQMT, b.OL_NO, b.ISSDT, b.GRADE, b.FDate, b.PO_NO,;
b.NOTES,b.Rate,b.amt,b.Penalamt,b.extramt,b.FIELDCODE,b.BILLNO,b.DANDI,b.ALLOWPAY,b.PAIDSTATUS,b.PAIDDATE,iif(r.balqty>0,r.balqty,4*b.finsqmt) as ybalqty,;
iif(r.rate>0,r.rate,1000) as yrate,iif(r.balqty>0,r.balqty,4*b.finsqmt)* iif(r.rate>0,r.rate,1000) as yrnamt,b.ORDER_TYPE, b.SPCL_INST,;
b.Shipbrth, b.Shiplngth,b.SQMT,b.Invno,b.expdt,b.compcode,b.pname;
FROM Temp2 b; 
Left Join ycost3 r;
ON b.ol_no=r.ol_no;
ORDER BY b.bcode; 
INTO CURSOR temprepview

***Date Min and Max for Bill Made
Private m.StartDt,m.EndDt
Select Min(ExpDt) as Min_Date from  temprepview into cursor mindate
select mindate
m.StartDt=mindate->Min_Date
Select max(ExpDt) as Max_Date from  temprepview into cursor maxdate 
select maxdate
m.EndDt=maxdate->Max_Date
*********************************************

Select temprepview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form caexport.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form caexport.frx to printer prompt noconsole
Endcase
Endif
Return


