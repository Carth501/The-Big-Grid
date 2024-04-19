class_name Action_Panel extends Control

@onready var action_package := preload("res://scenes/display/ActionButton.tscn")
@export var action_manager : Action_Manager
var action_ids := []

func build_action_button(id : String):
	print(id)
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
	new_button.declare_focus.connect(announce_focus)
	new_button.end_focus.connect(unset_focus)

func push_action(id : String):
	action_manager.apply_action(id)

func set_filter(id : String):
	pass

func unset_filter():
	pass

func announce_focus(id : String):
	pass

func unset_focus():
	pass
