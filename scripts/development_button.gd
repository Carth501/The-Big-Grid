class_name development_button extends Button

signal develop(dev_button : development_button)
var data : Variant

func set_data(id : Variant):
	var development_def = DevelopmentsSingle.data[id]
	data = development_def

func set_label(new_text : String):
	text = new_text

func trigger_development():
	develop.emit(self)
