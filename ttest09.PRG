* Not Empty Delivery Dt
select Po_No,PO_dt,ol_no,design,quality,colour,yrncaldt,sqmt,qty,cstatus,notes,spcl_inst;
from cabuyord where cstatus<>'Exported' .and. yrncaldt<={^2019/07/18} .and. !empty(yrncaldt);
order by Quality,PO_Dt

select Po_No,PO_dt,quality,yrncaldt,sum(sqmt) sqmt,sum(qty) qty,spcl_inst;
from cabuyord where cstatus<>'Exported' .and. yrncaldt<={^2019/07/18} .and. !empty(yrncaldt);
Group by PO_No,Quality;
order by Quality,PO_Dt

*Empty Delivery Dt
select Po_No,PO_dt,ol_no,design,quality,colour,yrncaldt,sqmt,qty,cstatus,notes,spcl_inst;
from cabuyord where cstatus<>'Exported' .and. yrncaldt<={^2019/07/18} .and. empty(yrncaldt);
order by Quality,PO_Dt

select Po_No,PO_dt,quality,yrncaldt,sum(sqmt) sqmt,sum(qty) qty,spcl_inst;
from cabuyord where cstatus<>'Exported' .and. yrncaldt<={^2019/07/18} .and. !empty(yrncaldt);
Group by PO_No,Quality;
order by Quality,PO_Dt