class_name Development_Display extends HFlowContainer

@export var development_handler : Development_Handler
var dev_buttons : Dictionary

func _ready():
	if(!development_handler.is_node_ready()):
		await development_handler.ready
	var dev_options_list = development_handler.get_development_options()
	for option in dev_options_list:
		var new_dev_button = Dev_Button.new()
		add_child(new_dev_button)
		new_dev_button.set_id(option)
		new_dev_button.text = DevelopmentTranslatorSingle.data[option].label
		dev_buttons[option] = new_dev_button
		new_dev_button.attempt.connect(attempt_development)

func attempt_development(id : String):
	development_handler.attempt_development(id)

func disable_dev(id : String):
	dev_buttons[id].disabled = true
