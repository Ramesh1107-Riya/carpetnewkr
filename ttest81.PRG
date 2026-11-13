Local m.startdt,m.Enddt
m.Startdt={^2018/01/31}
m.Enddt={^2023/04/24}

SELECT BCODE, PO_NO, QUALITY, DESIGN, SZCODE, SUBSTR(COLOUR,1,10) AS COLOUR,SQMT,PO_DT,Packno,BLNO,CSTATUS;
FROM  Stkcarpet;
WHERE cstatus<>"Exported" .and. PO_DT>=m.Startdt .and. PO_DT<=m.Enddt;
UNION ALL;
SELECT  BCODE, PO_NO, QUALITY, DESIGN, SZCODE, SUBSTR(COLOUR,1,10) AS COLOUR,SQMT,PO_DT,Packno,BLNO,CSTATUS;
FROM  Cabuyord;
WHERE cstatus<>"Exported" .and. PO_DT>=m.Startdt .and. PO_DT<=m.Enddt;
Into cursor  BUYSTA1

Select sum(sqmt) as sqmt;
From BUYSTA1


SELECT BCODE, PO_NO, QUALITY, DESIGN, SZCODE, SUBSTR(COLOUR,1,10) AS COLOUR,SQMT,PO_DT,Packno,BLNO,CSTATUS;
FROM  Stkcarpet;
WHERE cstatus<>"Exported";
UNION ALL;
SELECT  BCODE, PO_NO, QUALITY, DESIGN, SZCODE, SUBSTR(COLOUR,1,10) AS COLOUR,SQMT,PO_DT,Packno,BLNO,CSTATUS;
FROM  Cabuyord;
WHERE cstatus<>"Exported";
Into cursor  BUYSTA2

Select sum(sqmt) as sqmt;
From BUYSTA2

SELECT sum(SQMT) as Sqmt;
FROM  Stkcarpet;
WHERE cstatus<>"Exported"

SELECT sum(SQMT) as Sqmt;
FROM  Cabuyord;
WHERE cstatus<>"Exported"

Select sum(sqmt) as sqmt;
From BUYSTA2
