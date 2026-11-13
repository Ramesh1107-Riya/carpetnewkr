*1)Graph Made Today
Public m.grmSqmt,m.grmSqmtJ
m.date={^2023/08/08}

Select sum(sqmt) as msqmt;
From Graphord;
Where Rcddate=m.date .and. Washtype='TTC';
Group by Rcddate;
Into Cursor gord

Select gord
m.grmSqmt=gord->msqmt

Select sum(sqmt) as msqmtj;
From Graphord;
Where Rcddate=m.date .and. Washtype='PCI';
Group by Rcddate;
Into Cursor gordJ

Select gordj
m.grmSqmtJ=gordJ->msqmtj

*1)Pending Graph 
Public m.grmSqmt,m.grmSqmtJ

Select sum(sqmt) as psqmt;
From Graphord;
Where empty(Rcddate) .and. !empty(Issdt) .and.  Washtype='TTC';
Group by Rcddate;
Into Cursor pgord

Select pgord
m.grpSqmt=pgord->psqmt

Select sum(sqmt) as psqmtj;
From Graphord;
Where empty(Rcddate) .and. !empty(Issdt) .and.  Washtype='PCI';
Group by Rcddate;
Into Cursor PgordJ

Select pgordj
m.grPSqmtJ=pgordJ->Psqmtj
