class_name development_panel extends Panel

var previous_developments := []
@export var resources : resource_pile
@export var _action_panel : action_panel
@export var development_list : HFlowContainer
@onready var development_package := preload("res://scenes/DevelopmentButton.tscn")

func _ready():
	for development in DevelopmentsSingle.data:
		if(!previous_developments.has(development)):
			create_development_button(development)

func apply_development(dev_button: development_button):
	var success = resources.attempt_purchase(dev_button.data.effects.cost)
	if(success):
		dev_button.visible = false
		previous_developments.append(dev_button.data.id)
		if(dev_button.data.effects.has("actions")):
			for action_id in dev_button.data.effects.actions:
				_action_panel.build_action_button(action_id)

func create_development_button(development : Variant):
	var id = development.id
	if(previous_developments.has(id)):
		return
	var new_button : development_button = development_package.instantiate()
	new_button.set_data(development)
	development_list.add_child(new_button)
	new_button.develop.connect(apply_development)
	if(!DevelopmentTranslatorSingle.data.has(id)):
		push_error(str("id ", id, " translation not found"))
		return
	new_button.set_label(DevelopmentTranslatorSingle.data[id].label)
	previous_developments.append(id)

func toggle_dev_panel():
	visible = !visible
