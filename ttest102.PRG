Select sum(sqmt) as sqmt;
From Cabuyord;
Where cstatus<>"Packed" .and. cstatus<>"Exported" .and. Scode="O"  .and. Washtype='TTC';
Into Cursor Ordhand

Select Ordhand
brow

Select bcode,Ol_No,Design,Colour,Quality,notes,szcode,Sqmt,scode,cstatus;
From Cabuyord;
Where cstatus<>"Packed" .and. cstatus<>"Exported" .and. Scode="O"  .and. Washtype='TTC';
Order by bcode,scode,sqmt,design;
Into Cursor Ordhand

Select bcode,Ol_No,Design,Colour,Quality,notes,szcode,Sqmt,scode,cstatus;
From Cabuyord;
Where cstatus<>"Packed" .and. cstatus<>"Exported" .and. (Scode="O" .or. Scode="C") .and. Washtype='TTC';
Order by bcode,scode,sqmt,design;
Into Cursor Ordhand


Select bcode,Ol_No,Design,Colour,Quality,notes,szcode,Sqmt,scode,cstatus;
From Cabuyord;
Where cstatus<>"Packed" .and. cstatus<>"Exported" .and. (Scode="O" .or. Scode="C")  .and. (Washtype='JW' .or. Washtype='PCI' .or. Washtype='MTRF');
Into Cursor OrdhandJ

Select OrdhandJ
