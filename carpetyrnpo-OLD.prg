SET DELETED ON
SET PROCEDURE TO Catool
SET TALK OFF
SET SAFE OFF
Set Date to Briti
SET ANSI ON

*DO csTrimInfo5      && Trim Information for Check Purpose !
Open Database Carpet
Do Case	
	Case !empty(m.po_no) .and. !empty(m.party) && 1
			*1*Yarn Issued to Supplier
			Select PO_No,Party,sum(Quantity) as Qty;
			From Wiissue;
			Where po_no=m.po_no .and. Party=m.Party;
			Group by PO_No;
			Into Cursor wis

			*2*Carpet Issued to Supplierb
			Select b.Ol_no,b.Po_no,b.Po_dt,b.bcode,b.design,b.quality,sum(b.sqmt) as sqmt,s.supplier,b.Washtype;
			From Cabuyord b,Casupord s;
			Where b.ol_no=s.ol_no .and. b.Po_no=m.Po_no .AND. ccsMatch4A(WASHTYPE);
			Group by b.po_no,s.supplier;
			Into Cursor ciss
			
			*1 & 2 together
			Select a.Po_no,a.Po_dt,a.bcode,a.design,a.quality,a.Supplier,a.sqmt,b.Qty,b.qty/a.sqmt as avgqty,a.Washtype;
			From ciss a;
			Inner Join wis b;
			On a.po_no=b.po_no .and. a.Supplier=b.Party .and. a.po_no=m.po_no; 
			Where a.po_dt=>m.startdt .and. a.po_dt=<m.enddt .AND. ccsMatch4A(WASHTYPE);
			Order by a.supplier;
			Into Cursor sqmtyrn
		
	Case !empty(m.po_no) .and. empty(m.party)	&& 2	
			*1*Yarn Issued to Supplier
			Select PO_No,Party,sum(Quantity) as Qty;
			From Wiissue;
			Where po_no=m.po_no ;
			Group by PO_No;
			Into Cursor wis

			*2*Carpet Issued to Supplierb
			Select b.Ol_no,b.Po_no,b.Po_dt,b.bcode,b.design,b.quality,sum(b.sqmt) as sqmt,s.supplier,b.Washtype;
			From Cabuyord b,Casupord s;
			Where b.ol_no=s.ol_no .and. b.Po_no=m.Po_no .AND. ccsMatch4A(WASHTYPE);
			Group by b.po_no,s.supplier;
			Into Cursor ciss
			
			*1 & 2 together
			Select a.Po_no,a.Po_dt,a.bcode,a.design,a.quality,a.Supplier,a.sqmt,b.Qty,b.qty/a.sqmt as avgqty,a.Washtype;
			From ciss a;
			Inner Join wis b;
			On a.po_no=b.po_no .and. a.po_no=m.po_no; 
			Where a.po_dt=>m.startdt .and. a.po_dt=<m.enddt .AND. ccsMatch4A(WASHTYPE);
			Order by a.supplier;
			Into Cursor sqmtyrn
			
	Case empty(m.po_no) .and. !empty(m.party) && 3
			*1*Yarn Issued to Supplier
			Select PO_No,Party,sum(Quantity) as Qty;
			From Wiissue;
			Where Party=m.Party;
			Group by PO_NO;
			Into Cursor wis

			*2*Carpet Issued to Supplierb
			Select b.Ol_no,b.Po_no,b.Po_dt,b.bcode,b.design,b.quality,sum(b.sqmt) as sqmt,s.supplier,b.Washtype;
			From Cabuyord b,Casupord s;
			Where b.ol_no=s.ol_no .and. s.Supplier=m.Party .AND. ccsMatch4A(WASHTYPE);
			Group by b.po_no,s.supplier;
			Into Cursor ciss
			
			*1 & 2 together
			Select a.Po_no,a.Po_dt,a.bcode,a.design,a.quality,a.Supplier,a.sqmt,b.Qty,b.qty/a.sqmt as avgqty,a.Washtype;
			From ciss a;
			Inner Join wis b;
			On a.po_no=b.po_no .and. a.Supplier=b.Party;
			Where a.po_dt=>m.startdt .and. a.po_dt=<m.enddt .AND. ccsMatch4A(WASHTYPE);
			Order by a.supplier;
			Into Cursor sqmtyrn

	Case empty(m.po_no) .and. empty(m.party) && 4
			*1*Yarn Issued to Supplier
			Select PO_No,Party,sum(Quantity) as Qty;
			From Wiissue;
			Group by PO_NO,Party;
			Into Cursor wis

			*2*Carpet Issued to Supplierb
			Select b.Ol_no,b.Po_no,b.Po_dt,b.bcode,b.design,b.quality,sum(b.sqmt) as sqmt,s.supplier,b.Washtype;
			From Cabuyord b,Casupord s;
			Where b.ol_no=s.ol_no .AND. ccsMatch4A(WASHTYPE);
			Group by b.po_no,s.supplier;
			Into Cursor ciss
			
			*1 & 2 together
			Select a.Po_no,a.Po_dt,a.bcode,a.design,a.quality,a.Supplier,a.sqmt,b.Qty,b.qty/a.sqmt as avgqty,a.Washtype;
			From ciss a;
			Inner Join wis b;
			On a.po_no=b.po_no;
			Where a.po_dt=>m.startdt .and. a.po_dt=<m.enddt .AND. ccsMatch4A(WASHTYPE);
			Order by a.supplier;
			Into Cursor sqmtyrn
Endcase

Select Sqmtyrn
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		Report form CarpetYrnpo.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport	
	Case m.PrnStat="P"
		Report form CarpetYrnpo.frx to printer prompt noconsole
Endcase
Endif
RETURN


