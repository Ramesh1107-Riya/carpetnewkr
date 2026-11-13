select distinct spcl_inst;
from cabuyord;
where !empty(scode) .and. cstatus<>'Exported';
order by bcode,spcl_inst into cursor temp1

select temp1
brow

