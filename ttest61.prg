Select i.PO_NO,i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.SZCODE,i.sqmt,i.po_dt,i.yrncaldt,b.issdt,b.issdt-i.po_dt as yrndurn,b.fdate,b.fdate-b.issdt as wevdurn,;
			b.issdtwash,b.rcddtwash,b.rcddtwash-b.issdtwash as washdurn,i.packno;
From cabuyord i;
Join casupord b;
On i.ol_no=b.ol_no .and. i.packno='19224';
Into Cursor CabuSup

Select i.PO_NO,i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.SZCODE,i.sqmt,i.po_dt,i.yrncaldt,i.issdt,i.yrndurn,i.fdate,i.wevdurn,i.issdtwash,i.rcddtwash,i.washdurn,b.invno,i.packno;
From CabuSup i;
Left Join Packtran b;
On i.ol_no=b.ol_no;
Into Cursor Temp

Select Temp
brow

*i.yrncaldt
*.and. b.cstatus<>"Exported"
*i.expdt-b.rcddtwash as pkdurn,i.invno,i.expdt,deli_date,explate,po_dt
*