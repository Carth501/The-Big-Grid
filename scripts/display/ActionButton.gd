class_name Action_Button extends Dual_Button

signal attempt(id : String)

var id : String
var action : Action

func set_id(new_id : String):
	id = new_id

func connect_logic(new_action : Action):
	new_action.update_availability.connect(set_enabled)
	set_enabled(new_action.available)
	action = new_action

func actuate():
	attempt.emit(id)

func open_menu():
	action.open()

func change_label(new_text : String):
	text = new_text

func set_enabled(setting : bool):
	disabled = !setting

func set_filter():
	action.set_filter()

func unset_filter():
	action.unset_filter()

func gain_focus():
	action.gain_focus()

func lose_focus():
	action.lose_focus()
