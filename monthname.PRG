*Display month in the format of 0,1,2,3...12
clea
set date to briti
Local n,mdate
n=1
mdate={^2009/01/01}  && mdate={} month=0
do while n<=12
?month(mdate)
mdate=mdate+31
n=n+1
enddo
