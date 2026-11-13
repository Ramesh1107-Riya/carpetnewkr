*Cost Report 
SET DELETED ON
Set talk off
Set safe off
Set Date to Briti
Set Century on
SET ANSI ON

SET PROCEDURE TO CATOOL
DO csTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet

Select Bcode,Design,Quality,Knots,Type,Szcode,sqmt,wtsqmt,dgncompx,baserate,basemcost,costsqm,totcost,gtotal,datetime,exchnpr,washtype;
From Costcalc;
Where ccsMatch6d(BCODE, QUALITY, DESIGN, SZCODE) .AND. Datetime>=m.Startdt .and. Datetime<=m.Enddt .AND. ccsMatch4A(WASHTYPE);
Into Cursor Costsmy

*Where ccsMatch6d(BCODE, QUALITY, DESIGN, SZCODE) .AND. Datetime>=m.Startdt .and. Datetime<=m.Enddt .AND. ccsMatch4A(WASHTYPE)

SELECT Costsmy
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" 
		Report form costrepo.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" 
		Report form costrepo.frx to printer prompt noconsole
	Case  m.PrnStat="E" 
		EXPORT TO &exclfile TYPE XL5 FIELDS  Washtype,Bcode,Design,Quality,Knots,Type,Szcode,sqmt,wtsqmt,dgncompx,baserate,basemcost,costsqm,totcost,gtotal,exchrate
		Messagebox("Search Cost Summary Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File")
Endcase
Endif
Return

