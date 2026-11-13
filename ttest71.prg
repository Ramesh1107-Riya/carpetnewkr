**UPDATING SUPPLIER NAME IN ALL *.DBF
****Casupord****
Close all
USE Casupord IN 0
USE ttsupl IN 0
Select ttsupl && values come FROM this table 
Scan
Update Casupord;
Set supplier=ttsupl->acode;
Where Casupord->weaver=ttsupl->code
endscan
Select Casupord
brow

****Witrnord****
Close all
USE Witrnord IN 0
USE ttsupl IN 0
Select ttsupl && values come FROM this table 
Scan
Update Witrnord;
Set party=ttsupl->acode;
Where Witrnord->scompany=ttsupl->code
endscan
Select Witrnord
brow

****Wirecv****
Close all
USE Wirecv IN 0
USE ttsupl IN 0
Select ttsupl && values come FROM this table 
Scan
Update Wirecv;
Set party=ttsupl->acode;
Where Wirecv->scompany=ttsupl->code
endscan
Select Wirecv
brow

****Wiissue****
Close all
USE Wiissue IN 0
USE ttsupl IN 0
Select ttsupl && values come FROM this table 
Scan
Update Wiissue;
Set party=ttsupl->acode;
Where Wiissue->scompany=ttsupl->code
endscan
Select Wiissue
brow

****Wireturn****
Close all
USE Wireturn IN 0
USE ttsupl IN 0
Select ttsupl && values come FROM this table 
Scan
Update Wireturn;
Set party=ttsupl->acode;
Where Wireturn->scompany=ttsupl->code
endscan
Select Wireturn
brow

****Yrnissdy****
Close all
USE Yrnissdy IN 0
USE ttsupl IN 0
Select ttsupl && values come FROM this table 
Scan
Update Yrnissdy;
Set Suplier=ttsupl->acode;
Where Yrnissdy->scompany=ttsupl->code
endscan
Select Yrnissdy
brow

****Graphord****
Close all
USE Graphord IN 0
USE ttsupl IN 0
Select ttsupl && values come FROM this table 
Scan
Update Graphord;
Set Name=ttsupl->acode;
Where Graphord->scompany=ttsupl->code
endscan
Select Graphord
brow

****Grsuptran****
Close all
USE Grsuptran IN 0
USE ttsupl IN 0
Select ttsupl && values come FROM this table 
Scan
Update Grsuptran;
Set Supplier=ttsupl->acode;
Where Grsuptran->scompany=ttsupl->code
endscan
Select Grsuptran
brow








