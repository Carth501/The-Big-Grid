class_name Dev_Button extends Button

signal attempt(id : String)
var id : String

func set_id(new_id : String):
	id = new_id

func _ready():
	pressed.connect(trigger)

func trigger():
	attempt.emit(id)
