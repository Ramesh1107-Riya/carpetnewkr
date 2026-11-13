*Grsearchregisd.prg Search Issue/Recive/Lost-Damaged
 
Private m.max_graph, m.SupGrHd
m.SupGrHd=""
m.max_graph=0
*Local irdhead
SET DELETED ON
set procedure to catool
SET TALK OFF
SET SAFE OFF
Set Date to Briti
Set Century on
SET ANSI ON


DO grSTrimInfo      && Trim Information for Check Purpose !
Open Database Carpet Share

CREATE SQL VIEW temprepview AS SELECT *;
FROM Carpet!GrSupRegViw;
WHERE ccsMatch17(BCODE,DESIGN,SZCODE,QUALITY,ROOMS,FULLHALF,ORDER_TYPE,REMARK,MASTER_NR,REG_NR,IR,SUPPLIER,SUPIR);
ORDER BY SUPPLIER, ISSDT, DESIGN, SZCODE, QUALITY ASC

If !empty(m.psSupplier)
	Select max_graph,code;
	From Casupplr;
	Where Code= m.psSupplier;
	into cursor Max_GrSup
	
	Select Max_GrSup
	m.max_graph=max_graph
Endif

Do Case
	Case psSupIR="I"
		m.SupGrHd="Graph Due Report"
	Case psSupIR="R"
		m.SupGrHd="Graph Return Report"
	Case psSupIR=""
		m.supGrHd="Graph Issue/ Return Report"
Endcase 

USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
Do Case
	Case m.PrnStat="V" .and. m.Option="A"
		Report form grsearchregs.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" .and. m.Option="B"
		Report form grsearchregs.frx to printer prompt noconsole
	Case  m.PrnStat="V" .and. m.Option="C" 
		EXPORT TO &exclfile TYPE XL5 FIELDS BCODE,DESIGN,SZCODE,QUALITY,ORDER_TYPE,REMARK,MASTER_NR,REG_NR,SUPIR,SUPPLIER,ISSDT,ISSRATE,RETDT,RETRATE
		Messagebox("Search Supplier Graph Transaction Report Successfully Exported to Excel, Open Excel, Select Folder-> Carpetnew , Search for Excel File") 
	Endcase
Endif
Return


* EoP()
