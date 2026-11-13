Private m.option
store space(20) m.option

Do case 
	case ThisForm.Optiongroup1.Option1.Value=1
		m.option='AmeriDate'		
		do epcrep
	case ThisForm.Optiongroup1.Option2.value=1
		m.option='BritiDate'		
		do epcrep
	Otherwise
		Messagebox("Invalid Choice, Make Correct Choice")
Endcase