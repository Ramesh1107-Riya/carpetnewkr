public tdesc,paise
private npay
npay=mgtotal
store space(80) to tdesc
store 0 to paise
do amtword with npay,tdesc,paise
*?"Rupees",tdesc,paise
