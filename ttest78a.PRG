*SELECT OL_NO,Design,quality,SQMT,SPCL_INST,CSTATUS, WASHTYPE,SCODE;
*FROM  Stkcarpet;
*WHERE cstatus<>"Exported"

SELECT b.BCODE,s.CARPETNO,b.PO_NO,b.PO_DT,b.CTRL_NO, b.OL_NO,b.DESIGN,QUALITY,COLOUR,b.SZCODE,b.BREADTH,b.LENGTH,b.SQMT,b.SPCL_INST,b.CSTATUS,b.NOTES,b.SKUNO,b.ORDER_TYPE,b.FIELDCODE,b.WASHTYPE,b.CTYPE,b.COMMENT;
FROM  Cabuyord b;
Inner Join Casupord s;
On b.ol_no=s.ol_no;
WHERE b.cstatus<>"Exported" .and. !empty(fdate) .and. empty(b.scode);
Into cursor test5


SELECT b.BCODE,s.name,CARPETNO,b.PO_NO,b.PO_DT,b.CTRL_NO, b.OL_NO,b.DESIGN,b.QUALITY,b.COLOUR,b.SZCODE,b.BREADTH,b.LENGTH,b.SQMT,b.SPCL_INST,b.CSTATUS,b.NOTES,b.SKUNO,b.ORDER_TYPE,b.FIELDCODE,b.WASHTYPE,b.CTYPE,b.COMMENT;
FROM  test5 b;
Inner Join cabuyer s;
On b.bcode=s.bcode;
Into table test6

use test6
brow