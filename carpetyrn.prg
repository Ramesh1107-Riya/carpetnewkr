SET DELETED ON
SET TALK OFF
SET SAFE OFF

	*1*Yarn Issued to Supplier
If !empty(m.Party)
	Select PO_No,Party,sum(Quantity) as Qty;
	From Wiissue;
	Where Party=m.Party;
	Group by PO_No,Party;
	Into Cursor wis

	*2*Carpet Issued to Supplier
	Select b.Ol_no,b.Po_no,b.Po_dt,sum(b.sqmt) as sqmt,s.supplier;
	From Cabuyord b,Casupord s;
	Where b.ol_no=s.ol_no;
	HAVING s.Supplier=m.Party;
	Group by b.po_no,s.supplier;
	Into Cursor ciss
Else
	*1*Yarn Issued to Supplier
	Select PO_No,Party,sum(Quantity) as Qty;
	From Wiissue;
	Group by PO_No,Party;
	Into Cursor wis

	*2*Carpet Issued to Supplier
	Select b.Ol_no,b.Po_no,b.Po_dt,sum(b.sqmt) as sqmt,s.supplier;
	From Cabuyord b,Casupord s;
	Where b.ol_no=s.ol_no;
	Group by b.po_no,s.supplier;
	Into Cursor ciss
Endif

*1 & 2 together
If empty(m.Party)
	Select a.Po_no,a.Po_dt,a.Supplier,a.sqmt,b.Qty,b.qty/a.sqmt as avgqty;
	From ciss a;
	Left Join wis b;
	On a.po_no=b.po_no;
	Group by a.Po_No,a.Supplier;
	Order by a.Supplier,a.PO_dt;
	Where a.po_dt=>m.startdt .and. a.po_dt=<m.enddt;
	Into Cursor sqmtyrn
Else
	Select a.Po_no,a.Po_dt,a.Supplier,a.sqmt,b.Qty,b.qty/a.sqmt as avgqty;
	From ciss a;
	Left Join wis b;
	On a.po_no=b.po_no;
	Group by a.Po_No,a.Supplier;
	Order by a.Supplier,a.PO_dt;
	Where a.po_dt=>m.startdt .and. a.po_dt=<m.enddt .and. a.Supplier=m.Party;
	Into Cursor sqmtyrn
Endif

Select Sqmtyrn
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form CarpetYrn.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport	
	Case m.PrnStat="P"
		Report form CarpetYrn.frx to printer prompt noconsole
Endcase
Endif
RETURN


