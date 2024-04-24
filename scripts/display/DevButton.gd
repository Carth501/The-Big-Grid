class_name Dev_Button extends Button

signal attempt(id : String)
signal declare_filter(id : String)
signal end_filter
signal declare_focus(id : String)
signal end_focus
var id : String
var complete := false

func set_id(new_id : String):
	id = new_id

func connect_to_logic(dev : Development):
	dev.complete.connect(finish)
	disabled = dev.completed
	dev.update_availability.connect(set_enabled)
	set_enabled(dev.available)

func finish():
	disabled = true
	release_focus()
	complete = true
	unset_filter()

func set_enabled(setting):
	disabled = !setting

func trigger():
	if(!complete):
		attempt.emit(id)

func set_filter():
	if(!complete):
		declare_filter.emit(id)

func unset_filter():
	end_filter.emit()

func gain_focus():
	if(!complete):
		declare_focus.emit(id)

func lose_focus():
	end_focus.emit()
