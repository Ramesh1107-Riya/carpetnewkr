Select sum(sqmt) as sqmt;
From Cabuyord;
Where cstatus<>"Packed" .and. cstatus<>"Exported" .and. (Scode="O" .or. Scode="J")  .and. (Washtype='JW' .or. Washtype='PCI' .or. Washtype='MTRF');
Into Cursor OrdhandJ

Select OrdhandJ
brow


Select bcode,Ol_No,Design,Colour,Quality,notes,szcode,Sqmt,scode,cstatus;
From Cabuyord;
Where cstatus<>"Packed" .and. cstatus<>"Exported" .and. (Scode="O" .or. Scode="J")  .and. (Washtype='JW' .or. Washtype='PCI' .or. Washtype='MTRF');
Into Cursor OrdhandJ
Select OrdhandJ
brow
