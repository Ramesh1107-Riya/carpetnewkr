Select s.ol_no,s.carpetno,k.carpetno as kcarpetno,k.spcl_inst as kspcl_inst;
From kdat k,casupord s;
Where k.carpetno=s.carpetno;
Into table supdat

Select i.ol_no,i.spcl_inst,s.carpetno,s.kspcl_inst;
From Cabuyord i,supdat s;
Where i.ol_no=s.ol_no;
Into Table buydat

use buydat
Scan
	Update Cabuyord;
	set cabuyord.spcl_inst=buydat.kspcl_inst;
	Where Cabuyord.ol_no=buydat.ol_no
endscan

*chek operation
Select i.ol_no,i.spcl_inst,s.carpetno,s.kspcl_inst;
From Cabuyord i,supdat s;
Where i.ol_no=s.ol_no

********************************

Select s.ol_no,s.carpetno,s.spcl_inst,k.spcl_inst as kspcl_inst;
From kdat k,stkcarpet s;
Where k.carpetno=s.carpetno;
Into table stkdat

use stkdat
Scan
	Updat Stkcarpet;
	set Stkcarpet.spcl_inst=stkdat.kspcl_inst;
	Where Stkcarpet.ol_no=stkdat.ol_no
endscan

Select s.ol_no,s.carpetno,s.spcl_inst,k.spcl_inst as kspcl_inst;
From kdat k,stkcarpet s;
Where k.carpetno=s.carpetno