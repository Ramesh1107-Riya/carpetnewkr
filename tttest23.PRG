
BROW FOR CSTATUS='Exported'
select p.carpetno,p.bcode,p.ol_no,p.buyerno,p.po_no,p.design,p.invno from stkcarpet a,packtran p where a.ol_no=p.ol_no .and. a.cstatus='Exported'
