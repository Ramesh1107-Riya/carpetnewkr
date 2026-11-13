close all
use casupord
repl all paidstatus with .T. for fdate<={^2021/08/30} .and. !empty(fdate)
repl all paiddate with {^2021/08/30} for fdate<={^2021/08/30} .and. !empty(fdate)
brow fields fdate,paiddate,paidstatus
close all
