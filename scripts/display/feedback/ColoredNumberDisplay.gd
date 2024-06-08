class_name Colored_Number_Display extends Label

func set_number(num : float):
	text = "%+.1f" % num
	if(num > 0):
		set_theme_type_variation("GreenNumber")
	elif(num < 0):
		set_theme_type_variation("RedNumber")
