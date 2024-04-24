class_name Action_Button extends Dual_Button

signal attempt(id : String)
signal open_action_menu(id : String)
signal declare_changes(id : String)
signal end_filter
signal declare_focus(id : String)
signal end_focus

var id : String

func set_id(new_id : String):
	id = new_id

func actuate():
	attempt.emit(id)

func open_menu():
	open_action_menu.emit(self)

func change_label(new_text : String):
	text = new_text

func set_filter():
	declare_changes.emit(id)

func unset_filter():
	end_filter.emit()

func gain_focus():
	declare_focus.emit(id)

func lose_focus():
	end_focus.emit()

func connect_logic(action : Action):
	action.update_availability.connect(set_enabled)
	set_enabled(action.available)

func set_enabled(setting : bool):
	disabled = !setting
	if(!setting):
		release_focus()
