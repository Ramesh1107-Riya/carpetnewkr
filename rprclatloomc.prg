*LATE ONLOOM, computer must generate bi-monthly && Pending use for refrence only. Remove this report after some time.
&& Print Very Late On Loom Report - Computer Generated Bi-Monthly
Set Safe Off
Set Reprocess to 3 Automatic
Private m.latloomhead,m.compgen,condition, m.Text1,m.Text2
m.Text2=Date()

cMessageTitle = 'Very Late On Loom Report - Computer Generated, Bi-Monthly [PRINT] '+DTOC(Date())
cMessageText = 'Would you like to Print this Report Today? You Must Print Twice Every Month in Date <1 or 2>;
 and Date <15 or 16>, Make Your Printer Ready, Today is '+DTOC(Date())
nDialogType = 4 + 32 + 256
*  4 = Yes and No buttons
*  32 = Question mark icon
*  256 = Second button is default

nAnswer = MESSAGEBOX(cMessageText, nDialogType, cMessageTitle)
DO CASE
   CASE nAnswer = 6
   	 		DO Latloomp
   CASE nAnswer = 7
      WAIT WINDOW 'Very Late On Loom Report [Not printed] - Computer Generated Bi-Monthly'
ENDCASE

Procedure Latloomp
	Open Database Carpet
	m.latloomhead="Very Late On Loom Report - 7 Days Crossed Wev_Last_Dt (Bi-Monthly)"
	m.compgen="Computer Generated Report"

	CREATE SQL VIEW temprepview AS SELECT s.CARD_NO, b.PO_NO, b.OL_NO, b.DESIGN, b.COLOUR, b.SZCODE, b.SQMT,s.ISSDT, s.WEAVER, s.WEV_LAST_DT,;
		 	 b.ORDER_TYPE, b.BCODE, b.SPCL_INST, b.FRINGES, b.WASHTYPE,s.GRADE,s.LOOMDT,b.QUALITY, b.CTRL_NO,s.CATEGORY,m.Text2-s.WEV_LAST_DT NODAY,s.WEV_DT;	
	FROM  Carpet!Cabuyord b, Carpet!Casupord s;
	WHERE b.ol_no=s.ol_no .and. !empty(s.ISSDT) .and. empty(s.fdate);  
	HAVING s.WEV_LAST_DT>= DATE() .and. s.Wev_Dt+7=<Date() && Today's Date, We have Increased 7 days to Wev_Last_Dt 
	
USE temprepview shared 
SET COLOR TO
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
*Case m.PrnStat="D" && Print UPdated Report
Report form prclatloomu.frx to printer prompt noconsole
*Copy to Array Blklist
*Insert into CaWevBList From Array Blklist
*close all
*Use CaWevBList Exclus
  *If Rlock()
*	Replace  all blk_dt with Date() for empty(blk_dt)
*	use 
*	Unlock all
*  Endif
Endif
Return

