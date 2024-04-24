class_name Action_Panel extends Control

@onready var action_package := preload("res://scenes/display/ActionButton.tscn")
@export var action_manager : Action_Manager
@export var filter_foreman : Filter_Foreman
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
	new_button.attempt.connect(push_action)
	if(!ActionTranslatorSingle.data.has(id)):
		push_error(str("id ", id, " translation not found"))
		return
	new_button.change_label(ActionTranslatorSingle.data[id])
	action_ids.append(id)
	new_button.declare_changes.connect(set_filter)
	new_button.end_filter.connect(unset_filter)
	new_button.declare_focus.connect(set_focus)
	new_button.end_focus.connect(unset_focus)
	var action_logic = action_manager.full_action_list[id]
	new_button.connect_logic(action_logic)

func push_action(id : String):
	action_manager.apply_action(id)

func set_filter(id : String):
	filter_foreman.set_action_primary_filter(id)

func unset_filter():
	filter_foreman.clear_primary_filter()

func set_focus(id : String):
	filter_foreman.set_action_secondary_filter(id)

func unset_focus():
	filter_foreman.clear_secondary_filter()
