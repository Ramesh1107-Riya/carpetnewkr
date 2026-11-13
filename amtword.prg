*This program is use to convert any amount of figure into its corresponding words.
 
parameter tamt, tdesc, paise
dimension array(1,99)
array(1,1)='One'
array(1,2)='Two'
array(1,3)='Three'
array(1,4)='Four'
array(1,5)='Five'
array(1,6)='Six'
array(1,7)='Seven'
array(1,8)='Eight'
array(1,9)='Nine'
array(1,10)='Ten'
array(1,11)='Eleven'
array(1,12)='Twelve'
array(1,13)='Thirteen'
array(1,14)='Fourteen'
array(1,15)='Fifteen'
array(1,16)='Sixteen'
array(1,17)='Seventeen'
array(1,18)='Eighteen'
array(1,19)='Nineteen'
array(1,20)='Twenty'
array(1,21)='Twenty One'
array(1,22)='Twenty Two'
array(1,23)='Twenty Three'
array(1,24)='Twenty Four'
array(1,25)='Twenty Five'
array(1,26)='Twenty Six'
array(1,27)='Twenty Seven'
array(1,28)='Twenty Eight'
array(1,29)='Twenty Nine'
array(1,30)='Thirty'
array(1,31)='Thirty One'
array(1,32)='Thirty Two'
array(1,33)='Thirty Three'
array(1,34)='Thirty Four'
array(1,35)='Thirty Five'
array(1,36)='Thirty Six'
array(1,37)='Thirty Seven'
array(1,38)='Thirty Eight'
array(1,39)='Thirty Nine'
array(1,40)='Forty'
array(1,41)='Forty One'
array(1,42)='Forty Two'
array(1,43)='Forty Three'
array(1,44)='Forty Four'
array(1,45)='Forty Five'
array(1,46)='Forty Six'
array(1,47)='Forty Seven'
array(1,48)='Forty Eight'
array(1,49)='Forty Nine'
array(1,50)='Fifty'
array(1,51)='Fifty One'
array(1,52)='Fifty Two'
array(1,53)='Fifty Three'
array(1,54)='Fifty Four'
array(1,55)='Fifty Five'
array(1,56)='Fifty Six'
array(1,57)='Fifty Seven'
array(1,58)='Fifty Eight'
array(1,59)='Fifty Nine'
array(1,60)='Sixty'
array(1,61)='Sixty One'
array(1,62)='Sixty Two'
array(1,63)='Sixty Three'
array(1,64)='Sixty Four'
array(1,65)='Sixty Five'
array(1,66)='Sixty Six'
array(1,67)='Sixty Seven'
array(1,68)='Sixty Eight'
array(1,69)='Sixty Nine'
array(1,70)='Seventy'
array(1,71)='Seventy One'
array(1,72)='Seventy Two'
array(1,73)='Seventy Three'
array(1,74)='Seventy Four'
array(1,75)='Seventy Five'
array(1,76)='Seventy Six'
array(1,77)='Seventy Seven'
array(1,78)='Seventy Eight'
array(1,79)='Seventy Nine'
array(1,80)='Eighty'
array(1,81)='Eighty One'
array(1,82)='Eighty Two'
array(1,83)='Eighty Three'
array(1,84)='Eighty Four'
array(1,85)='Eighty Five'
array(1,86)='Eighty Six'
array(1,87)='Eighty Seven'
array(1,88)='Eighty Eight'
array(1,89)='Eighty Nine'
array(1,90)='Ninety'
array(1,91)='Ninety One'
array(1,92)='Ninety Two'
array(1,93)='Ninety Three'
array(1,94)='Ninety Four'
array(1,95)='Ninety Five'
array(1,96)='Ninety Six'
array(1,97)='Ninety Seven'
array(1,98)='Ninety Eight'
array(1,99)='Ninety Nine'

store 0 to tlen
tlen=LEN(ALLTRIM(STR(tamt)))
paise=VAL(RIGHT(STR(tamt,10,2),2))
tamt=tamt-(paise/100)
*Below good for Cent but for NP Rug 10/01/2017
If paise>0
	paise='and '+Alltrim(Str(paise))+'/100 Only.'
else
	paise='Only.'
Endif
***working well below program instead of above***
*If paise>0
*	paise="And Cent"+" "+ALLTRIM(array(1,int(paise)))+ " Only."  && Paise changed to Cent for USD$
*else
*	paise="Only."
*Endif

If tamt>0
	do first with tamt,tlen
Else
	if len(alltrim(tdesc))>1
	else
		tdesc="Nil "
	Endif
Endif
return

**This procedure is use to control the overall controlling of amount into words.

PROCEDURE first
PARAMETER tamt,tlen
tlen=LEN(ALLTRIM(STR(INT(tamt))))
If tlen<=2
	if tamt<>0
		tdesc=ALLTRIM(tdesc)+" "+ALLTRIM(ARRAY(1,(INT(tamt))))
	endif
else
if tlen<=3
	hnum=VAL(SUBSTR(ALLTRIM(STR(tamt)),1,1))
	do second with hnum,tlen
else
if tlen<=4
	tnum=VAL(SUBSTR(ALLTRIM(STR(tamt)),1,1))
	do third with tnum,tlen
else
	if tlen<=5	
	tnum=VAL(SUBSTR(ALLTRIM(STR(tamt)),1,2))
	do third with tnum,tlen
else
	if tlen<=6
	lnum=VAL(SUBSTR(ALLTRIM(STR(tamt)),1,1))
	do four with lnum,tlen
else
	if tlen<=7
	lnum=VAL(SUBSTR(ALLTRIM(STR(tamt)),1,1))
	do four with lnum,tlen
else
	if tlen<=8
	cnum=VAL(SUBSTR(ALLTRIM(STR(tamt)),1,1))
	Do five with cnum,tlen
else
	if tlen<=9
	cnum=VAL(SUBSTR(ALLTRIM(STR(tamt)),1,2))
	do five with cnum,tlen
else
	if tlen<=10
	bnum=VAL(SUBSTR(ALLTRIM(STR(tamt)),1,1))
	do six with bnum,tlen
else
	if tlen>10
	bnum=VAL(SUBSTR(ALLTRIM(STR(tamt)),1,2))
	do six with bnum,tlen
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif

*for hunderth palace value
Procedure second
Parameter hnum,tlen
tdesc=alltrim(tdesc)+" "+alltrim(array(1,hnum))+" Hundred "
tamt=VAL(SUBSTR(ALLTRIM(STR(tamt)),2))
tlen=0
do first with tamt,tlen
return

*for thousandth place value
Procedure third
Parameter tnum,tlen
tdesc=Alltrim(tdesc)+" "+Alltrim(Array(1,tnum))+" Thousand "
If tlen<=4
	tamt=VAL(SUBSTR(ALLTRIM(STR(tamt)),2))
Else
	if tlen<=5
	tamt=VAL(SUBSTR(ALLTRIM(STR(tamt)),3))
Endif
Endif
tlen=0
do first with tamt,tlen
return

*for lakh place value
Procedure four
parameter lnum,tlen
*tdesc=Alltrim(tdesc)+" "+Alltrim(array(1,lnum))+" Lakh "
tdesc=Alltrim(tdesc)+" "+Alltrim(array(1,lnum))+" Hundred"
if tlen<=6
	tamt=VAL(SUBSTR(ALLTRIM(STR(tamt)),2))
else
if tlen<=7
	tamt=VAL(SUBSTR(ALLTRIM(STR(tamt)),3))
endif
endif
tlen=0
Do first with tamt,tlen
return

*for crore place value
procedure five
parameter cnum,tlen
tdesc=Alltrim(tdesc)+" "+Alltrim(array(1,cnum))+" Million"
*tdesc=Alltrim(tdesc)+" "+Alltrim(array(1,cnum))+" Crore"
if tlen<=8
tamt=VAL(SUBSTR(ALLTRIM(STR(tamt)),2))
else
if tlen<=9
	tamt=VAL(SUBSTR(ALLTRIM(STR(tamt)),3))
endif
endif
tlen=0
Do first with tamt,tlen

*for billionth place value
procedure six
parameter bnum,tlen
tdesc=alltrim(tdesc)+" "+Alltrim(array(1,bnum))+" Billion "
If tlen>9 AND tlen<=10
	tamt=VAL(SUBSTR(ALLTRIM(STR(tamt)),2))
else
if tlen>10
	tamt=VAL(SUBSTR(ALLTRIM(STR(tamt)),3))
endif
endif
Do first with tamt,tlen
tamt=0
retu
