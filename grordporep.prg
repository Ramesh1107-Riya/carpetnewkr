*GRORDREP Find the PO_NO wise Order crossesponding Graph

SET DELETED ON
SET TALK OFF
SET SAFE OFF

PROCEDURE GRORDMATCH
Private m.allpcs, m.unmatchpcs, m.matchpcs, m.totmatdgn

SELECT  design, szcode, quality, bcode, order_type, po_no, Po_dt;
FROM Cabuyord;
WHERE po_no=alltrim(m.po_no);
Into Cursor buytemp1
m.allpcs=Reccount("buytemp1")

*eoq  && end of query

* 1 Find Not Matching record in Graph Stock with Order pcs
SELECT  b.design, b.szcode, b.quality, b.bcode, b.order_type, b.po_no, b.Po_dt;
FROM buytemp1 b;
ORDER BY b.design, b.szcode, b.quality;
WHERE .NOT. EXISTS(SELECT * FROM GRREGSTR r;
			WHERE b.bcode  = r.bcode .and. ;
				  b.design = r. design .and. ;
				  b.szcode = r.szcode .and. ;
				  b.quality= r.quality);
INTO cursor UnmatOrd
m.unmatchpcs=Reccount("UNmatOrd")

SELECT design,count(design) umdgncnt;
From UnMatOrd;
Group by design;
Order by design;
Into cursor UnMatord2

Dimension Arydgn(40,2)
Store ' ' to Arydgn
Select UnMatord2
Copy to ARRAY Arydgn FIELD Design, umdgncnt


* 2 Stock Graph Already issued to Supplier
SELECT  b.design, b.szcode, b.quality, r.supplier, r.reg_nr, r.issdt,r.SupIr;
FROM GrSupTran r, buytemp1 b, Grregstr g;
Order by b.design, b.szcode, b.quality;
WHERE r.reg_nr=g.reg_nr .and. ;
	  b.bcode  = g.bcode .and. ;
	  b.design = g. design .and. ;
	  b.szcode = g.szcode .and. ;
	  b.quality= g.quality ;
INTO cursor suptemp

Select *;
From Suptemp;
WHERE SupIr="I";
INTO cursor suptemp1

SELECT design,count(design) SupDgn;
From Suptemp1;
Group by design;
Order by design;
Into cursor SupIss

Dimension Arydgn1(40,2)
Store ' ' to Arydgn1
Select SupIss
Copy to ARRAY Arydgn1 FIELD Design, SupDgn


* 3 Available Master Graph for above Unmatched Design
SELECT r.master_nr, r.design, r.szcode, r.quality;
FROM grmaster r, UnMatOrd u;
WHERE r.design = u.design .and.;
      r.szcode = u.szcode .and.;
      r.quality= u.quality .and.;
      r.bcode  = u.bcode;
INTO CURSOR Mastergr1

SELECT Design, count(design) Mastdgn;
FROM Mastergr1;
Group by design;
Order by design;
Into Cursor mastergr2

Dimension Arydgn2(40,2)
Store '' to Arydgn2
Select Mastergr2
Copy to ARRAY Arydgn2 Field Design,Mastdgn

* 4 Total Matched Order crossesponding to Stock Graph Register
SELECT distinct  r.reg_nr, r.master_nr, b.design, b.szcode, b.quality, b.bcode, r.order_type, r.ir ;
FROM  GRREGSTR r, buytemp1 b;
WHERE b.bcode  = r.bcode  .and.;
	  b.design = r.design .and.;
	  b.szcode = r.szcode .and.;
	  b.quality= r.quality .and.;
	  r.IR="S"; && IR=is Issue and Stock ; for Return we have seperate field Ret
HAVING  b.po_no = m.po_no;
ORDER BY b.design, b.szcode, b.quality;
INTO CURSOR MatchOrdGr NOFILTER

m.matchpcs=reccount("MatchOrdGr")

Select MatchOrdGr
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form GrOrdMatch.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form GrOrdMatch.frx to printer prompt noconsole
Endcase
Endif
Return
*eop




********************Detail Individual Report*******************************************
*Program to Show Detail Report of 1,2,3 
*1. No Matching Graphs for given order (po_no)
*2. Matching Stock Graph Already Issued to Supplier
*3. Available Master Graph for No.1 (Not Matching Graph)


*Find the PO_NO wise Order crossesponding Graph
PROCEDURE BUYERPO
SELECT design, szcode, quality, bcode, order_type, po_no, Po_dt;
FROM Cabuyord;
WHERE po_no=m.po_no;
Into Cursor buytemp1

*eoq  && end of query

* 1 Find Not Matching record in Graph Stock with Order pcs
PROCEDURE NOMATCH
SELECT  b.design, b.szcode, b.quality, b.bcode, b.order_type, b.po_no, b.Po_dt;
FROM buytemp1 b;
ORDER BY b.design, b.szcode, b.quality;
WHERE .NOT. EXISTS(SELECT * FROM GRREGSTR r;
			WHERE b.bcode   = r.bcode .and. ;
				  b.design = r. design .and. ;
				  b.szcode = r.szcode .and. ;
				  b.quality= r.quality);
INTO cursor UnMatOrd NOFILTER

Select UnMatOrd
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form GrNoMatch.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form GrNoMatch.frx to printer prompt noconsole
Endcase
Endif
Return
*eop

* 2 Stock Graph Already issued to Supplier
PROCEDURE SUPPLYISS
SELECT b.design, b.szcode, b.quality, r.supplier, r.issdt, r.reg_nr, r.SupIr;
FROM GrSupTran r, buytemp1 b, Grregstr g;
Order by b.design, b.szcode, b.quality;
WHERE r.reg_nr=g.reg_nr .and. ;
	  b.bcode  = g.bcode .and. ;
	  b.design = g. design .and. ;
	  b.szcode = g.szcode .and. ;
	  b.quality= g.quality ;
INTO cursor suptemp


Select *;
From Suptemp;
WHERE SupIr="I";
INTO cursor suptemp1 NOFILTER


Select Suptemp1
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form GrSupIss.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form GrSupIss.frx to printer prompt noconsole
Endcase
Endif
Return

*eop

* 3 Available Master Graph for above Unmatched Design
PROCEDURE MASTMACH
SELECT  b.design, b.szcode, b.quality, b.bcode, b.order_type, b.po_no, b.Po_dt;
FROM buytemp1 b;
ORDER BY b.design, b.szcode, b.quality;
WHERE .NOT. EXISTS(SELECT * FROM GRREGSTR r;
			WHERE b.bcode   = r.bcode .and. ;
				  b.design = r. design .and. ;
				  b.szcode = r.szcode .and. ;
				  b.quality= r.quality);
INTO cursor UnmatOrd 


SELECT u.design, u.szcode, u.quality, r.master_nr;
FROM grmaster r, UnMatOrd u;
WHERE r.design = u.design .and.;
      r.szcode = u.szcode .and.;
      r.quality= u.quality .and.;
      r.bcode  = u.bcode;
INTO CURSOR MastGr NOFILTER

Select MastGr
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form GrMastUnM.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form GrMastUnM.frx to printer prompt noconsole
Endcase
Endif
Return

*eop

*5 PO Report
PROCEDURE BUYERPO2
Open database carpet share
CREATE SQL VIEW Poview2 AS SELECT design, szcode, quality, bcode, order_type, po_no, Po_dt, deliry_dt, ol_no, colour, sqmt;
FROM Carpet!Cabuyord;
WHERE po_no=alltrim(m.po_no);
ORDER BY Design,szcode,ol_no



Use Poview2 share
set color to
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form grpo.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form grpo.frx to printer prompt noconsole
Endcase
Endif
Return

				