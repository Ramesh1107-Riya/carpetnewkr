****We focus for PO Report in  NotDistributed Carpet
SET PROCEDURE TO Catool
DO csTrimInfo      && Trim Information for Check Purpose !
CREATE CURSOR UpdatBuyOrd(BCODE C(10),PO_NO C(12),DELIRY_DT D(8), PO_DT D(8),OL_NO C(15),DESIGN C(20),COLOUR C(10),SZCODE C(11),;
			SQMT N(6,2),QUALITY C(12),ORDER_TYPE C(7),CARPETNO C(7),issdt D(8),fdate D(8),supplier C(20),CSTATUS C(9),DATETIME D(8))

SELECT UpdatBuyOrd
Appen From Cabuyord

Select ol_no,carpetno,issdt,fdate,supplier;
From CaSupOrd;
Order by ol_no;
Into Cursor cSupOrd 

*******Updating 2 files*************************
select cSupOrd && values come FROM this table 
Index on ol_no to supol_no
set order to supol_no

Select UpdatBuyOrd 
Index on ol_no to updatol_no
set order to updatol_no

do while .not. eof()
update  UpdatBuyOrd ;
set carpetno=cSupOrd->carpetno,issdt=cSupOrd->issdt,fdate=cSupOrd->fdate,supplier=cSupOrd->supplier ;
Where ol_no=cSupOrd->ol_no
	Select cSupOrd 
	If .not. eof()
		skip
	Endif
enddo
*******************************

Private WhereString

Do Case
	Case !empty(m.psSupplier)
		WhereString='ccsMatch8(BCODE, PO_NO, QUALITY, ORDER_TYPE) .and. supplier=alltrim(m.psSupplier)'	
	case !empty(m.psCStatus)
		WhereString='ccsMatch8(BCODE, PO_NO, QUALITY, ORDER_TYPE) .and. Cstatus=alltrim(m.psCStatus)'	
	case !empty(m.psCStatus).and. !empty(m.psSupplier)
		WhereString='ccsMatch8(BCODE, PO_NO, QUALITY, ORDER_TYPE) .and. supplier=alltrim(m.psSupplier) .and. Cstatus=alltrim(m.psCStatus'
	case empty(m.psCStatus).or. empty(m.psSupplier)
		WhereString='ccsMatch8(BCODE, PO_NO, QUALITY, ORDER_TYPE)'
Endcase
		SELECT *;
		FROM UpdatBuyOrd;
		WHERE &WhereString .and. po_dt>=m.Text1 .and. po_dt<=m.Text2;
		ORDER By Datetime;
		INTO CURSOR Poview

SELECT Poview
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V"
		Report form reppo.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form reppo.frx to printer prompt noconsole
	Case  m.PrnStat="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,PO_NO, DELIRY_DT, PO_DT, OL_NO, CARPETNO, DESIGN, COLOUR, SZCODE, SQMT, QUALITY,;
				issdt,fdate,supplier,CSTATUS
		Messagebox("PO of All Order Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File")
Endcase
Endif
Return


