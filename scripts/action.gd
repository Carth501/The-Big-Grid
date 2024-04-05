class_name action extends Button

signal attempt(change : Array)

var change : Array

func set_change(new_change : Array):
	change = new_change

func actuate():
	attempt.emit(change)

func change_label(new_text : String):
	text = new_text
