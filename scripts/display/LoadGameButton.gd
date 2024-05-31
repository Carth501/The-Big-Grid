class_name Load_Game_Button extends Button

signal select_save(String)

var file_name : String

func _ready():
	pressed.connect(select)

func set_file_name(new_name : String):
	text = new_name
	file_name = new_name

func select():
	select_save.emit(file_name)
