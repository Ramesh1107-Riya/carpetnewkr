* ON-LOOM
*YRNCALDT AS BUY_DELIDT
*DELIRY_DT AS SUP_ESTDT
*YRNCALDT-PO_DT AS BUY_DELIDAY
*YRNCALDT-DATE() AS REMAINDAY
*(YRNCALDT-PO_DT)-(YRNCALDT-DATE()) AS PASSDAY
SET DELETED ON
Set talk off
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

SET PROCEDURE TO CATOOL
DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

Select i.PO_NO,i.BCODE,i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.SZCODE,i.WashType,i.spcl_inst,i.notes,i.skuno,i.comment,i.packno,i.po_dt,i.cstatus,i.breadth,i.length,i.sqmt,;
i.yrncaldt as buy_delidt,i.deliry_dt as sup_estdt,b.wev_last_dt as wevlastdt,b.issdt,b.supplier,i.yrncaldt-i.po_dt as buy_delday,b.wev_last_dt-b.issdt as wevday,;
b.issdt-i.po_dt as yarnday,date()-b.issdt as LoomDay,date()-yrncaldt as Remainday;
From cabuyord i;
Join casupord b;
On i.ol_no=b.ol_no;
Where  PO_DT>=m.Startdt .and. PO_DT<=m.Enddt .and. empty(b.fdate) .and. !empty(b.issdt) ;
Into table Tempb


Select PO_NO,BCODE,OL_NO,QUALITY,DESIGN,COLOUR,SZCODE,WashType,spcl_inst,notes,skuno,comment,cstatus,packno,breadth,length,sqmt,buy_delidt,sup_estdt,po_dt,;
		 wevday,buy_delday,wevlastdt,issdt,supplier,yarnday,LoomDay,Remainday,(iif(yarnday>0,yarnday,0)+iif(LoomDay>0,LoomDay,0)) as totalday;
From Tempb;
Order by po_no,cstatus;
Into table Temp

SELECT *;
FROM TEMP;
WHERE ccsMatch6C(BCODE, PO_NO, QUALITY, DESIGN, SZCODE, COLOUR, WashType);
ORDER BY po_no,cstatus;
INTO CURSOR Tempfinal

SELECT Tempfinal
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" 
		Report form cadurnreplom.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" 
		Report form cadurnreplom.frx to printer prompt noconsole
	**Data Export to Excel	
	Case  m.PrnStat="S" .and. m.Option="C"
		EXPORT TO &exclfile TYPE XL5 FIELDS PO_NO,BCODE,OL_NO,QUALITY,DESIGN,COLOUR,SZCODE,WashType,spcl_inst,notes,skuno,comment,cstatus,packno,breadth,length,;
			sqmt,po_dt,wevlastdt,issdt,supplier,buy_delidt,sup_estdt,wevday,yarnday,LoomDay,totalday,Remainday
		Messagebox("Search Stage-wise Production Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File")
Endcase
Endif
Return
