Set Date to Briti
Set Century off
SELECT b.BCODE,s.CARPETNO, b.DESIGN,b.QUALITY,b.SZCODE,s.issdt,s.Fdate,s.RCDDTWASH as WshRdt,s.ISSDTWASH as WshIdt,s.CUTISSDT as CutIdt,s.CUTRCDDT as CutRdt ;
FROM Cabuyord b, Casupord s;
WHERE b.ol_no=s.ol_no .and. !empty(s.FDate);
Into Cursor Fini1

*SELECT b.BCODE,s.CARPETNO, b.DESIGN,b.COLOUR,b.QUALITY,b.SZCODE,s.BTHWEAV AS BWEAV,s.LTHWEAV AS LWEAV,s.FDate,s.BTHWASH AS BWASH,s.LTHWASH AS LWASH,s.RCDDTWASH as WshRdt,s.ISSDTWASH as WshIdt,s.CUTISSDT as CutIdt,s.CUTRCDDT as CutRdt ;
*SELECT f.BCODE,f.CARPETNO,f.DESIGN,f.COLOUR,f.QUALITY,f.SZCODE,f.BWEAV,f.LWEAV,f.FDate,f.BWash,f.LWash,f.WshRdt,f.WshIdt,f.CutIdt,f.CutRdt,;  && Casupord
* .and. s.FDate>=m.Text1 .and. s.FDate<=m.Text2

SELECT f.BCODE,f.CARPETNO,f.DESIGN,f.QUALITY,f.SZCODE,f.Issdt,f.FDate,f.WshRdt,f.WshIdt,f.CutIdt,f.CutRdt,;  && Casupord
		iif(ISNULL(s.startdt),{},s.startdt) as sosdt,iif(ISNULL(s.finidt),{},s.finidt) as sofdt,; && sorting
		iif(ISNULL(st.strissdt),{},st.strissdt) as stsdt,iif(ISNULL(st.strcdt),{},st.strcdt) as stfdt,; && castretch
		iif(ISNULL(r.startdt),{},r.startdt) as rsdt,iif(ISNULL(r.finidt),{},r.finidt) as rfdt,; && repair
		iif(ISNULL(b.startdt),{},b.startdt) as bsdt,iif(ISNULL(b.finidt),{},b.finidt) as bfdt,; && backsewing
		iif(ISNULL(p.startdt),{},p.startdt) as psdt,iif(ISNULL(p.finidt),{},p.finidt) as pfdt,; && painting
		iif(ISNULL(bi.startdt),{},bi.startdt) as bisdt,iif(ISNULL(bi.finidt),{},bi.finidt) as bifdt,; && binding
		iif(ISNULL(fi.finidt),{},fi.finidt) as fifdt; && finish
FROM Fini1 f;
Left Join Sorting s;
On f.carpetno=s.carpetno;
Left Join castretch st;
On f.carpetno=st.carpetno;
Left Join repair r;
On f.carpetno=r.carpetno;
Left Join backsewing b;
On f.carpetno=b.carpetno;
Left Join Painting p;
On f.carpetno=p.carpetno;
Left Join Bindtcm bi;
On f.carpetno=bi.carpetno;
Left Join Finitcm fi;
On f.carpetno=fi.carpetno;
Into Cursor Fini2

Select BCODE,CARPETNO,DESIGN,QUALITY,SZCODE,Issdt,FDate,FDate-Issdt as Wvd,WshRdt,WshIdt,WshRdt-WshIdt as Whd,CutIdt,CutRdt,CutRdt-CutIdt as Ctd,;
	sosdt,sofdt,sofdt-sosdt as sod,stfdt,stsdt,stfdt-stsdt as std,rsdt,rfdt,rfdt-rsdt as rpd,bsdt,bfdt,bfdt-bsdt as bsd,psdt,pfdt,pfdt-psdt as ptd,;
	bisdt,bifdt,bifdt-bisdt as bid,fifdt,fifdt-issdt as tod; 
From Fini2;
Into Table Fini3


