class_name Development_Display extends HFlowContainer

@export var development_handler : Development_Handler
var dev_buttons : Dictionary
@onready var dev_button_prefab = preload("res://scenes/display/DevelopmentButton.tscn")

func _ready():
	if(!development_handler.is_node_ready()):
		await development_handler.ready
	var dev_options_list = development_handler.full_development_catalog
	for option in dev_options_list:
		var new_dev_button : Dev_Button = dev_button_prefab.instantiate()
		add_child(new_dev_button)
		new_dev_button.set_id(option)
		new_dev_button.text = DevelopmentTranslatorSingle.data[option].label
		dev_buttons[option] = new_dev_button
		var dev_logic = development_handler.full_development_catalog[option]
		new_dev_button.connect_to_logic(dev_logic)
		new_dev_button.attempt.connect(attempt_development)

func attempt_development(id : String):
	development_handler.attempt_development(id)

