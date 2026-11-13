**Updating Rcode from DgnCode into Cadesign
*C)*Updating 2 Files 
Close all
USE Cabuy2b IN 0
USE Cabuyord IN 0
Select Cabuy2b && values come FROM this table 
Scan
Update Cabuyord;
Set washtype=Cabuy2b.Washtype,scode=cabuy2b.scode,spcl_inst=cabuy2b.spcl_inst;
Where cabuyord.ol_no=cabuy2b.ol_no
Endscan
************************************************
Selec ol_no,washtype,scode,spcl_inst;
from cabuyord

