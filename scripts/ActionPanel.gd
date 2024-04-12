class_name action_panel extends Control

signal attempt_action(changes : Variant)
signal declare_filter(filter : Dictionary)
signal end_filter
signal declare_focus(filter : Dictionary)
signal end_focus

@export var starting_actions : Array[String]
@export var button_container : Control
@onready var action_package := preload("res://scenes/Action.tscn")
var action_ids := []

func _ready():
	for action_id in starting_actions:
		build_action_button(action_id)

func build_action_button(id : String):
	if(action_ids.has(id)):
		return
	if(!ActionsSingle.data.has(id)):
		push_error(str("id ", id, " not found"))
		return
	var action_definition = ActionsSingle.data[id]
	var new_button : action = action_package.instantiate()
	new_button.set_change(action_definition.changes)
	button_container.add_child(new_button)
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
	

func push_action(changes: Variant):
	print(changes)
	attempt_action.emit(changes)

func set_filter(filter : Dictionary):
	declare_filter.emit(filter)

func unset_filter():
	end_filter.emit()

func announce_focus(filter : Dictionary):
	declare_focus.emit(filter)

func unset_focus():
	end_focus.emit()
