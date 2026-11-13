SET DELETED ON
SET TALK OFF
SET SAFE OFF
Set Date to Briti
Set Century on
SET ANSI ON

SELECT b.BCODE,s.CARPETNO,b.PO_NO,b.PO_DT,b.CTRL_NO, b.OL_NO,b.YRNCALDT,b.DESIGN,QUALITY,COLOUR,b.SZCODE,b.BREADTH,b.LENGTH,b.SQMT,b.SPCL_INST,b.Packno,b.shbr,b.shln,b.blno,b.pkcomment,b.WASHTYPE;
FROM  Cabuyord b;
Inner Join Casupord s;
On b.ol_no=s.ol_no;
WHERE !empty(fdate);
UNION ALL;
SELECT BCODE, CARPETNO, PO_NO, PO_DT, CTRL_NO, OL_NO,YRNCALDT, DESIGN,QUALITY,SUBSTR(COLOUR,1,10) AS COLOUR,SZCODE,BREADTH,LENGTH,SQMT,SPCL_INST,Packno,shbr,shln,blno,pkcomment,WASHTYPE;
FROM  Stkcarpet;		
Into cursor buysupstk

Select b.BCODE,i.name,b.CARPETNO,b.PO_NO,b.PO_DT,b.CTRL_NO, b.OL_NO,b.YRNCALDT,b.DESIGN,b.QUALITY,b.COLOUR,b.SZCODE,b.BREADTH,b.LENGTH,b.SQMT,b.SPCL_INST,b.Packno,b.shbr,b.shln,b.blno,b.pkcomment,b.WASHTYPE;
From buysupstk b,cabuyer i;
Where b.bcode=i.bcode;
Into Cursor bsstk 


select bsstk
brow
close all

*More Fields 6//11/2019 Joins
************
*SELECT b.BCODE,s.CARPETNO,b.PO_NO,b.PO_DT,b.CTRL_NO, b.OL_NO,b.YRNCALDT,b.DESIGN,QUALITY,COLOUR,b.SZCODE,b.BREADTH,b.LENGTH,b.SQMT,b.SPCL_INST,b.CSTATUS,b.NOTES,b.SKUNO,b.ORDER_TYPE,b.FIELDCODE,b.WASHTYPE,b.CTYPE,b.COMMENT,b.Label,b.Packno,b.shbr,b.shln,b.blno,b.pkcomment;
*FROM  Cabuyord b;
*Inner Join Casupord s;
*On b.ol_no=s.ol_no;
*WHERE !empty(fdate);
*UNION ALL;
*SELECT BCODE, CARPETNO, PO_NO, PO_DT, CTRL_NO, OL_NO,YRNCALDT, DESIGN,QUALITY,SUBSTR(COLOUR,1,10) AS COLOUR,SZCODE,BREADTH,LENGTH,SQMT, SPCL_INST, CSTATUS,SUBSTR(NOTES,1,30) AS NOTES,SKUNO,ORDER_TYPE, FIELDCODE, WASHTYPE,CTYPE,COMMENT,Label,Packno,shbr,shln,blno,pkcomment;
*FROM  Stkcarpet;		
*Into table buysupstk