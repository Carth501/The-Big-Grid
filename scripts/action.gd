class_name action extends Button

signal attempt(change : Array)
signal declare_changes(change : Array)
signal end_filter

var change : Array

func set_change(new_change : Array):
	change = new_change

func actuate():
	attempt.emit(change)

func change_label(new_text : String):
	text = new_text

func set_filter():
	declare_changes.emit(change)

func unset_filter():
	end_filter.emit()
