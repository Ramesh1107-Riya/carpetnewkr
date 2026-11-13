*******Import any Excle file saved ins Excel95 format*** We take buyserial as single field A***It will replace old epcslno.dbf with new epcslno.dbf
MyFile = GETFILE("Excel *.xls:XLS","Import the excel file:","Import",0,"Choose the file to import")
IF NOT EMPTY(MyFile) THEN 
	IMPORT FROM JUSTFNAME(MyFile) TYPE XL8  && imports the XLS into a DBF
ENDIF 
****************************************************************************************************************************************************