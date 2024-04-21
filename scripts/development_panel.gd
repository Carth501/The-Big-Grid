class_name development_panel extends Panel

signal attempt_development

var previous_developments := []
@export var _action_panel : Control
@export var development_list : HFlowContainer
@onready var development_package := preload("res://scenes/DevelopmentButton.tscn")

func _ready():
	for development in DevelopmentsSingle.data:
		if(!previous_developments.has(development)):
			create_development_button(development)

func attempt_dev(id : String):
	attempt_development.emit(id)

func create_development_button(id : String):
	if(previous_developments.has(id)):
		return
	var new_button : development_button = development_package.instantiate()
	new_button.set_data(id)
	development_list.add_child(new_button)
	new_button.develop.connect(attempt_dev)
	if(!DevelopmentTranslatorSingle.data.has(id)):
		push_error(str("id ", id, " translation not found"))
		return
	new_button.set_label(DevelopmentTranslatorSingle.data[id].label)
	previous_developments.append(id)

func toggle_dev_panel():
	visible = !visible
