**1)*Total Order in Hand
Select sum(sqmt) as sqmt;
From Cabuyord;
Where cstatus<>"Packed" .and. cstatus<>"Exported" .and. (Scode="O" .or. Scode="C") .and. Washtype='TTC'

Select sum(sqmt) as sqmt;
From Cabuyord;
Where cstatus<>"Packed" .and. cstatus<>"Exported" .and.  Scode="C" .and. Washtype='TTC'

Select Distinc bcode;
From Cabuyord;
Where cstatus<>"Packed" .and. cstatus<>"Exported" .and.  Scode="C" .and. Washtype='TTC'
*Where cstatus<>"Packed" .and. cstatus<>"Exported" .and. (Scode="O" .or. Scode="C") .and. Washtype='TTC'

Select *;
From Cabuyord;
Where cstatus<>"Packed" .and. cstatus<>"Exported" .and.  Scode="C" .and. Washtype='TTC' .and. bcode='207'
