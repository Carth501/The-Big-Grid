class_name Action extends Dual_Button

signal attempt(change : Dictionary)
signal open_action_menu(action : Action)
signal declare_changes(change : Dictionary)
signal end_filter
signal declare_focus(change : Dictionary)
signal end_focus

var change : Dictionary
var id : String

func set_change(new_change : Dictionary):
	change = new_change

func set_id(new_id : String):
	id = new_id

func actuate():
	attempt.emit(change)

func open_menu():
	open_action_menu.emit(self)

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
