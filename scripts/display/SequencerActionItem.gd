class_name Sequencer_Action_Item extends Control

signal remove(index)
signal begin_fill(index)

var action : Action
@export var action_controls : Control
@export var empty_button : Button
@export var action_button : Action_Button
@export var number_label : Label
var index : int

func set_action(new_action : Action):
	action = new_action
	if(action == null):
		empty_button.visible = true
		action_controls.visible = false
		return
	else:
		empty_button.visible = false
		action_controls.visible = true
		action_button.set_id(action.id)
		action_button.connect_logic(action)

func set_index(value : int):
	index = value
	number_label.text = str(index + 1)

func remove_action():
	remove.emit(index)

func begin_slot_fill():
	begin_fill.emit(index)
