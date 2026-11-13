**1)**Graph Made Today
Public m.DGMade,m.DGMadeJ
*m.date={^2023/08/08}

Select sum(sqmt) as msqmt;
From Graphord;
Where Rcddate=m.date .and. Washtype='TTC';
Group by Rcddate;
Into Cursor gord

Select gord
m.DGMade=gord->msqmt

Select sum(sqmt) as msqmtj;
From Graphord;
Where Rcddate=m.date .and. Washtype='PCI';
Group by Rcddate;
Into Cursor gordJ

Select gordj
m.DGMadeJ=gordJ->msqmtj

**2)**Pending Graph 
Public m.PGraph,m.PGraphJ

Select sum(sqmt) as psqmt;
From Graphord;
Where empty(Rcddate) .and. !empty(Issdt) .and.  Washtype='TTC';
Group by Rcddate;
Into Cursor pgord

Select pgord
m.PGraph=pgord->psqmt

Select sum(sqmt) as Psqmtj;
From Graphord;
Where empty(Rcddate) .and. !empty(Issdt) .and.  Washtype='PCI';
Group by Rcddate;
Into Cursor PgordJ

Select Pgordj
m.PGraphJ=pgordJ->Psqmtj
