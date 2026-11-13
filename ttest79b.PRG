select bcode,ol_no,po_no,design,quality,sqmt,washtype,spcl_inst,scode,cstatus;
from cabuyord;
where cstatus<>'Exported' .and. (washtype='JW' .or. washtype='PCI')