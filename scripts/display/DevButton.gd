class_name Dev_Button extends Button

signal attempt(id : String)
signal declare_filter(id : String)
signal end_filter
signal declare_focus(id : String)
signal end_focus
var id : String

func set_id(new_id : String):
	id = new_id

func connect_to_logic(dev : Development):
	disabled = dev.completed
	dev.complete.connect(disable)

func disable():
	disabled = true

func trigger():
	attempt.emit(id)

func set_filter():
	declare_filter.emit(id)

func unset_filter():
	end_filter.emit()

func gain_focus():
	declare_focus.emit(id)

func lose_focus():
	end_focus.emit()
