Local m.loop
select 1
use yrcalc
Scan while (.not. eof())
	For count1=1 to 26 Step 1
		count7="LOOP"+right("00"+Alltrim(Str(count1)),2) 
		m.loop=&count7
	if(empty(yrcalc->&count2))
			loop
		else
			If m.loop='C'
			repl 
		endif
	Endfor
	Select 1
Endscan