class_name development_button extends Button

signal develop(dev_button : development_button)
var data : Variant

func set_data(new_data : Variant):
	data = new_data

func set_label(new_text : String):
	text = new_text

func trigger_development():
	develop.emit(self)
