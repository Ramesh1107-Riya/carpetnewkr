Select b.ol_no,b.cstatus,b.exported,p.lastatus,p.invno;
From Cabuyord b,Packtran p;
Where b.ol_no=p.ol_no .and. b.cstatus<>p.lastatus .and. b.cstatus<>'Exported'