*rordforyrncolo.prg Finds given Colour used in Design Charts, all inner colour also.
Public AllowDel
AllowDel=.F.
Set Date to Briti
Set Century on
SET ANSI ON

Select * ;
From yrcalc; 
Into cursor yrcalc1

Create cursor colour2(DESIGN C(20),BASECOLOUR C(10), COLOUR C(10))
Private count1,count2,count3,tvar,var1,var2,var3,var4
tvar=.T.

Select yrcalc1
Scan while (.not. eof())
	For count1=1 to 26 Step 1
		count4="DESIGN"
		count2="COLOUR"+right("00"+Alltrim(Str(count1)),2)
		count3="BASECOLOUR"
		var1=&count4
		var2=&count2
		var3=&count3		
		if(empty(yrcalc1->&count2))
			loop
		else
			Insert into colour2(Design,colour,basecolour) Values(var1,var2,var3)
		endif
	Endfor
	Select yrcalc1
Endscan
Select i.Design, i.Basecolour;
From colour2 i, cacolour j;
WHERE i.colour=j.code .and. j.code=m.colour;
Group by i.Design,i.Basecolour;
ORDER BY i.Design,i.Basecolour;
INTO cursor temp1

Do case 
	Case m.yesdel=.F.
		sele temp1
		SET COLOR TO
		If RECNO()>RECCOUNT()
			Messagebox("The Design Not Found in the Colour Chart for this colour!!!")
		Else
			Browse nomodify Title "The Colour No. "+alltrim(m.colour)+" is used in the following Deigns of the Colour Chart"
		endif
	Case m.yesdel=.T.
		sele temp1
		SET COLOR TO
		If RECNO()>RECCOUNT()
			Wait Window "Colour Not used in Chart, Looking Stock and Buyer Order to Complete Deletion?" Timeout 2
			AllowDel=.T.
		Else
			Wait Window "Can Not Delete Colour used in Chart!!!" Timeout 2
			AllowDel=.F.
		Endif
Endcase