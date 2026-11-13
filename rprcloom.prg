*With/ Without Loom Date PRC report, With Loom Date, Without Loom Date
Set Date to Briti
Set Century on
SET ANSI ON

SET PROCEDURE TO Catool
DO csTrimInfo
&& Trim Information for Check Purpose !
Open Database Carpet
Do Case
  Case m.Option1=1
	*With Loom Date (On Loom PRC, Started carpet)
	SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN,b.QUALITY, b.COLOUR, b.SZCODE, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT,b.Deliry_dt,;
		 	 b.ORDER_TYPE, b.BCODE, b.SPCL_INST, b.FRINGES, b.WASHTYPE,s.GRADE,s.LOOMDT,s.WEV_CM, s.WEV_CMDT,s.WEV_DT,b.CTRL_NO,s.CATEGORY;	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.loomdt) .and. empty(s.Fdate) .and. s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text2;
    ORDER BY s.Weaver,s.ISSDT,b.OL_NO ASC;
    INTO Cursor Temp2
 
  Case m.Option2=1
    *Without Loom Date (Distributed but Not Started) 
	SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN,b.QUALITY, b.COLOUR, b.SZCODE, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT,b.Deliry_dt,;
		 	 b.ORDER_TYPE, b.BCODE, b.SPCL_INST, b.FRINGES, b.WASHTYPE,s.GRADE,s.LOOMDT,s.WEV_CM, s.WEV_CMDT,s.WEV_DT, b.CTRL_NO,s.CATEGORY;	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. empty(s.loomdt) .and. s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text2;
    ORDER BY s.Weaver,s.ISSDT,b.OL_NO ASC;
    INTO Cursor Temp2
	
  Case m.Option3=1
	* With/ Without Loom Date (NotDistri + Started)
	SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN,b.QUALITY, b.COLOUR, b.SZCODE, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT,b.Deliry_dt,;
		 	 b.ORDER_TYPE, b.BCODE, b.SPCL_INST, b.FRINGES, b.WASHTYPE,s.GRADE,s.LOOMDT, s.SUPPLIER,b.CTRL_NO,s.CATEGORY,s.ESTSHIP_DT,s.WEV_CM,s.WEV_CMDT,s.WEV_DT; 	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.ISSDT) .and. empty(s.Fdate) .and. s.ISSDT>=m.Text1 .and. s.ISSDT<=m.Text2;
    ORDER BY s.Supplier,s.Weaver,s.ISSDT,b.OL_NO ASC;
    INTO Cursor Temp2
Endcase

	SELECT *;
	FROM Temp2;
	WHERE ccsMatch4(Weaver) .and. ccsMatch7(BCODE, PO_NO, CTRL_NO, OL_NO, QUALITY, DESIGN, SZCODE, COLOUR, ORDER_TYPE, WASHTYPE, CATEGORY);
	Into Cursor Temp3
	
Select Temp3
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	*With Loom Date
	Case m.PrnStat="V" .and. m.Option1=1
		Report form prconloom.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option1=1
		Report form prconloom.frx to printer prompt noconsole

	*Without Loom Date
	Case m.PrnStat="V"  .and. m.Option2=1
		Report form prcwoloomdt.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option2=1
		Report form prcwoloomdt.frx to printer prompt noconsole

	*With/ Without Loom Date
	Case m.PrnStat="V" .and. m.Option3=1
		Report form prcloom.frx PREVIEW WINDOW wReport
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option3=1
		Report form prcloom.frx to printer prompt noconsole
	**Export to Excel	
	Case m.PrnStat="E"
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,PO_NO, OL_NO, DESIGN,QUALITY,COLOUR,SZCODE,SQMT,ISSDT,WEV_LAST_DT,Deliry_dt,ORDER_TYPE,WASHTYPE,LOOMDT,WEAVER,WEV_CM,WEV_CMDT,WEV_DT	
		Messagebox("Search Production Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
Endcase
Endif 
Return

	