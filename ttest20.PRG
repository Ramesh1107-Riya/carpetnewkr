SELECT t.design,t.carpetno;
FROM TTSTOCK T,STKCARPET S;
WHERE alltrim(T.CARPETNO)=alltrim(S.CARPETNO);
Into table ttstock2


