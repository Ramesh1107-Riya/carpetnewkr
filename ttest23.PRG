close all
Select po_no,po_dt,ol_no,Design,Ctrl_no,Quality,Notes,Szcode, Count(Ctrl_No) as Count1,cstatus;
From Cabuyord;
Group by Ctrl_No;
Where !empty(ctrl_No);
Into Cursor Temp1

Select po_no,po_dt,ol_no,Design,Ctrl_no,Quality,Notes,Szcode,Count1,cstatus;
From Temp1;
Where Count1>=2;
Into Cursor Temp1

Select Temp1
Brow

Select po_no,po_dt,b.ol_no,Design,Ctrl_no,Quality,Notes,Szcode,s.*;
From Cabuyord b, Casupord s;
Where b.ol_no=s.ol_no .and. po_no='9469'


Delete From Cabuyord Where ol_no='A000074' .OR. OL_NO='A000474'
Delete From CaSupord Where ol_no='A000074' .OR. OL_NO='A000474'
Close all
use Cabuyord
Pack
Use Casupord
Pack
Close all