*?STRTRAN('MY #1','#1','')
*??CHRTRAN("MyDesign 1",' ',space(2))
*?SUBSTR('abcdefg',3,4) 
*SELECT * FROM TCMTABLE1 WHERE Design Like [FLOWER%]

*This is used in Yarnchart Report
*Work for all Design, but for normal design last char is trunicated, try making word are not separated till last
*?CHRTRAN("MyDesign 1",' ',space(0)) && Removes between space 
Local m.design,m.Len1,m.design1
m.design='FLOWER F'
m.Len1=LEN(CHRTRAN(m.Design,'',space(0))) &&Removes between space and Length is given
m.Design1=SUBSTR(m.Design,1,m.len1-1) && Trying to remove last char,START FROM 1 till len-1

SELECT *;
FROM TCMTABLE1;
WHERE Design=m.Design1 .and. bcode='W'  && show only  FLOWER,Flower S,FLOWER P,FLOWER F
