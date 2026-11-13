Local m.carpetno

*m.Carpetno='200093/00217'
m.Carpetno='200053/00115'
SELECT ol_no,design,quality,colour,szcode,cstatus;
From Cabuyord;
WHERE ol_no=alltrim(m.Carpetno) .and. CStatus<>'NotDistri';
Having CStatus<>'On-Loom'