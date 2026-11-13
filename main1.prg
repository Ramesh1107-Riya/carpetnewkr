*                        Main.PRG
* Environment Settings
* Error Trapping Procedure

ON ERROR DO errhand IN errutil ;
   WITH SYS(0), ERROR(), MESSAGE(), MESSAGE(1), ;
	    PROGRAM(), LINENO(1), DBF(), DATE(), TIME()

SET DATE TO BRITI
SET TALK           OFF
SET BELL           TO 1500,3
SET DATE           BRITISH
SET DELETED        ON
*SET DISPLAY        TO VGA25
SET HOURS          TO 24
SET ODOMETER       TO 100
SET REFRESH        TO  2, 5
SET REPROCESS      TO  5 SECONDS
SET SAFETY         OFF
SET STATUS         OFF
SET SYSMENU 	   OFF 
SET DOHISTORY 	   OFF
SET OPTIMIZE 		ON
SET ANSI 			ON
SET PROCEDURE TO CATOOL

*do careindx && RUN THIS PRG IN EXIT PROGRAM                                                                  
* General Public Variables

PUBLIC acclose,m.closedt,oklogin,pstartdt,srchcall,YesUpdate,pcname,padd1
pcname="Himalayan Carpet Pvt. Ltd."
padd1="Kathmandu, Nepal"
YesUpdate="F"
srchcall=.F.
acclose=""
m.closedt={}
oklogin=.F.
*release all
pstartdt={^2014/01/01}
*DEFINING REPORT WINDOW IN WHICH REPORT IS PLACCED
*Define window repwindow from 0,0 to 60,160 in desktop

* Open Necessary Data Files
do form pass
READ EVENTS
If oklogin=.F.
	Quit
*WAIT WINDOW "Loading ... please wait" NOWAIT
ELSE
	DO CASE
		CASE plevel="LEVEL1"
			Do Carpet.mpr
			ZOOM Window Command Min at -5,-5 
		CASE plevel="LEVEL2"
			Do Carpetlbl1.mpr
			ZOOM Window Command Min at -5,-5 
			*Do VLatLoom
		CASE plevel="LEVEL3"
			Do Carpetlbl2.mpr
			ZOOM Window Command Min at -5,-5 
		CASE plevel="GRAPH"
			Do Graph.mpr
			ZOOM Window Command Min at -5,-5 
		CASE plevel="YARN"
			Do dyedyrn.mpr
			ZOOM Window Command Min at -5,-5 
		CASE plevel="WYARN"
			Do wyarn.mpr
			ZOOM Window Command Min at -5,-5 
	ENDCASE
Endif
Return

*Procedure to Print Very Late On Loom Computer Generated Bi-Monthly Report
*This report temporarily stopped. It works very well

*Procedure VLatLoom
*Private m.Date, m.Date1, m.Date2, m.Date3, m.Date15, m.Date16, m.Date17

*Select blk_dt;
*From CaWevBLp;
*Where blk_dt=date() .or. blk_dt+1=date() .or. blk_dt+2=date();
*Into Cursor Blkdt

*Select Blkdt
*if Recno()>Reccount()
*m.Date=ALLTRIM(STR(DAY(DATE())))
*m.Date1="1"
*m.Date2="2"
*m.Date3="3"
*m.Date15="15"
*m.Date16="16"
*m.Date17="17"
*Do Case
*	Case m.Date1=m.Date
*		Do rprclatloomc && this is the refering program
*	Case m.Date2=m.Date
*		Do rprclatloomc
*	Case m.Date3=m.Date
*		Do rprclatloomc
*	Case m.Date15=m.Date
*		Do rprclatloomc
*	Case m.Date16=m.Date
*		Do rprclatloomc
*	Case m.Date17=m.Date
*		Do rprclatloomc
*Endcase
*Endif
*Use
*Return

