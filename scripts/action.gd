class_name action extends Button

signal attempt(change : Dictionary)
signal declare_changes(change : Dictionary)
signal end_filter
signal declare_focus(change : Dictionary)
signal end_focus

var change : Dictionary

func set_change(new_change : Dictionary):
	change = new_change

func actuate():
	attempt.emit(change)

func change_label(new_text : String):
	text = new_text

func set_filter():
	declare_changes.emit(change)

func unset_filter():
	end_filter.emit()

func gain_focus():
	declare_focus.emit(change)

func lose_focus():
	end_focus.emit()
