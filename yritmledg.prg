Select i.Date, i.Bill as Billno, i.Suplier, i.Quality, i.Colour, i.Netwt, PADR('Opn',3) as RCODE;
FROM  yrnop i;
WHERE i.Quality=m.Quality .and. i.date=<medate;
union all;
Select j.Recdt as Date, j.Recno as Billno, j.Suplier, j.Quality, j.Colour, j.Netwt, PADR('Rec',3) as RCODE;
FROM  yrnrecvd j;
WHERE j.Quality=m.Quality .and. j.recdt=<medate;
union all;
Select k.Date, k.Delino as Billno, k.Supplier as Suplier, k.Quality, k.Colour, k.Qty as Netwt, PADR('Iwh',3) as RCODE;
FROM yrnwshiss k;
WHERE k.Quality=m.Quality .and. k.date=<medate;
union all;
Select l.Date, l.Billno, l.Supplier, l.Quality, l.Colour, l.Qty as Netwt, PADR('Rwh',3) as RCODE;
FROM yrnwshrcd l;
WHERE l.Quality=m.Quality .and. l.date=<medate;
union all;
Select m.Date, m.Billno, m.Suplier, m.Quality, m.Colour,m.Quantity as Netwt, PADR('Idy',3) as RCODE;
FROM  yrnissdy m; 
WHERE m.Quality=m.Quality .and. m.date=<medate;
union all;
Select n.Date, n.Billno, n.Party as Suplier, n.Quality, n.Colour,n.Quantity as Netwt, PADR('Isu',3) as RCODE;
FROM  wiissue n; 
WHERE n.Quality=m.Quality .and. n.date=<medate .and. n.dyewht='W';
union all;
Select o.Date, o.Billno, o.Party as Suplier, o.Quality, o.Colour,o.Quantity as Netwt, PADR('Rsu',3) as RCODE;
FROM  wireturn o; 
WHERE o.Quality=m.Quality .and. o.date=<medate .and. o.dyewht='W';
Into cursor yrnitmledg

Do Case
	Case !empty(m.Quality) .and. empty(m.Colour) .and. empty(m.suplier)
		Select *;
		from yrnitmledg;
		WHERE quality=ALLTRIM(m.quality);
		Order by date;
		INTO cursor yitm
	Case !empty(m.Quality) .and. !empty(m.Colour) .and. empty(m.suplier)
		Select *;
		from yrnitmledg;
		WHERE quality=ALLTRIM(m.quality) .and. colour=m.colour;
		Order by date;
		INTO cursor yitm
	Case !empty(m.Quality) .and. empty(m.Colour) .and. !empty(m.suplier)
		Select *;
		from yrnitmledg;
		WHERE quality=ALLTRIM(m.quality) .and. suplier=m.suplier;
		Order by date;
		INTO cursor yitm
		
	Case !empty(m.Quality) .and. !empty(m.Colour) .and. !empty(m.suplier)
		Select *;
		from yrnitmledg;
		WHERE quality=ALLTRIM(m.quality) .and. colour=m.colour .and. suplier=m.suplier;
		Order by date;
		INTO cursor yitm
Endcase
******************************************************************************************************************************************************
CREATE CURSOR YRNITEM (DATE D(8), SUPLIER C(20), QUALITY C(10), COLOUR C(10),BILLNO C(8), OPWT N(11,3), PUWT N(11,3), ISWHWT N(11,3), RVWHWT N(11,3),;
						 DYISWT N(11,3), SUISWT N(11,3), SUREWT N(11,3),Rcode C(3))
******************************************************************************************************************************************************
Select yitm
do while .not. eof()
SELECT YRNITEM    
appen blank
repl Date with yitm->Date,Billno with yitm->Billno,Suplier with yitm->Suplier,Quality with yitm->Quality,Colour with yitm->Colour,Rcode with yitm->rcode
do case 
	case Rcode='Opn'
		repl OpWt with yitm->Netwt
    case Rcode='Rec'
    	repl PuWt with yitm->Netwt
    case Rcode='Iwh'
		repl IsWhWt with yitm->Netwt
    case Rcode='Rwh'
    	repl RvWhWt with yitm->Netwt
    case Rcode='Idy'
		repl DyIsWt with yitm->Netwt
    case Rcode='Isu'
    	repl SuIsWt with yitm->Netwt
    case Rcode='Rsu'
    	repl SuReWt with yitm->Netwt
endcase
	sele yitm
	skip
enddo

***********Min Max Actual Date, Data Range in Report
Private sdate,edate
sdate=Date()
edate=medate
Select Min(date) from  YRNITEM into cursor mindate
select mindate
sdate=mindate->min_date
Select max(date) from  YRNITEM into cursor maxdate
select maxdate
edate=maxdate->Max_date
***************************************************
SELECT YRNITEM 
If RECNO()>RECCOUNT()
	Messagebox("Record Not Found for the above seletion!!!")
Else
SET COLOR TO
Do Case
	Case m.PrnStat="V"
		*Report form yritmledg.frx to console preview in screen
		Report form yritmledg.frx PREVIEW WINDOW wReport 
		DEACTIVATE WINDOW wReport
	Case m.PrnStat="P"
		Report form yritmledg.frx to printer prompt noconsole
Endcase
Endif
RETURN  

