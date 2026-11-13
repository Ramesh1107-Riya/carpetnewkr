deliry_dt as sup_delidt
wev_last_dt as wevlastdt
yrncaldt-po_dt as custday
wev_last_dt-issdt as weverday
issdt-po_dt as yarnday
fdate-issdt as wevday
issdtwash-fdate as cutday
rcddtwash-issdtwash as washday
iif(!empty(rcddtwash),date()-rcddtwash,00.00) as pkday
iif(empty(fdate) .and. !empty(issdt), date()-issdt,0.00) as Loom


(iif(yarnday>0 .and. Loom<0,yarnday,0)+
iif(wevday>0,wevday,0)+iif(cutday>0,cutday,0)+
iif(washday>0,washday,0)+
iif(pkday>0 .and. Loom<0,pkday,0))-custday as CustLate;


