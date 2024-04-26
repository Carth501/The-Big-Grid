class_name Action_Panel extends Control

@onready var action_package := preload("res://scenes/display/ActionButton.tscn")
@export var action_manager : Action_Manager
@export var supply_collection : Supply_Collection
var action_ids := []

func build_action_button(id : String):
	if(action_ids.has(id)):
		push_error(str("action button already exists for ", id))
		return
	if(!ActionsSingle.data.has(id)):
		push_error(str("id ", id, " not found"))
		return
	var new_button : Action_Button = action_package.instantiate()
	new_button.set_id(id)
	add_child(new_button)
	if(!ActionTranslatorSingle.data.has(id)):
		push_error(str("id ", id, " translation not found"))
		return
	new_button.change_label(ActionTranslatorSingle.data[id])
	action_ids.append(id)
	var action_logic = action_manager.full_action_list[id]
	new_button.connect_logic(action_logic)
