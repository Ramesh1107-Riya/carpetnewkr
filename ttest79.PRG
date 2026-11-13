**Stock Carpet & Ordered Carpet All Together
SET DELETED ON
Set Date to Briti
Set Century off
SET SAFE OFF
SET TALK OFF
SET ANSI ON

Local m.PrnStat
m.PrnStat="P"

SELECT OL_NO,SQMT,SPCL_INST,CSTATUS, WASHTYPE,SCODE;
FROM  Stkcarpet;
WHERE cstatus<>"Exported";
UNION ALL;
SELECT b.OL_NO,b.SQMT,b.SPCL_INST,b.CSTATUS,b.WASHTYPE,SCODE;
FROM  Cabuyord b;
Inner Join Casupord s;
On b.ol_no=s.ol_no;
WHERE b.cstatus<>"Exported" .and. !empty(fdate);
Into cursor temp7

Select Washtype,Sum(sqmt) Sqmt,scode;
From temp7;
Group by Washtype,scode;
Into Cursor temp8

Select t.Washtype,c.item,t.scode,t.Sqmt;
From temp8 t;
Join caordhnd c;
on t.scode=c.scode;
Into Cursor temp9

Do Case
	Case Empty(m.Washtype)
		Select Washtype,item,scode,Sqmt;
		From temp9;
		Into Cursor temp10
	
	Case m.Washtype='TTC'
		Select Washtype,item,scode,Sqmt;
		From temp9;
		Where Washtype='TTC';
		Into Cursor temp10
		
	Case m.Washtype='PCI' .OR. m.Washtype='JW' .OR. m.Washtype='MTRF'
		Select Washtype,item,scode,Sqmt;
		From temp9;
		Where Washtype<>'TTC';
		Into Cursor temp10
	Otherwise
		Messagebox("Invalid Choice, Enter Company Name 'Blank', TTC, PCI, JW & MTRF")
Endcase

Select temp10
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
	Do Case
	Case m.PrnStat="V" 
		Report form caordhnd.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P" 
		Report form caordhnd.frx to printer prompt noconsole
	Endcase
Endif
Return
