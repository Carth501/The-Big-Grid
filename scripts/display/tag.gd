class_name Tag extends Button

signal clicked(String)

func _ready():
	pressed.connect(click)

func set_tag(tag_text : String):
	text = tag_text

func click():
	clicked.emit(text)
