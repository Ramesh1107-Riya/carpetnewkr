SELECT b.BCODE,b.PO_NO,b.Po_Dt,s.CARPETNO,b.OL_NO,b.CSTATUS,b.SPCL_INST,b.CTRL_NO,b.NOTES, b.QUALITY,b.DESIGN,b.SZCODE,b.SQMT,b.COLOUR,s.SUPPLIER,s.ISSDT,s.FDATE,b.Deliry_Dt,b.Skuno;
FROM  Cabuyord b;
LEFT JOIN Casupord s;
ON b.ol_no = s.ol_no;
WHERE b.cstatus!="Exported";
Into Cursor  Temp1

SELECT BCODE,PO_NO,Po_Dt,CARPETNO,OL_NO,CSTATUS,SPCL_INST,CTRL_NO,Skuno,NOTES,QUALITY,DESIGN,SZCODE,SQMT,COLOUR,SUPPLIER,ISSDT,FDATE,Deliry_Dt;
FROM  Temp1;
Order by PO_No,Carpetno,ol_no; 
WHERE cstatus!="Packed"
