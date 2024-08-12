class_name Controls_Label extends Label

var priority := false

func update_text(new_text : String):
	if(!priority):
		text = new_text

func clear_text():
	if(!priority):
		text = ""

func set_priority_text(new_text : String):
	priority = true
	text = new_text

func clear_priority_text():
	priority = false
	text = ""
