class_name Development_Display extends HFlowContainer

@export var development_handler : Development_Handler
@export var filter_foreman : Filter_Foreman
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
		new_dev_button.declare_filter.connect(set_filter)
		new_dev_button.end_filter.connect(unset_filter)
		new_dev_button.declare_focus.connect(set_focus)
		new_dev_button.end_focus.connect(unset_focus)

func attempt_development(id : String):
	development_handler.attempt_development(id)

func set_filter(id : String):
	filter_foreman.set_dev_primary_filter(id)

func unset_filter():
	filter_foreman.clear_primary_filter()

func set_focus(id : String):
	filter_foreman.set_dev_secondary_filter(id)

func unset_focus():
	filter_foreman.clear_secondary_filter()
