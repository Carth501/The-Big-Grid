class_name Dev_Button extends Button

signal attempt(id : String)
var id : String
var development : Development
var complete := false

func set_id(new_id : String):
	id = new_id

func connect_to_logic(dev : Development):
	dev.complete.connect(finish)
	disabled = dev.completed
	dev.update_availability.connect(set_enabled)
	set_enabled(dev.available)
	development = dev

func finish():
	disabled = true
	release_focus()
	complete = true
	unset_filter()
	visible = false

func set_enabled(setting):
	if(!complete):
		disabled = !setting

func trigger():
	if(!complete):
		attempt.emit(id)

func set_filter():
	if(!complete):
		development.set_filter()

func unset_filter():
	development.unset_filter()

func gain_focus():
	if(!complete):
		development.gain_focus()

func lose_focus():
	development.lose_focus()
