*Yarn Issue/Return to Supplier Multiple Report
SET DELETED ON
SET PROCEDURE TO Catool
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

DO csTrimInfo11      && Trim Information for Check Purpose !
Open Database Carpet

SELECT s.issdt,b.ol_no,b.bcode,s.supplier,b.design,b.colour,b.quality,b.po_no,sum(b.qty) as qty,sum(b.sqmt) as sqmt;
FROM Carpet!cabuyord b;
JOIN Carpet!casupord s;
ON b.ol_no=s.ol_no;
WHERE s.issdt<>{//} ;
ORDER BY b.bcode,b.design,b.quality,b.colour;
GROUP BY b.bcode,b.design,b.quality,b.colour;
Into cursor ctmp3

SELECT b.issdt,b.ol_no,b.po_no,b.bcode,b.supplier,b.design,b.qty,b.sqmt,y.caqlty as quality,y.pno,y.quality as yrnqlty,y.colour,y.ibillno,y.sissqty,y.sissdt,y.srate,y.rbillno,y.sretdt,y.sretqty,y.rackno;
From ctmp3 b;
JOIN yrnissrecsup y;
ON y.bcode=b.bcode .and. y.design=b.design .and. y.caqlty=b.quality .and. y.basecolour=b.colour .and. y.SISSDT>=m.Text1 .and. y.SISSDT<=m.Text2;
Into cursor tempsup

SELECT *;
FROM tempsup;
WHERE ccsMatch22(Supplier,Bcode,Quality,DESIGN,PO_NO,OL_NO) .AND. ccsMatch22A(YrnQlty);
ORDER BY OL_NO;
INTO CURSOR cYrntemp1

SELECT cYrntemp1
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form repdyesupmul.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form repdyesupmul.frx to printer prompt noconsole
	Case  m.PrnStat="A" 
		EXPORT TO &exclfile TYPE XL5 FIELDS issdt,ol_no,po_no,bcode,supplier,design,qty,sqmt,quality,pno,yrnqlty,colour,ibillno,sissqty,sissdt,srate,rbillno,sretdt,sretqty,rackno
		Messagebox("Search Production Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 	
		
Endcase
Endif
Return
